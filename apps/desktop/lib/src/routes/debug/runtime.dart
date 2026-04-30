import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../i18n/i18n.dart';
import '../../services/runtime.dart';
import '../../utils/platform_util.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/ui/button.dart';

List<RouteBase> get $appRoutes => <RouteBase>[
  GoRoute(
    path: '/debug/runtime',
    builder: (BuildContext context, GoRouterState state) {
      return const RuntimeDebugRoutePage();
    },
  ),
];

class RuntimeDebugRoutePage extends StatelessWidget {
  const RuntimeDebugRoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(t.page_runtime_debug.title),
      ),
      body: const RuntimeDebugPage(),
    );
  }
}

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

  List<RustProviderEntry> _providers = const [];
  String? _providerId;
  bool _loadingProviders = true;
  bool _submitting = false;
  TranslateResponse? _response;
  LookUpResponse? _lookupResponse;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _loadProviders();
  }

  @override
  void dispose() {
    _sourceLanguageController.dispose();
    _targetLanguageController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _loadProviders() async {
    try {
      final providers = await runtime.settings.listProviders();
      if (!mounted) {
        return;
      }
      setState(() {
        _providers = providers;
        _providerId = providers.isEmpty ? null : providers.first.id;
        _loadingProviders = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _providers = const [];
        _providerId = null;
        _loadingProviders = false;
        _errorText = error.toString();
      });
    }
  }

  Future<void> _submit() async {
    final formState = _formKey.currentState;
    final providerId = _providerId;
    if (providerId == null || formState == null || !formState.validate()) {
      return;
    }

    setState(() {
      _submitting = true;
      _errorText = null;
      _response = null;
      _lookupResponse = null;
    });

    try {
      if (_isLookupProvider) {
        final response = await runtime.dictionary(providerId).lookup(
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
        final response = await runtime.translation(providerId).translate(
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
    if (_loadingProviders) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_providers.isEmpty) {
      return Text(
        'No configured providers found. Save a provider in settings first.',
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }

    return SegmentedButton<String>(
      segments: _providers
          .map(
            (provider) => ButtonSegment<String>(
              value: provider.id,
              label: Text('${provider.id} (${provider.type})'),
            ),
          )
          .toList(),
      selected: _providerId == null ? const <String>{} : {_providerId!},
      onSelectionChanged: (selection) {
        setState(() {
          _providerId = selection.first;
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

  String _formatResponse(TranslateResponse response) {
    final buffer = StringBuffer()
      ..writeln('provider: ${_providerId ?? 'null'}')
      ..writeln('translations:');

    for (final translation in response.translations) {
      buffer.writeln('- ${translation.text}');
      buffer.writeln(
        '  detected_source_language: ${translation.detectedSourceLanguage ?? 'null'}',
      );
      buffer.writeln('  audio_url: ${translation.audioUrl ?? 'null'}');
    }

    return buffer.toString().trimRight();
  }

  String _formatLookupResponse(LookUpResponse response) {
    final buffer = StringBuffer()
      ..writeln('provider: ${_providerId ?? 'null'}')
      ..writeln('word: ${response.word ?? 'null'}');

    final definitions = response.definitions ?? const [];
    if (definitions.isNotEmpty) {
      buffer.writeln('definitions:');
      for (final definition in definitions) {
        final name = definition.name ?? '';
        final values = (definition.values ?? const []).join(', ');
        final line = <String>[
          name,
          values,
        ].where((item) => item.isNotEmpty).join(' ');
        if (line.isNotEmpty) {
          buffer.writeln('- $line');
        }
      }
    }

    final pronunciations = response.pronunciations ?? const [];
    if (pronunciations.isNotEmpty) {
      buffer.writeln('pronunciations:');
      for (final pronunciation in pronunciations) {
        final parts = [
          pronunciation.type,
          pronunciation.phoneticSymbol,
          pronunciation.audioUrl,
        ].whereType<String>().where((item) => item.isNotEmpty);
        final line = parts.join(' | ');
        if (line.isNotEmpty) {
          buffer.writeln('- $line');
        }
      }
    }

    final tenses = response.tenses ?? const [];
    if (tenses.isNotEmpty) {
      buffer.writeln('tenses:');
      for (final tense in tenses) {
        final name = tense.name ?? '';
        final values = (tense.values ?? const []).join(', ');
        final line = <String>[
          name,
          values,
        ].where((item) => item.isNotEmpty).join(': ');
        if (line.isNotEmpty) {
          buffer.writeln('- $line');
        }
      }
    }

    return buffer.toString().trimRight();
  }

  String? get _selectedProviderType {
    final providerId = _providerId;
    if (providerId == null) {
      return null;
    }
    for (final provider in _providers) {
      if (provider.id == providerId) {
        return provider.type;
      }
    }
    return null;
  }

  bool get _isLookupProvider => _selectedProviderType == 'iciba';

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
          const SizedBox(height: 20),
          Text(
            t.page_runtime_debug.request_section_title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _sourceLanguageController,
            decoration: _decoration(
              context,
              t.page_runtime_debug.source_language_label,
            ),
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
              context,
              t.page_runtime_debug.target_language_label,
            ),
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
                onPressed:
                    _submitting || _loadingProviders || _providerId == null
                        ? null
                        : _submit,
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
