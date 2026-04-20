import 'package:flutter/material.dart';

import '../../models/ext_translation_engine_config.dart';
import '../../models/translation_engine_config.dart';

class TranslationEngineName extends StatelessWidget {
  const TranslationEngineName(
    this.translationEngineConfig, {
    Key? key,
  }) : super(key: key);

  final TranslationEngineConfig translationEngineConfig;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: translationEngineConfig.typeName,
        children: [
          TextSpan(
            text: ' (${translationEngineConfig.identifier})',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
