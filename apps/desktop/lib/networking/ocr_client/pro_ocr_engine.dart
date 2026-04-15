import 'package:biyi_app/models/models.dart';
import 'package:uni_ocr_client/uni_ocr_client.dart';

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
