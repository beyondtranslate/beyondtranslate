import 'package:uni_translate_client/uni_translate_client.dart';

class TranslationResultRecord {
  TranslationResultRecord({
    this.id,
    this.translationTargetId,
    this.translationEngineId,
    this.lookUpRequest,
    this.lookUpResponse,
    this.translateRequest,
    this.translateResponse,
  });

  factory TranslationResultRecord.fromJson(Map<String, dynamic> json) {
    return TranslationResultRecord(
      id: json['id'],
      translationTargetId: json['translationTargetId'],
      translationEngineId: json['translationEngineId'],
      lookUpRequest: LookUpRequest.fromJson(json['lookUpRequest']),
      lookUpResponse: LookUpResponse.fromJson(json['lookUpResponse']),
      translateRequest: TranslateRequest.fromJson(json['translateRequest']),
      translateResponse: TranslateResponse.fromJson(json['translateResponse']),
    );
  }

  String? id;
  String? translationTargetId;
  String? translationEngineId;
  LookUpRequest? lookUpRequest;
  LookUpResponse? lookUpResponse;
  UniTranslateClientError? lookUpError;
  TranslateRequest? translateRequest;
  TranslateResponse? translateResponse;
  UniTranslateClientError? translateError;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'translationTargetId': translationTargetId,
      'translationEngineId': translationEngineId,
      'lookUpRequest': lookUpRequest?.toJson(),
      'lookUpResponse': lookUpResponse?.toJson(),
      'lookUpError': lookUpError?.toJson(),
      'translateRequest': translateRequest?.toJson(),
      'translateResponse': translateResponse?.toJson(),
      'translateError': translateError?.toJson(),
    }..removeWhere((key, value) => value == null);
  }
}
