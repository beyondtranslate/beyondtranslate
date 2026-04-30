import 'package:flutter/material.dart';

import '../../i18n/i18n.dart';
import '../../services/runtime.dart';
import '../../utils/platform_util.dart';
import '../../widgets/ui/button.dart';

const List<String> _kProviderOptions = ['deepl', 'google', 'iciba'];
const String _kDefaultDeepLConfig = 'type: deepl\napi_key: YOUR_DEEPL_API_KEY';
const String _kDefaultGoogleConfig =
    'type: google\napi_key: YOUR_GOOGLE_API_KEY';
const String _kDefaultIcibaConfig = 'type: iciba\napi_key: YOUR_ICIBA_API_KEY';

class RuntimeDebugPage extends StatefulWidget {
  const RuntimeDebugPage({super.key});

  @override
  State<RuntimeDebugPage> createState() => _RuntimeDebugPageState();
}

class _RuntimeDebugPageState extends State<RuntimeDebugPage> {
  final _formKey = GlobalKey<FormState>();
  final _sourceLanguageController = TextEditingController(text: 'en');
  final _targetLanguageController = TextEditingController(text: 'zh');
  final _textController = TextEditingController(text: 'Hello world');
  late final TextEditingController _providerConfigController =
      TextEditingController(text: _configTemplateFor(_providerId));

  String _providerId = _kProviderOptions.first;
  bool _submitting = false;
  RustTranslateResponse? _response;
  RustLookupResponse? _lookupResponse;
  String? _errorText;

  @override
  void dispose() {
    _sourceLanguageController.dispose();
    _targetLanguageController.dispose();
    _textController.dispose();
    _providerConfigController.dispose();
    super.dispose();
  }

  String _configTemplateFor(String providerId) {
    switch (providerId) {
      case 'iciba':
        return _kDefaultIcibaConfig;
      case 'google':
        return _kDefaultGoogleConfig;
      case 'deepl':
      default:
        return _kDefaultDeepLConfig;
    }
  }

  Future<void> _submit() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    setState(() {
      _submitting = true;
      _errorText = null;
      _response = null;
      _lookupResponse = null;
    });

    try {
      if (_providerId == 'iciba') {
        final response = await runtime.dictionary(_providerId).lookup(
              providerConfigYaml: _providerConfigController.text,
              sourceLanguage: _sourceLanguageController.text.trim(),
              targetLanguage: _targetLanguageController.text.trim(),
              word: _textController.text,
            );

        if (!mounted) {
          return;
        }
        setState(() {
          _lookupResponse = response;
        });
      } else {
        final response = await runtime.translation(_providerId).translate(
              providerConfigYaml: _providerConfigController.text,
              sourceLanguage: _sourceLanguageController.text.trim().isEmpty
                  ? null
                  : _sourceLanguageController.text.trim(),
              targetLanguage: _targetLanguageController.text.trim(),
              text: _textController.text,
            );

        if (!mounted) {
          return;
        }
        setState(() {
          _response = response;
        });
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _response = null;
        _lookupResponse = null;
        _errorText = error.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
        });
      }
    }
  }

  InputDecoration _decoration(BuildContext context, String label) {
    return InputDecoration(
      labelText: label,
      alignLabelWithHint: true,
      border: const OutlineInputBorder(),
      filled: true,
      fillColor: Theme.of(context).canvasColor,
    );
  }

  Widget _buildProviderPicker(BuildContext context) {
    return SegmentedButton<String>(
      segments: _kProviderOptions
          .map(
            (provider) => ButtonSegment<String>(
              value: provider,
              label: Text(provider),
            ),
          )
          .toList(),
      selected: {_providerId},
      onSelectionChanged: (selection) {
        final nextProviderId = selection.first;
        setState(() {
          _providerId = nextProviderId;
          _providerConfigController.text = _configTemplateFor(nextProviderId);
        });
      },
    );
  }

  Widget _buildResultCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasResult = _response != null || _lookupResponse != null;
    final isError = _errorText != null;

    final title = isError
        ? t.page_runtime_debug.result_error
        : hasResult
            ? t.page_runtime_debug.result_success
            : t.page_runtime_debug.result_idle;
    final content = isError
        ? _errorText!
        : _response != null
            ? _formatResponse(_response!)
            : _lookupResponse != null
                ? _formatLookupResponse(_lookupResponse!)
                : t.page_runtime_debug.result_idle_description;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isError
              ? colorScheme.error.withValues(alpha: 0.35)
              : colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          SelectableText(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: 'Roboto Mono',
                  height: 1.4,
                ),
          ),
        ],
      ),
    );
  }

  String _formatResponse(RustTranslateResponse response) {
    final buffer = StringBuffer()
      ..writeln('provider: ${response.providerId}')
      ..writeln(
        'detected_source_language: ${response.detectedSourceLanguage ?? 'null'}',
      )
      ..writeln('translations:');

    for (final translation in response.translations) {
      buffer.writeln('- $translation');
    }

    return buffer.toString().trimRight();
  }

  String _formatLookupResponse(RustLookupResponse response) {
    final buffer = StringBuffer()
      ..writeln('provider: ${response.providerId}')
      ..writeln('word: ${response.word ?? 'null'}');

    if (response.definitions.isNotEmpty) {
      buffer.writeln('definitions:');
      for (final definition in response.definitions) {
        buffer.writeln('- $definition');
      }
    }

    if (response.pronunciations.isNotEmpty) {
      buffer.writeln('pronunciations:');
      for (final pronunciation in response.pronunciations) {
        buffer.writeln('- $pronunciation');
      }
    }

    if (response.tenses.isNotEmpty) {
      buffer.writeln('tenses:');
      for (final tense in response.tenses) {
        buffer.writeln('- $tense');
      }
    }

    return buffer.toString().trimRight();
  }

  bool get _isLookupProvider => _providerId == 'iciba';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            t.page_runtime_debug.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (!kIsMacOS) ...[
            const SizedBox(height: 12),
            Text(
              t.page_runtime_debug.mac_only_note,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: 20),
          Text(
            t.page_runtime_debug.provider_section_title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          _buildProviderPicker(context),
          const SizedBox(height: 16),
          TextFormField(
            controller: _providerConfigController,
            minLines: 6,
            maxLines: 10,
            decoration: _decoration(
                context, t.page_runtime_debug.provider_config_label),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return t.page_runtime_debug.validation_provider_config_required;
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          Text(
            t.page_runtime_debug.request_section_title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _sourceLanguageController,
            decoration: _decoration(
                context, t.page_runtime_debug.source_language_label),
            validator: (value) {
              if (_isLookupProvider &&
                  (value == null || value.trim().isEmpty)) {
                return t.page_runtime_debug.validation_source_language_required;
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _targetLanguageController,
            decoration: _decoration(
                context, t.page_runtime_debug.target_language_label),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return t.page_runtime_debug.validation_target_language_required;
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _textController,
            minLines: 4,
            maxLines: 8,
            decoration: _decoration(
              context,
              _isLookupProvider
                  ? t.page_runtime_debug.word_label
                  : t.page_runtime_debug.text_label,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return _isLookupProvider
                    ? t.page_runtime_debug.validation_word_required
                    : t.page_runtime_debug.validation_text_required;
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Button.filled(
                processing: _submitting,
                onPressed: _submitting ? null : _submit,
                child: Text(
                  _isLookupProvider
                      ? t.page_runtime_debug.lookup_submit
                      : t.page_runtime_debug.submit,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildResultCard(context),
        ],
      ),
    );
  }
}
