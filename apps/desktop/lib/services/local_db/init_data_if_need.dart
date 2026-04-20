import 'dart:io';

import '../../models/models.dart';
import '../services.dart';
import '../../utils/utils.dart';
import 'package:shortid/shortid.dart';

Future<void> initDataIfNeed() async {
  final dataDir = await getAppDataDirectory();
  final file = File('${dataDir.path}/init_data_completed.json');
  if (file.existsSync()) {
    return;
  }

  List<TranslationTarget> translationTargetList = [
    TranslationTarget(
      sourceLanguage: kLanguageEN,
      targetLanguage: kLanguageZH,
    ),
    TranslationTarget(
      sourceLanguage: kLanguageZH,
      targetLanguage: kLanguageEN,
    ),
  ];

  for (TranslationTarget e in translationTargetList) {
    await localDb //
        .translationTarget(e.id ?? shortid.generate())
        .updateOrCreate(
          sourceLanguage: e.sourceLanguage,
          targetLanguage: e.targetLanguage,
        );
  }
  final String jsonString = prettyJsonString(
    {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    },
  );
  await file.writeAsString(jsonString);
}
