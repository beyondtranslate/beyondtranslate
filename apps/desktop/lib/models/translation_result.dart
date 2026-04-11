import 'package:biyi_app/models/translation_result_record.dart';
import 'package:biyi_app/models/translation_target.dart';

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
      translationTarget: TranslationTarget.fromJson(json['translationTarget']),
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
      'translationTarget': translationTarget,
      'translationResultRecordList':
          translationResultRecordList?.map((e) => e.toJson()).toList(),
      'unsupportedEngineIdList': unsupportedEngineIdList,
    };
  }
}
