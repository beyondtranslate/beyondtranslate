import 'package:biyi_advanced_features/biyi_advanced_features.dart';
import 'package:biyi_app/models/ext_ocr_engine_config.dart';
import 'package:flutter/material.dart';

class OcrEngineName extends StatelessWidget {
  const OcrEngineName(
    this.ocrEngineConfig, {
    Key? key,
  }) : super(key: key);

  final OcrEngineConfig ocrEngineConfig;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: ocrEngineConfig.typeName,
        children: [
          TextSpan(
            text: ' (${ocrEngineConfig.identifier})',
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
