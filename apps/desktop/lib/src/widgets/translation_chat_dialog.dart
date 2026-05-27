import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';
import 'package:flutter/material.dart';

import '../services/runtime.dart';

/// A chat dialog for discussing a translation with the LLM.
///
/// Opens as a modal dialog with:
/// - Context display (source + translation)
/// - Chat message history
/// - Text input for follow-up questions
class TranslationChatDialog extends StatefulWidget {
  const TranslationChatDialog({
    super.key,
    required this.sourceText,
    required this.translatedText,
    required this.sourceLang,
    required this.targetLang,
    required this.llmProviderId,
    this.llmModel,
  });

  /// The original source text.
  final String sourceText;

  /// The translated text being discussed.
  final String translatedText;

  /// Source language code.
  final String sourceLang;

  /// Target language code.
  final String targetLang;

  /// LLM provider ID to use.
  final String llmProviderId;

  /// Optional model override.
  final String? llmModel;

  @override
  State<TranslationChatDialog> createState() => _TranslationChatDialogState();
}

class _TranslationChatDialogState extends State<TranslationChatDialog> {
  final _messages = <_ChatEntry>[];
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _isLoading = false;

  String get _systemPrompt => '''
You are a translation assistant discussing a translation.

Source language: ${widget.sourceLang}
Target language: ${widget.targetLang}

Original source text:
"""
${widget.sourceText}
"""

Translation:
"""
${widget.translatedText}
"""

Answer the user's questions about this translation. Discuss:
- Why certain word choices were made
- Alternative phrasings
- Cultural or contextual considerations
- Grammar and style points

Be concise and helpful. Respond in the same language as the user's question.''';

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(_ChatEntry(role: 'user', content: text));
      _controller.clear();
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      final messages = <ChatMessage>[
        ChatMessage(role: ChatRole.system, content: _systemPrompt),
        for (final msg in _messages)
          ChatMessage(
            role: msg.role == 'user' ? ChatRole.user : ChatRole.assistant,
            content: msg.content,
          ),
      ];

      final response = await runtime.llm(providerId: widget.llmProviderId).chat(
            model: widget.llmModel ?? '',
            messages: messages,
          );

      final reply = response.choices.first.message.content;

      if (mounted) {
        setState(() {
          _messages.add(_ChatEntry(role: 'assistant', content: reply));
          _isLoading = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(_ChatEntry(
            role: 'assistant',
            content: 'Sorry, something went wrong: $e',
          ));
          _isLoading = false;
        });
        _scrollToBottom();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Discuss Translation'),
      content: SizedBox(
        width: 500,
        height: 450,
        child: Column(
          children: [
            // Context section
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Source (${widget.sourceLang})',
                    style: theme.textTheme.labelSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.sourceText,
                    style: theme.textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Translation (${widget.targetLang})',
                    style: theme.textTheme.labelSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.translatedText,
                    style: theme.textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Chat messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isLoading && index == _messages.length) {
                    return const _LoadingBubble();
                  }
                  final msg = _messages[index];
                  return _ChatBubble(
                    content: msg.content,
                    isUser: msg.role == 'user',
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            // Input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Ask about this translation...',
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _isLoading ? null : _sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class _ChatEntry {
  final String role; // "user" or "assistant"
  final String content;
  _ChatEntry({required this.role, required this.content});
}

class _ChatBubble extends StatelessWidget {
  final String content;
  final bool isUser;

  const _ChatBubble({required this.content, required this.isUser});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isUser
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SelectableText(
                content,
                style: theme.textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingBubble extends StatelessWidget {
  const _LoadingBubble();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 8),
          Text('Thinking...'),
        ],
      ),
    );
  }
}
