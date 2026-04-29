import 'package:uni_ocr_client/uni_ocr_client.dart';

import '../../models/ocr_engine_config.dart';

class ProOcrEngine extends OcrEngine {
  ProOcrEngine(
    this.config,
  ) : super(identifier: config.identifier, option: config.option);

  OcrEngineConfig config;

  @override
  Future<RecognizeTextResponse> recognizeText(RecognizeTextRequest request) {
    throw UnsupportedError('recognizeText');
  }
}
