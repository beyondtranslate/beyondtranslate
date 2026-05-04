import 'package:flutter/material.dart';

import '../../rust/domain/settings.dart';
import '../../services/settings_store.dart';
import '../../services/runtime.dart';
import '../../widgets/preference_list/preference_list.dart';
import '../../widgets/preference_list/preference_list_item.dart';
import '../../widgets/preference_list/preference_list_section.dart';
import '../../widgets/ui/button.dart';

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
      await settingsStore.reloadProviders();
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
            providerType: draft.type,
            fields: draft.fields,
          );
      await settingsStore.reloadProviders();
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
        title: Text('Delete "${entry.id}"?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton.tonal(
            style: FilledButton.styleFrom(
              foregroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await runtime.settings().deleteProvider(providerId: entry.id);
      await settingsStore.reloadProviders();
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

    return PreferenceList(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      children: [
        PreferenceListSection(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose the translation and dictionary providers used '
                    'by the app.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Providers you add may process the text you send, so '
                    'only connect services you trust.',
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
          children: [
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (providers.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Text(
                  'No providers configured. Add one to enable translation '
                  'services.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              )
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
                    child: const Text('Add a Provider...'),
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
      title: Text(provider.id),
      summary: Text(provider.type),
      detailText: Wrap(
        spacing: 4,
        children: [
          for (final cap in provider.capabilities) _CapabilityTag(label: cap),
        ],
      ),
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
        itemBuilder: (_) => const [
          PopupMenuItem<String>(value: 'edit', child: Text('Edit')),
          PopupMenuDivider(),
          PopupMenuItem<String>(value: 'delete', child: Text('Delete')),
        ],
      ),
    );
  }
}

class _CapabilityTag extends StatelessWidget {
  const _CapabilityTag({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = _capabilityColor(label, Theme.of(context).colorScheme);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Color _capabilityColor(String capability, ColorScheme scheme) {
    switch (capability) {
      case 'translation':
        return scheme.primary;
      case 'dictionary':
        return scheme.secondary;
      default:
        return scheme.tertiary;
    }
  }
}

class _ProviderDraft {
  _ProviderDraft({
    required this.id,
    required this.type,
    required this.fields,
  });
  final String id;
  final String type;
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
  late String _selectedType;
  late Map<String, TextEditingController> _fieldControllers;

  static const _knownProviderTypes = <String>[
    'baidu',
    'caiyun',
    'deepl',
    'google',
    'iciba',
    'tencent',
    'youdao',
  ];

  // Known field keys for each provider type. This intentionally mirrors the
  // `*ProviderConfig+Fields.swift` files (lowest common denominator).
  static const Map<String, List<String>> _providerFields = {
    'baidu': ['appId', 'appKey'],
    'caiyun': ['token'],
    'deepl': ['authKey'],
    'google': ['apiKey'],
    'iciba': [],
    'tencent': ['secretId', 'secretKey'],
    'youdao': ['appKey', 'appSecret'],
  };

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _idController = TextEditingController(text: existing?.id ?? '');
    _selectedType = existing?.type ?? _knownProviderTypes.first;
    _fieldControllers = _buildControllers(_selectedType, existing?.fields);
  }

  Map<String, TextEditingController> _buildControllers(
    String type,
    Map<String, String>? initial,
  ) {
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

  void _changeType(String type) {
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
                    hintText: 'e.g. deepl-main',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _selectedType,
                  items: [
                    for (final type in _knownProviderTypes)
                      DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
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
                    '${widget.existing!.id} · ${widget.existing!.type}',
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
                    type: _selectedType,
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
