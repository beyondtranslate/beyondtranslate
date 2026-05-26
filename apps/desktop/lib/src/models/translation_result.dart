import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';
import 'translation_result_record.dart';

class TranslationResult {
  TranslationResult({
    this.id,
    this.translationTarget,
    this.translationResultRecordList,
    this.unsupportedEngineIdList,
  });

  factory TranslationResult.fromJson(Map<String, dynamic> json) {
    List<TranslationResultRecord> translationResultRecordList = [];

    if (json['translationResultRecordList'] != null) {
      translationResultRecordList =
          (json['translationResultRecordList'] as List)
              .map((item) => TranslationResultRecord.fromJson(item))
              .toList();
    }

    return TranslationResult(
      id: json['id'],
      translationTarget: TranslationTarget(
        source: json['translationTarget']['source'] ??
            json['translationTarget']['sourceLanguage'],
        target: json['translationTarget']['target'] ??
            json['translationTarget']['targetLanguage'],
        enabled: true,
      ),
      translationResultRecordList: translationResultRecordList,
      unsupportedEngineIdList: List<String>.from(
        json['unsupportedEngineIdList'],
      ),
    );
  }

  String? id;
  TranslationTarget? translationTarget;
  List<TranslationResultRecord>? translationResultRecordList;
  List<String>? unsupportedEngineIdList;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'translationTarget': translationTarget == null
          ? null
          : {
              'source': translationTarget!.source,
              'target': translationTarget!.target,
            },
      'translationResultRecordList':
          translationResultRecordList?.map((e) => e.toJson()).toList(),
      'unsupportedEngineIdList': unsupportedEngineIdList,
    };
  }
}
