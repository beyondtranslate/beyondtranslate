import 'package:flutter/material.dart';

import '../services/runtime.dart';
import 'translation_chat_dialog.dart';

/// A row of AI-powered action buttons shown alongside a translation result.
///
/// Actions:
/// - ✨ Polish: Improve the translation's fluency/expression
/// - 📋 Alternatives: Show alternative translations
/// - 💡 Explain: Explain why this translation was chosen
/// - 💬 Chat: Open a dialogue to discuss the translation
class AiActionBar extends StatelessWidget {
  const AiActionBar({
    super.key,
    required this.translatedText,
    required this.sourceText,
    required this.llmProviderId,
    this.sourceLang = 'auto',
    this.targetLang = 'en',
    this.onPolish,
    this.onAlternatives,
    this.onExplain,
    this.compact = false,
  });

  /// The translated text to operate on.
  final String translatedText;

  /// The original source text.
  final String sourceText;

  /// The LLM provider ID to use for AI operations.
  final String llmProviderId;

  /// Source language code (for chat context).
  final String sourceLang;

  /// Target language code (for chat context).
  final String targetLang;

  /// Called with the polished translation text.
  final ValueChanged<String>? onPolish;

  /// Called with a list of alternative translations.
  final ValueChanged<List<String>>? onAlternatives;

  /// Called with the explanation text.
  final ValueChanged<String>? onExplain;

  /// When true, shows icon-only buttons in a compact row.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompact(context);
    }
    return _buildFull(context);
  }

  Widget _buildCompact(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _AiIconButton(
          icon: Icons.auto_fix_high,
          tooltip: 'Polish',
          onTap: () => _handlePolish(context),
        ),
        _AiIconButton(
          icon: Icons.format_list_bulleted,
          tooltip: 'Alternatives',
          onTap: () => _handleAlternatives(context),
        ),
        _AiIconButton(
          icon: Icons.lightbulb_outline,
          tooltip: 'Explain',
          onTap: () => _handleExplain(context),
        ),
        _AiIconButton(
          icon: Icons.chat_bubble_outline,
          tooltip: 'Chat',
          onTap: () => _handleChat(context),
        ),
      ],
    );
  }

  Widget _buildFull(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _AiButton(
          icon: Icons.auto_fix_high,
          label: 'Polish',
          onTap: () => _handlePolish(context),
        ),
        const SizedBox(width: 6),
        _AiButton(
          icon: Icons.format_list_bulleted,
          label: 'Alternatives',
          onTap: () => _handleAlternatives(context),
        ),
        const SizedBox(width: 6),
        _AiButton(
          icon: Icons.lightbulb_outline,
          label: 'Explain',
          onTap: () => _handleExplain(context),
        ),
        const SizedBox(width: 6),
        _AiButton(
          icon: Icons.chat_bubble_outline,
          label: 'Chat',
          onTap: () => _handleChat(context),
        ),
      ],
    );
  }

  Future<void> _handlePolish(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final result = await runtime
          .llm(providerId: llmProviderId)
          .polish(text: translatedText, style: 'natural and fluent');
      onPolish?.call(result);
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Polish failed: $e')),
      );
    }
  }

  Future<void> _handleAlternatives(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final result = await runtime.llm(providerId: llmProviderId).alternatives(
            text: sourceText,
            sourceLang: 'auto',
            targetLang: 'en',
            count: 3,
            style: null,
          );
      onAlternatives?.call(result);
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Alternatives failed: $e')),
      );
    }
  }

  Future<void> _handleExplain(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final result = await runtime.llm(providerId: llmProviderId).explain(
            source: sourceText,
            translation: translatedText,
          );
      onExplain?.call(result);
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Explain failed: $e')),
      );
    }
  }

  void _handleChat(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => TranslationChatDialog(
        sourceText: sourceText,
        translatedText: translatedText,
        sourceLang: sourceLang,
        targetLang: targetLang,
        llmProviderId: llmProviderId,
      ),
    );
  }
}

class _AiButton extends StatelessWidget {
  const _AiButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 14),
      label: Text(label, style: theme.textTheme.labelSmall),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

class _AiIconButton extends StatelessWidget {
  const _AiIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, size: 14),
        ),
      ),
    );
  }
}
