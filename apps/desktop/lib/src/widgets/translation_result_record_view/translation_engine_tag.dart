import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/ext_translation_engine_config.dart';
import '../../models/translation_result_record.dart';
import '../../services/runtime.dart';
import '../translation_engine_icon/translation_engine_icon.dart';

class TranslationEngineTag extends StatefulWidget {
  const TranslationEngineTag({
    Key? key,
    required this.translationResultRecord,
  }) : super(key: key);

  final TranslationResultRecord translationResultRecord;

  @override
  State<TranslationEngineTag> createState() => _TranslationEngineTagState();
}

class _TranslationEngineTagState extends State<TranslationEngineTag> {
  static const Set<String> _iconTypes = {
    'baidu',
    'caiyun',
    'deepl',
    'google',
    'iciba',
    'openai',
    'sogou',
    'tencent',
    'youdao',
  };

  bool _isHovered = false;
  ProviderConfigEntry? _providerConfigEntry;

  String? get _translationEngineId {
    return widget.translationResultRecord.translationEngineId;
  }

  String get _translationEngineType {
    return _providerConfigEntry?.type ?? _translationEngineId ?? '';
  }

  String get _translationEngineName {
    final providerType = _providerConfigEntry?.type;
    if (providerType != null) {
      return getTranslationEngineTypeName(providerType);
    }
    return _translationEngineId ?? '';
  }

  @override
  void initState() {
    super.initState();
    _loadProviderConfigEntry();
  }

  @override
  void didUpdateWidget(covariant TranslationEngineTag oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.translationResultRecord.translationEngineId !=
        widget.translationResultRecord.translationEngineId) {
      _providerConfigEntry = null;
      _loadProviderConfigEntry();
    }
  }

  void _loadProviderConfigEntry() async {
    final translationEngineId = _translationEngineId;
    if (translationEngineId == null) {
      return;
    }

    try {
      final providerConfigEntry = await runtime.settings().getProvider(
            providerId: translationEngineId,
          );
      if (!mounted || translationEngineId != _translationEngineId) {
        return;
      }
      setState(() {
        _providerConfigEntry = providerConfigEntry;
      });
    } catch (error) {
      // Keep rendering the provider id when runtime metadata is unavailable.
    }
  }

  Widget _buildIcon(String type) {
    if (_iconTypes.contains(type)) {
      return TranslationEngineIcon(
        type,
        size: 12,
      );
    }

    return Container(
      width: 12,
      height: 12,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.12),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Text(
        type.isEmpty ? '?' : type[0].toUpperCase(),
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context).primaryColor,
              fontSize: 7,
              height: 1,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final translationEngineType = _translationEngineType;
    final translationEngineName = _translationEngineName;

    return MouseRegion(
      onEnter: (event) {
        _isHovered = true;
        setState(() {});
      },
      onExit: (event) {
        _isHovered = false;
        setState(() {});
      },
      child: Container(
        height: 40,
        alignment: Alignment.centerRight,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border.all(
              color: Theme.of(context).dividerColor,
              width: 0.5,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
          ),
          padding: const EdgeInsets.only(
            top: 3,
            bottom: 3,
            left: 4,
            right: 2,
          ),
          child: CupertinoButton(
            minimumSize: const Size(0, 0),
            padding: EdgeInsets.zero,
            onPressed: () {},
            child: AnimatedCrossFade(
              crossFadeState: !_isHovered
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 300),
              firstCurve: Curves.ease,
              secondCurve: Curves.ease,
              sizeCurve: Curves.ease,
              firstChild: Row(
                children: [
                  _buildIcon(translationEngineType),
                ],
              ),
              secondChild: Row(
                children: [
                  _buildIcon(translationEngineType),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, right: 2),
                    child: Text(
                      translationEngineName,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 10,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
