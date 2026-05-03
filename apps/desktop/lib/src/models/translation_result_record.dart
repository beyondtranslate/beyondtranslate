import '../services/runtime.dart';

class TranslationResultRecord {
  TranslationResultRecord({
    this.id,
    this.translationTargetId,
    this.translationEngineId,
    this.lookUpRequest,
    this.lookUpResponse,
    this.lookUpError,
    this.translateRequest,
    this.translateResponse,
    this.translateError,
  });

  factory TranslationResultRecord.fromJson(Map<String, dynamic> json) {
    return TranslationResultRecord(
      id: json['id'],
      translationTargetId: json['translationTargetId'],
      translationEngineId: json['translationEngineId'],
      lookUpRequest: json['lookUpRequest'] != null
          ? LookUpRequest(
              sourceLanguage: json['lookUpRequest']['sourceLanguage'],
              targetLanguage: json['lookUpRequest']['targetLanguage'],
              word: json['lookUpRequest']['word'],
            )
          : null,
      lookUpResponse: json['lookUpResponse'] != null
          ? LookUpResponse(
              translations: (json['lookUpResponse']['translations'] as List)
                  .map((e) => TextTranslation(
                        text: e['text'],
                        detectedSourceLanguage: e['detectedSourceLanguage'],
                        audioUrl: e['audioUrl'],
                      ))
                  .toList(),
              word: json['lookUpResponse']['word'],
              tip: json['lookUpResponse']['tip'],
            )
          : null,
      lookUpError: json['lookUpError'] != null
          ? TranslationError.fromJson(json['lookUpError'])
          : null,
      translateRequest: json['translateRequest'] != null
          ? TranslateRequest(
              sourceLanguage: json['translateRequest']['sourceLanguage'],
              targetLanguage: json['translateRequest']['targetLanguage'],
              text: json['translateRequest']['text'],
            )
          : null,
      translateResponse: json['translateResponse'] != null
          ? TranslateResponse(
              translations: (json['translateResponse']['translations'] as List)
                  .map((e) => TextTranslation(
                        text: e['text'],
                        detectedSourceLanguage: e['detectedSourceLanguage'],
                        audioUrl: e['audioUrl'],
                      ))
                  .toList(),
            )
          : null,
      translateError: json['translateError'] != null
          ? TranslationError.fromJson(json['translateError'])
          : null,
    );
  }

  String? id;
  String? translationTargetId;
  String? translationEngineId;
  LookUpRequest? lookUpRequest;
  LookUpResponse? lookUpResponse;
  TranslationError? lookUpError;
  TranslateRequest? translateRequest;
  TranslateResponse? translateResponse;
  TranslationError? translateError;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'translationTargetId': translationTargetId,
      'translationEngineId': translationEngineId,
      'lookUpRequest': lookUpRequest != null
          ? {
              'sourceLanguage': lookUpRequest!.sourceLanguage,
              'targetLanguage': lookUpRequest!.targetLanguage,
              'word': lookUpRequest!.word,
            }
          : null,
      'lookUpResponse': lookUpResponse != null
          ? {
              'translations': lookUpResponse!.translations
                  .map((e) => {
                        'text': e.text,
                        'detectedSourceLanguage': e.detectedSourceLanguage,
                        'audioUrl': e.audioUrl,
                      })
                  .toList(),
              'word': lookUpResponse!.word,
              'tip': lookUpResponse!.tip,
            }
          : null,
      'lookUpError': lookUpError?.toJson(),
      'translateRequest': translateRequest != null
          ? {
              'sourceLanguage': translateRequest!.sourceLanguage,
              'targetLanguage': translateRequest!.targetLanguage,
              'text': translateRequest!.text,
            }
          : null,
      'translateResponse': translateResponse != null
          ? {
              'translations': translateResponse!.translations
                  .map((e) => {
                        'text': e.text,
                        'detectedSourceLanguage': e.detectedSourceLanguage,
                        'audioUrl': e.audioUrl,
                      })
                  .toList(),
            }
          : null,
      'translateError': translateError?.toJson(),
    }..removeWhere((key, value) => value == null);
  }
}
