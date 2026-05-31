import 'package:flutter/material.dart';

import '../../i18n/i18n.dart';
import '../../services/runtime.dart';
import '../../services/settings_store.dart';
import '../../widgets/settings_page.dart';
import '../../widgets/translation_engine_icon/translation_engine_icon.dart';
import '../../widgets/ui/button.dart';
import '../../widgets/ui/preference_list_item.dart';
import '../../widgets/ui/preference_list_section.dart';

/// Mirrors macOS `ProvidersView.swift`.
class ProvidersSettingsPage extends StatefulWidget {
  const ProvidersSettingsPage({super.key});

  @override
  State<ProvidersSettingsPage> createState() => _ProvidersSettingsPageState();
}

class _ProvidersSettingsPageState extends State<ProvidersSettingsPage> {
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    settingsStore.addListener(_handleChanged);
    _reload();
  }

  @override
  void dispose() {
    settingsStore.removeListener(_handleChanged);
    super.dispose();
  }

  void _handleChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _reload() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await Future.wait([
        settingsStore.reloadProviders(),
        settingsStore.reloadServices(),
      ]);
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _openEditor({ProviderConfigEntry? existing}) async {
    final draft = await showDialog<_ProviderDraft>(
      context: context,
      builder: (_) => _ProviderEditorDialog(existing: existing),
    );
    if (draft == null) return;

    try {
      await runtime.settings().updateProvider(
            providerId: draft.id,
            providerType: _providerTypeValue(draft.type),
            fields: draft.fields,
          );
      await Future.wait([
        settingsStore.reloadProviders(),
        settingsStore.reloadServices(),
      ]);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.toString();
      });
    }
  }

  Future<void> _deleteProvider(ProviderConfigEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          formatTranslation(
            t.settings.providers.delete_dialog.title,
            args: [entry.id],
          ),
        ),
        content: Text(t.settings.providers.delete_dialog.message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.common.ui.button.cancel),
          ),
          FilledButton.tonal(
            style: FilledButton.styleFrom(
              foregroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(t.common.ui.button.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await runtime.settings().deleteProvider(providerId: entry.id);
      await Future.wait([
        settingsStore.reloadProviders(),
        settingsStore.reloadServices(),
      ]);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.toString();
      });
    }
  }

  Future<void> _openServiceEditor({ServiceConfigEntry? existing}) async {
    final draft = await showDialog<_ServiceDraft>(
      context: context,
      builder: (_) => _ServiceEditorDialog(existing: existing),
    );
    if (draft == null) return;

    try {
      await runtime.settings().updateService(
            serviceId: draft.id,
            providerId: draft.providerId,
            serviceType: draft.type,
            name: draft.name,
            fields: draft.fields,
          );
      await settingsStore.reloadServices();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.toString();
      });
    }
  }

  Future<void> _deleteService(ServiceConfigEntry entry) async {
    try {
      await runtime.settings().deleteService(serviceId: entry.id);
      await settingsStore.reloadServices();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final providers = settingsStore.providers;
    final services = settingsStore.services;
    final providersText = t.settings.providers;

    return SettingsPage(
      title: providersText.title,
      children: [
        PreferenceListSection(
          title: const Text('Providers'),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    providersText.intro.body,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    providersText.intro.warning,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        PreferenceListSection(
          title: const Text('Services'),
          children: [
            if (_isLoading)
              const SizedBox.shrink()
            else if (services.isEmpty)
              const PreferenceListItem(
                title: Text('No services available.'),
                accessoryView: SizedBox.shrink(),
              )
            else
              for (final service in services)
                _ServiceRow(
                  service: service,
                  provider: _providerFor(providers, service.providerId),
                  onEdit: service.id == service.providerId
                      ? null
                      : () => _openServiceEditor(existing: service),
                  onDelete: service.id == service.providerId
                      ? null
                      : () => _deleteService(service),
                ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  const Spacer(),
                  Button.outlined(
                    onPressed: () => _openServiceEditor(),
                    child: const Text('Add a Service...'),
                  ),
                ],
              ),
            ),
          ],
        ),
        PreferenceListSection(
          children: [
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 12),
                    Text(providersText.item.loading),
                  ],
                ),
              )
            else if (providers.isEmpty)
              const _EmptyProviderRow()
            else
              for (final provider in providers)
                _ProviderRow(
                  provider: provider,
                  onEdit: () => _openEditor(existing: provider),
                  onDelete: () => _deleteProvider(provider),
                ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  const Spacer(),
                  Button.outlined(
                    onPressed: () => _openEditor(),
                    child: Text(providersText.button.add),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (_errorMessage != null)
          PreferenceListSection(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: SelectableText(
                  _errorMessage!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  ProviderConfigEntry? _providerFor(
    List<ProviderConfigEntry> providers,
    String providerId,
  ) {
    for (final provider in providers) {
      if (provider.id == providerId) return provider;
    }
    return null;
  }
}

class _ProviderRow extends StatelessWidget {
  const _ProviderRow({
    required this.provider,
    required this.onEdit,
    required this.onDelete,
  });

  final ProviderConfigEntry provider;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return PreferenceListItem(
      icon: _ProviderTypeIcon(type: provider.type),
      title: Text(_providerTypeDisplayName(provider.type)),
      summary: Text(provider.id),
      onTap: onEdit,
      accessoryView: PopupMenuButton<String>(
        onSelected: (value) {
          switch (value) {
            case 'edit':
              onEdit();
              break;
            case 'delete':
              onDelete();
              break;
          }
        },
        itemBuilder: (_) => [
          PopupMenuItem<String>(
            value: 'edit',
            child: Text(t.common.ui.button.edit),
          ),
          const PopupMenuDivider(),
          PopupMenuItem<String>(
            value: 'delete',
            child: Text(t.common.ui.button.delete),
          ),
        ],
      ),
    );
  }
}

class _ServiceRow extends StatelessWidget {
  const _ServiceRow({
    required this.service,
    required this.provider,
    required this.onEdit,
    required this.onDelete,
  });

  final ServiceConfigEntry service;
  final ProviderConfigEntry? provider;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final providerType = provider?.type;
    final serviceName = service.name.isEmpty ? service.id : service.name;
    return PreferenceListItem(
      icon: providerType == null ? null : _ProviderTypeIcon(type: providerType),
      title: Text(serviceName),
      summary:
          Text('${_serviceTypeLabel(service.type)} · ${service.providerId}'),
      detailText: Text(service.id),
      onTap: onEdit,
      accessoryView: onEdit == null && onDelete == null
          ? const SizedBox.shrink()
          : PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    onEdit?.call();
                    break;
                  case 'delete':
                    onDelete?.call();
                    break;
                }
              },
              itemBuilder: (_) => [
                if (onEdit != null)
                  PopupMenuItem<String>(
                    value: 'edit',
                    child: Text(t.common.ui.button.edit),
                  ),
                if (onEdit != null && onDelete != null)
                  const PopupMenuDivider(),
                if (onDelete != null)
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Text(t.common.ui.button.delete),
                  ),
              ],
            ),
    );
  }
}

