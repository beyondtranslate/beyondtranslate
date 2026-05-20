import '../services/runtime.dart';

WordDefinition _parseWordDefinition(Map<String, dynamic> json) {
  return WordDefinition(
    type: json['type'],
    name: json['name'],
    values: json['values'] != null ? List<String>.from(json['values']) : null,
  );
}

Map<String, dynamic> _wordDefinitionToJson(WordDefinition d) => {
      'type': d.type,
      'name': d.name,
      'values': d.values,
    };

WordPronunciation _parseWordPronunciation(Map<String, dynamic> json) {
  return WordPronunciation(
    type: json['type'],
    phoneticSymbol: json['phoneticSymbol'],
    audioUrl: json['audioUrl'],
  );
}

Map<String, dynamic> _wordPronunciationToJson(WordPronunciation p) => {
      'type': p.type,
      'phoneticSymbol': p.phoneticSymbol,
      'audioUrl': p.audioUrl,
    };

WordTag _parseWordTag(Map<String, dynamic> json) {
  return WordTag(name: json['name']);
}

Map<String, dynamic> _wordTagToJson(WordTag t) => {'name': t.name};

WordImage _parseWordImage(Map<String, dynamic> json) {
  return WordImage(url: json['url']);
}

Map<String, dynamic> _wordImageToJson(WordImage i) => {'url': i.url};

WordPhrase _parseWordPhrase(Map<String, dynamic> json) {
  return WordPhrase(
    text: json['text'],
    translations: List<String>.from(json['translations']),
  );
}

Map<String, dynamic> _wordPhraseToJson(WordPhrase p) => {
      'text': p.text,
      'translations': p.translations,
    };

WordTense _parseWordTense(Map<String, dynamic> json) {
  return WordTense(
    type: json['type'],
    name: json['name'],
    values: json['values'] != null ? List<String>.from(json['values']) : null,
  );
}

Map<String, dynamic> _wordTenseToJson(WordTense t) => {
      'type': t.type,
      'name': t.name,
      'values': t.values,
    };

WordSentence _parseWordSentence(Map<String, dynamic> json) {
  return WordSentence(
    text: json['text'],
    translations: List<String>.from(json['translations']),
  );
}

Map<String, dynamic> _wordSentenceToJson(WordSentence s) => {
      'text': s.text,
      'translations': s.translations,
    };

WordEtymology _parseWordEtymology(Map<String, dynamic> json) {
  return WordEtymology(
    origin: json['origin'],
    root: json['root'] != null ? List<String>.from(json['root']) : null,
  );
}

Map<String, dynamic> _wordEtymologyToJson(WordEtymology e) => {
      'origin': e.origin,
      'root': e.root,
    };

WordSynonym _parseWordSynonym(Map<String, dynamic> json) {
  return WordSynonym(
    type: json['type'],
    word: json['word'],
    definitions: json['definitions'] != null
        ? List<String>.from(json['definitions'])
        : null,
  );
}

Map<String, dynamic> _wordSynonymToJson(WordSynonym s) => {
      'type': s.type,
      'word': s.word,
      'definitions': s.definitions,
    };

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
              translations:
                  (json['lookUpResponse']['translations'] as List? ?? [])
                      .map((e) => TextTranslation(
                            text: e['text'],
                            detectedSourceLanguage: e['detectedSourceLanguage'],
                            audioUrl: e['audioUrl'],
                          ))
                      .toList(),
              word: json['lookUpResponse']['word'],
              tip: json['lookUpResponse']['tip'],
              tags: json['lookUpResponse']['tags'] != null
                  ? (json['lookUpResponse']['tags'] as List)
                      .map((e) => _parseWordTag(e))
                      .toList()
                  : null,
              definitions: json['lookUpResponse']['definitions'] != null
                  ? (json['lookUpResponse']['definitions'] as List)
                      .map((e) => _parseWordDefinition(e))
                      .toList()
                  : null,
              pronunciations: json['lookUpResponse']['pronunciations'] != null
                  ? (json['lookUpResponse']['pronunciations'] as List)
                      .map((e) => _parseWordPronunciation(e))
                      .toList()
                  : null,
              images: json['lookUpResponse']['images'] != null
                  ? (json['lookUpResponse']['images'] as List)
                      .map((e) => _parseWordImage(e))
                      .toList()
                  : null,
              phrases: json['lookUpResponse']['phrases'] != null
                  ? (json['lookUpResponse']['phrases'] as List)
                      .map((e) => _parseWordPhrase(e))
                      .toList()
                  : null,
              tenses: json['lookUpResponse']['tenses'] != null
                  ? (json['lookUpResponse']['tenses'] as List)
                      .map((e) => _parseWordTense(e))
                      .toList()
                  : null,
              sentences: json['lookUpResponse']['sentences'] != null
                  ? (json['lookUpResponse']['sentences'] as List)
                      .map((e) => _parseWordSentence(e))
                      .toList()
                  : null,
              etymology: json['lookUpResponse']['etymology'] != null
                  ? (json['lookUpResponse']['etymology'] as List)
                      .map((e) => _parseWordEtymology(e))
                      .toList()
                  : null,
              synonyms: json['lookUpResponse']['synonyms'] != null
                  ? (json['lookUpResponse']['synonyms'] as List)
                      .map((e) => _parseWordSynonym(e))
                      .toList()
                  : null,
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
              if (lookUpResponse!.tags != null)
                'tags': lookUpResponse!.tags!.map(_wordTagToJson).toList(),
              if (lookUpResponse!.definitions != null)
                'definitions': lookUpResponse!.definitions!
                    .map(_wordDefinitionToJson)
                    .toList(),
              if (lookUpResponse!.pronunciations != null)
                'pronunciations': lookUpResponse!.pronunciations!
                    .map(_wordPronunciationToJson)
                    .toList(),
              if (lookUpResponse!.images != null)
                'images':
                    lookUpResponse!.images!.map(_wordImageToJson).toList(),
              if (lookUpResponse!.phrases != null)
                'phrases':
                    lookUpResponse!.phrases!.map(_wordPhraseToJson).toList(),
              if (lookUpResponse!.tenses != null)
                'tenses':
                    lookUpResponse!.tenses!.map(_wordTenseToJson).toList(),
              if (lookUpResponse!.sentences != null)
                'sentences': lookUpResponse!.sentences!
                    .map(_wordSentenceToJson)
                    .toList(),
              if (lookUpResponse!.etymology != null)
                'etymology': lookUpResponse!.etymology!
                    .map(_wordEtymologyToJson)
                    .toList(),
              if (lookUpResponse!.synonyms != null)
                'synonyms':
                    lookUpResponse!.synonyms!.map(_wordSynonymToJson).toList(),
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
