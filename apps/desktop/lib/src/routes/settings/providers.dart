import 'package:flutter/material.dart';

import '../../services/runtime.dart';
import '../../widgets/preference_list/preference_list.dart';
import '../../widgets/preference_list/preference_list_section.dart';
import '../../widgets/ui/button.dart';

class ProvidersSettingsPage extends StatefulWidget {
  const ProvidersSettingsPage({super.key});

  @override
  State<ProvidersSettingsPage> createState() => _ProvidersSettingsPageState();
}

class _ProvidersSettingsPageState extends State<ProvidersSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _providerIdController = TextEditingController();
  final _configYamlController = TextEditingController();

  List<ProviderConfigEntry> _providers = const [];
  String? _selectedProviderId;
  bool _loading = true;
  bool _saving = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  @override
  void dispose() {
    _providerIdController.dispose();
    _configYamlController.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    setState(() {
      _loading = true;
      _errorText = null;
    });

    try {
      final providers = await runtime.settings().listProviders();
      if (!mounted) {
        return;
      }

      final selectedProviderId = _selectedProviderId;
      final selectedProviderExists = selectedProviderId != null &&
          providers.any((item) => item.id == selectedProviderId);
      final nextSelectedProviderId = selectedProviderExists
          ? selectedProviderId
          : (providers.isEmpty ? null : providers.first.id);

      setState(() {
        _providers = providers;
        _selectedProviderId = nextSelectedProviderId;
        _loading = false;
      });

      final currentProviderId = _selectedProviderId;
      if (currentProviderId != null) {
        await _loadProviderIntoEditor(currentProviderId);
      } else {
        _providerIdController.clear();
        _configYamlController.clear();
      }
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _providers = const [];
        _selectedProviderId = null;
        _loading = false;
        _errorText = error.toString();
      });
    }
  }

  Future<void> _loadProviderIntoEditor(String providerId) async {
    try {
      final provider =
          await runtime.settings().getProvider(providerId: providerId);
      if (!mounted) {
        return;
      }

      setState(() {
        _providerIdController.text = provider?.id ?? providerId;
        _configYamlController.text = provider?.configYaml ?? '';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorText = error.toString();
      });
    }
  }

  Future<void> _saveProvider() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    setState(() {
      _saving = true;
      _errorText = null;
    });

    try {
      await runtime.settings().updateProvider(
            providerId: _providerIdController.text.trim(),
            configYaml: _configYamlController.text,
          );
      _selectedProviderId = _providerIdController.text.trim();
      await _reload();
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorText = error.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  Future<void> _deleteProvider() async {
    final providerId = _providerIdController.text.trim();
    if (providerId.isEmpty) {
      return;
    }

    setState(() {
      _saving = true;
      _errorText = null;
    });

    try {
      await runtime.settings().deleteProvider(providerId: providerId);
      if (!mounted) {
        return;
      }
      _providerIdController.clear();
      _configYamlController.clear();
      _selectedProviderId = null;
      await _reload();
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorText = error.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  void _newProvider() {
    setState(() {
      _selectedProviderId = null;
      _errorText = null;
      _providerIdController.clear();
      _configYamlController.clear();
    });
  }

  Widget _buildProviderPicker(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_providers.isEmpty) {
      return Text(
        'No providers yet. Create one below.',
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
      selected: _selectedProviderId == null
          ? const <String>{}
          : {_selectedProviderId!},
      onSelectionChanged: (selection) async {
        final providerId = selection.first;
        setState(() {
          _selectedProviderId = providerId;
          _errorText = null;
        });
        await _loadProviderIntoEditor(providerId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: PreferenceList(
        padding: const EdgeInsets.only(top: 16, bottom: 16),
        children: [
          PreferenceListSection(
            title: const Text('Providers'),
            description: const Text(
              'Create, update, and delete runtime providers stored by the Rust runtime.',
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProviderPicker(context),
                    if (_errorText != null) ...[
                      const SizedBox(height: 12),
                      SelectableText(
                        _errorText!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          PreferenceListSection(
            title: const Text('Edit Provider'),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _providerIdController,
                      decoration: const InputDecoration(
                        labelText: 'Provider ID',
                        border: OutlineInputBorder(),
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Provider ID is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _configYamlController,
                      minLines: 10,
                      maxLines: 20,
                      decoration: const InputDecoration(
                        labelText: 'Provider Config YAML',
                        border: OutlineInputBorder(),
                        filled: true,
                        alignLabelWithHint: true,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Provider config YAML is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Button.filled(
                          processing: _saving,
                          onPressed: _saving || _loading ? null : _saveProvider,
                          child: const Text('Save / Update'),
                        ),
                        const SizedBox(width: 12),
                        Button.outlined(
                          processing: _saving,
                          onPressed:
                              _saving || _loading ? null : _deleteProvider,
                          child: const Text('Delete'),
                        ),
                        const SizedBox(width: 12),
                        Button.outlined(
                          onPressed: _saving ? null : _newProvider,
                          child: const Text('New'),
                        ),
                        const SizedBox(width: 12),
                        Button.outlined(
                          onPressed: _saving || _loading ? null : _reload,
                          child: const Text('Refresh'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