String _serviceTypeLabel(ServiceType type) {
  switch (type) {
    case ServiceType.dictionary:
      return 'Dictionary';
    case ServiceType.ocr:
      return 'OCR';
    case ServiceType.translation:
      return 'Translation';
    case ServiceType.llm:
      return 'AI';
  }
}

class _EmptyProviderRow extends StatelessWidget {
  const _EmptyProviderRow();

  @override
  Widget build(BuildContext context) {
    return PreferenceListItem(
      icon: Icon(
        Icons.layers_clear_outlined,
        size: 22,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      title: Text(
        t.settings.providers.item.empty,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      accessoryView: const SizedBox.shrink(),
    );
  }
}

class _ProviderTypeIcon extends StatelessWidget {
  const _ProviderTypeIcon({required this.type});

  final ProviderType type;

  @override
  Widget build(BuildContext context) {
    return TranslationEngineIcon(_providerTypeValue(type), size: 22);
  }
}

class _ServiceDraft {
  _ServiceDraft({
    required this.id,
    required this.providerId,
    required this.type,
    required this.name,
    required this.fields,
  });

  final String id;
  final String providerId;
  final ServiceType type;
  final String name;
  final Map<String, String> fields;
}

class _ServiceEditorDialog extends StatefulWidget {
  const _ServiceEditorDialog({this.existing});

  final ServiceConfigEntry? existing;

  @override
  State<_ServiceEditorDialog> createState() => _ServiceEditorDialogState();
}

class _ServiceEditorDialogState extends State<_ServiceEditorDialog> {
  late final TextEditingController _idController;
  late final TextEditingController _nameController;
  late final TextEditingController _modelController;
  late final TextEditingController _systemPromptController;
  late String _providerId;
  late ServiceType _type;

  List<ProviderConfigEntry> get _aiProviders {
    return settingsStore.providers
        .where((provider) =>
            provider.type == ProviderType.openAi ||
            provider.type == ProviderType.anthropic ||
            provider.type == ProviderType.ollama)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    final providers = _aiProviders;
    _idController = TextEditingController(text: existing?.id ?? '');
    _nameController = TextEditingController(text: existing?.name ?? '');
    _modelController = TextEditingController(
      text: existing?.fields['model'] ?? '',
    );
    _systemPromptController = TextEditingController(
      text: existing?.fields['systemPrompt'] ?? '',
    );
    _providerId =
        existing?.providerId ?? (providers.isEmpty ? '' : providers.first.id);
    _type = existing?.type ?? ServiceType.translation;
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _modelController.dispose();
    _systemPromptController.dispose();
    super.dispose();
  }

  bool get _canSave {
    return _idController.text.trim().isNotEmpty && _providerId.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;
    final providers = _aiProviders;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Service' : 'Add Service'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _idController,
                enabled: !isEditing,
                decoration: const InputDecoration(
                  labelText: 'Service ID',
                  hintText: 'e.g. openai-formal',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Display Name',
                  hintText: 'e.g. Formal translation',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _providerId.isEmpty ? null : _providerId,
                decoration: const InputDecoration(
                  labelText: 'AI Provider',
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final provider in providers)
                    DropdownMenuItem<String>(
                      value: provider.id,
                      child: Text(provider.id),
                    ),
                ],
                onChanged: isEditing
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() => _providerId = value);
                        }
                      },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<ServiceType>(
                initialValue: _type,
                decoration: const InputDecoration(
                  labelText: 'Service Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem<ServiceType>(
                    value: ServiceType.translation,
                    child: Text('Translation'),
                  ),
                  DropdownMenuItem<ServiceType>(
                    value: ServiceType.dictionary,
                    child: Text('Dictionary'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _type = value);
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _modelController,
                decoration: const InputDecoration(
                  labelText: 'Model Override',
                  hintText: 'Optional',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _systemPromptController,
                minLines: 4,
                maxLines: 8,
                decoration: const InputDecoration(
                  labelText: 'System Prompt',
                  hintText:
                      'Use {{sourceLanguage}}, {{targetLanguage}}, {{text}} if needed.',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(t.common.ui.button.cancel),
        ),
        FilledButton(
          onPressed: _canSave
              ? () {
                  Navigator.of(context).pop(
                    _ServiceDraft(
                      id: _idController.text.trim(),
                      providerId: _providerId,
                      type: _type,
                      name: _nameController.text.trim(),
                      fields: {
                        if (_modelController.text.trim().isNotEmpty)
                          'model': _modelController.text.trim(),
                        if (_systemPromptController.text.trim().isNotEmpty)
                          'systemPrompt': _systemPromptController.text.trim(),
                      },
                    ),
                  );
                }
              : null,
          child: Text(isEditing ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}

class _ProviderDraft {
  _ProviderDraft({
    required this.id,
    required this.type,
    required this.fields,
  });
  final String id;
  final ProviderType type;
  final Map<String, String> fields;
}

class _ProviderEditorDialog extends StatefulWidget {
  const _ProviderEditorDialog({this.existing});

  final ProviderConfigEntry? existing;

  @override
  State<_ProviderEditorDialog> createState() => _ProviderEditorDialogState();
}

class _ProviderEditorDialogState extends State<_ProviderEditorDialog> {
  late final TextEditingController _idController;
  ProviderType? _selectedType;
  late Map<String, TextEditingController> _fieldControllers;

  static const _knownProviderTypes = <ProviderType>[
    ProviderType.anthropic,
    ProviderType.baidu,
    ProviderType.caiyun,
    ProviderType.deepL,
    ProviderType.google,
    ProviderType.iciba,
    ProviderType.openAi,
    ProviderType.ollama,
    ProviderType.system,
    ProviderType.tencent,
    ProviderType.youdao,
  ];

  // Known field keys for each provider type. This intentionally mirrors the
  // `*ProviderConfig+Fields.swift` files (lowest common denominator).
  static const Map<ProviderType, List<String>> _providerFields = {
    ProviderType.anthropic: ['apiKey', 'baseUrl', 'defaultModel'],
    ProviderType.baidu: ['appId', 'appKey'],
    ProviderType.caiyun: ['token'],
    ProviderType.deepL: ['authKey'],
    ProviderType.google: ['apiKey'],
    ProviderType.iciba: [],
    ProviderType.openAi: ['apiKey', 'baseUrl', 'defaultModel'],
    ProviderType.ollama: ['baseUrl', 'defaultModel'],
    ProviderType.system: [],
    ProviderType.tencent: ['secretId', 'secretKey'],
    ProviderType.youdao: ['appKey', 'appSecret'],
  };

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _idController = TextEditingController(text: existing?.id ?? '');
    _selectedType = existing?.type;
    _fieldControllers = _buildControllers(_selectedType, existing?.fields);
  }

  Map<String, TextEditingController> _buildControllers(
    ProviderType? type,
    Map<String, String>? initial,
  ) {
    if (type == null) return {};
    final keys = _providerFields[type] ?? const <String>[];
    final controllers = <String, TextEditingController>{};
    for (final key in keys) {
      controllers[key] = TextEditingController(text: initial?[key] ?? '');
    }
    return controllers;
  }

  @override
  void dispose() {
    _idController.dispose();
    for (final c in _fieldControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _changeType(ProviderType type) {
    final preserved = {
      for (final entry in _fieldControllers.entries)
        entry.key: entry.value.text,
    };
    for (final c in _fieldControllers.values) {
      c.dispose();
    }
    setState(() {
      _selectedType = type;
      _fieldControllers = _buildControllers(type, preserved);
    });
  }

  bool get _canSave {
    if (_idController.text.trim().isEmpty) return false;
    if (widget.existing == null && _selectedType == null) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Provider' : 'Add Provider'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isEditing) ...[
                TextField(
                  controller: _idController,
                  decoration: const InputDecoration(
                    labelText: 'Provider ID',
                    hintText: 'e.g. my-provider',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<ProviderType>(
                  initialValue: _selectedType,
                  hint: const Text('Select a provider type...'),
                  items: [
                    for (final type in _knownProviderTypes)
                      DropdownMenuItem<ProviderType>(
                        value: type,
                        child: Text(_providerTypeDisplayName(type)),
                      ),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Provider Type',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) {
                    if (v != null) _changeType(v);
                  },
                ),
                const SizedBox(height: 16),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    '${widget.existing!.id} \u00b7 ${_providerTypeDisplayName(widget.existing!.type)}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
              for (final entry in _fieldControllers.entries) ...[
                TextField(
                  controller: entry.value,
                  decoration: InputDecoration(
                    labelText: entry.key,
                    border: const OutlineInputBorder(),
                  ),
                  obscureText: _isSecretField(entry.key),
                ),
                const SizedBox(height: 12),
              ],
              if (_fieldControllers.isEmpty)
                Text(
                  'No configuration fields required.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _canSave
              ? () {
                  final draft = _ProviderDraft(
                    id: _idController.text.trim(),
                    type: _selectedType!,
                    fields: {
                      for (final entry in _fieldControllers.entries)
                        entry.key: entry.value.text,
                    },
                  );
                  Navigator.of(context).pop(draft);
                }
              : null,
          child: Text(isEditing ? 'Save' : 'Add'),
        ),
      ],
    );
  }

  bool _isSecretField(String key) {
    final lower = key.toLowerCase();
    return lower.contains('key') ||
        lower.contains('secret') ||
        lower.contains('token') ||
        lower.contains('password');
  }
}

String _providerTypeValue(ProviderType type) {
  switch (type) {
    case ProviderType.anthropic:
      return 'anthropic';
    case ProviderType.baidu:
      return 'baidu';
    case ProviderType.caiyun:
      return 'caiyun';
    case ProviderType.deepL:
      return 'deepl';
    case ProviderType.google:
      return 'google';
    case ProviderType.iciba:
      return 'iciba';
    case ProviderType.openAi:
      return 'openai';
    case ProviderType.ollama:
      return 'ollama';
    case ProviderType.system:
      return 'system';
    case ProviderType.tencent:
      return 'tencent';
    case ProviderType.youdao:
      return 'youdao';
  }
}

String _providerTypeDisplayName(ProviderType type) {
  switch (type) {
    case ProviderType.anthropic:
      return t.common.provider.anthropic;
    case ProviderType.baidu:
      return t.common.provider.baidu;
    case ProviderType.caiyun:
      return t.common.provider.caiyun;
    case ProviderType.deepL:
      return t.common.provider.deepl;
    case ProviderType.google:
      return t.common.provider.google;
    case ProviderType.iciba:
      return t.common.provider.iciba;
    case ProviderType.openAi:
      return t.common.provider.openai;
    case ProviderType.ollama:
      return t.common.provider.ollama;
    case ProviderType.system:
      return t.common.provider.system;
    case ProviderType.tencent:
      return t.common.provider.tencent;
    case ProviderType.youdao:
      return t.common.provider.youdao;
  }
}
