library beyondtranslate_runtime;

import "dart:async";
import "dart:convert";
import "dart:ffi";
import "dart:io" show Platform, File, Directory;
import "dart:isolate";
import "dart:typed_data";
import "package:ffi/ffi.dart";

class DetectLanguageRequest {
  final List<String> texts;
  DetectLanguageRequest({
    required this.texts,
  });
}

class FfiConverterDetectLanguageRequest {
  static DetectLanguageRequest lift(RustBuffer buf) {
    return FfiConverterDetectLanguageRequest.read(buf.asUint8List()).value;
  }

  static LiftRetVal<DetectLanguageRequest> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final texts_lifted =
        FfiConverterSequenceString.read(Uint8List.view(buf.buffer, new_offset));
    final texts = texts_lifted.value;
    new_offset += texts_lifted.bytesRead;
    return LiftRetVal(
        DetectLanguageRequest(
          texts: texts,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(DetectLanguageRequest value) {
    final total_length =
        FfiConverterSequenceString.allocationSize(value.texts) + 0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(DetectLanguageRequest value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterSequenceString.write(
        value.texts, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(DetectLanguageRequest value) {
    return FfiConverterSequenceString.allocationSize(value.texts) + 0;
  }
}

class DetectLanguageResponse {
  final List<TextDetection>? detections;
  DetectLanguageResponse({
    this.detections,
  });
}

class FfiConverterDetectLanguageResponse {
  static DetectLanguageResponse lift(RustBuffer buf) {
    return FfiConverterDetectLanguageResponse.read(buf.asUint8List()).value;
  }

  static LiftRetVal<DetectLanguageResponse> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final detections_lifted = FfiConverterOptionalSequenceTextDetection.read(
        Uint8List.view(buf.buffer, new_offset));
    final detections = detections_lifted.value;
    new_offset += detections_lifted.bytesRead;
    return LiftRetVal(
        DetectLanguageResponse(
          detections: detections,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(DetectLanguageResponse value) {
    final total_length =
        FfiConverterOptionalSequenceTextDetection.allocationSize(
                value.detections) +
            0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(DetectLanguageResponse value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterOptionalSequenceTextDetection.write(
        value.detections, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(DetectLanguageResponse value) {
    return FfiConverterOptionalSequenceTextDetection.allocationSize(
            value.detections) +
        0;
  }
}

class LanguagePair {
  final String? sourceLanguage;
  final String? sourceLanguageId;
  final String? targetLanguage;
  final String? targetLanguageId;
  LanguagePair({
    this.sourceLanguage,
    this.sourceLanguageId,
    this.targetLanguage,
    this.targetLanguageId,
  });
}

class FfiConverterLanguagePair {
  static LanguagePair lift(RustBuffer buf) {
    return FfiConverterLanguagePair.read(buf.asUint8List()).value;
  }

  static LiftRetVal<LanguagePair> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final sourceLanguage_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final sourceLanguage = sourceLanguage_lifted.value;
    new_offset += sourceLanguage_lifted.bytesRead;
    final sourceLanguageId_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final sourceLanguageId = sourceLanguageId_lifted.value;
    new_offset += sourceLanguageId_lifted.bytesRead;
    final targetLanguage_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final targetLanguage = targetLanguage_lifted.value;
    new_offset += targetLanguage_lifted.bytesRead;
    final targetLanguageId_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final targetLanguageId = targetLanguageId_lifted.value;
    new_offset += targetLanguageId_lifted.bytesRead;
    return LiftRetVal(
        LanguagePair(
          sourceLanguage: sourceLanguage,
          sourceLanguageId: sourceLanguageId,
          targetLanguage: targetLanguage,
          targetLanguageId: targetLanguageId,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(LanguagePair value) {
    final total_length =
        FfiConverterOptionalString.allocationSize(value.sourceLanguage) +
            FfiConverterOptionalString.allocationSize(value.sourceLanguageId) +
            FfiConverterOptionalString.allocationSize(value.targetLanguage) +
            FfiConverterOptionalString.allocationSize(value.targetLanguageId) +
            0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(LanguagePair value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterOptionalString.write(
        value.sourceLanguage, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.sourceLanguageId, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.targetLanguage, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.targetLanguageId, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(LanguagePair value) {
    return FfiConverterOptionalString.allocationSize(value.sourceLanguage) +
        FfiConverterOptionalString.allocationSize(value.sourceLanguageId) +
        FfiConverterOptionalString.allocationSize(value.targetLanguage) +
        FfiConverterOptionalString.allocationSize(value.targetLanguageId) +
        0;
  }
}

class LookUpRequest {
  final String sourceLanguage;
  final String targetLanguage;
  final String word;
  LookUpRequest({
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.word,
  });
}

class FfiConverterLookUpRequest {
  static LookUpRequest lift(RustBuffer buf) {
    return FfiConverterLookUpRequest.read(buf.asUint8List()).value;
  }

  static LiftRetVal<LookUpRequest> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final sourceLanguage_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final sourceLanguage = sourceLanguage_lifted.value;
    new_offset += sourceLanguage_lifted.bytesRead;
    final targetLanguage_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final targetLanguage = targetLanguage_lifted.value;
    new_offset += targetLanguage_lifted.bytesRead;
    final word_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final word = word_lifted.value;
    new_offset += word_lifted.bytesRead;
    return LiftRetVal(
        LookUpRequest(
          sourceLanguage: sourceLanguage,
          targetLanguage: targetLanguage,
          word: word,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(LookUpRequest value) {
    final total_length =
        FfiConverterString.allocationSize(value.sourceLanguage) +
            FfiConverterString.allocationSize(value.targetLanguage) +
            FfiConverterString.allocationSize(value.word) +
            0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(LookUpRequest value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterString.write(
        value.sourceLanguage, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterString.write(
        value.targetLanguage, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterString.write(
        value.word, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(LookUpRequest value) {
    return FfiConverterString.allocationSize(value.sourceLanguage) +
        FfiConverterString.allocationSize(value.targetLanguage) +
        FfiConverterString.allocationSize(value.word) +
        0;
  }
}

class LookUpResponse {
  final List<TextTranslation> translations;
  final String? word;
  final String? tip;
  final List<WordTag>? tags;
  final List<WordDefinition>? definitions;
  final List<WordPronunciation>? pronunciations;
  final List<WordImage>? images;
  final List<WordPhrase>? phrases;
  final List<WordTense>? tenses;
  final List<WordSentence>? sentences;
  LookUpResponse({
    required this.translations,
    this.word,
    this.tip,
    this.tags,
    this.definitions,
    this.pronunciations,
    this.images,
    this.phrases,
    this.tenses,
    this.sentences,
  });
}

class FfiConverterLookUpResponse {
  static LookUpResponse lift(RustBuffer buf) {
    return FfiConverterLookUpResponse.read(buf.asUint8List()).value;
  }

  static LiftRetVal<LookUpResponse> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final translations_lifted = FfiConverterSequenceTextTranslation.read(
        Uint8List.view(buf.buffer, new_offset));
    final translations = translations_lifted.value;
    new_offset += translations_lifted.bytesRead;
    final word_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final word = word_lifted.value;
    new_offset += word_lifted.bytesRead;
    final tip_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final tip = tip_lifted.value;
    new_offset += tip_lifted.bytesRead;
    final tags_lifted = FfiConverterOptionalSequenceWordTag.read(
        Uint8List.view(buf.buffer, new_offset));
    final tags = tags_lifted.value;
    new_offset += tags_lifted.bytesRead;
    final definitions_lifted = FfiConverterOptionalSequenceWordDefinition.read(
        Uint8List.view(buf.buffer, new_offset));
    final definitions = definitions_lifted.value;
    new_offset += definitions_lifted.bytesRead;
    final pronunciations_lifted =
        FfiConverterOptionalSequenceWordPronunciation.read(
            Uint8List.view(buf.buffer, new_offset));
    final pronunciations = pronunciations_lifted.value;
    new_offset += pronunciations_lifted.bytesRead;
    final images_lifted = FfiConverterOptionalSequenceWordImage.read(
        Uint8List.view(buf.buffer, new_offset));
    final images = images_lifted.value;
    new_offset += images_lifted.bytesRead;
    final phrases_lifted = FfiConverterOptionalSequenceWordPhrase.read(
        Uint8List.view(buf.buffer, new_offset));
    final phrases = phrases_lifted.value;
    new_offset += phrases_lifted.bytesRead;
    final tenses_lifted = FfiConverterOptionalSequenceWordTense.read(
        Uint8List.view(buf.buffer, new_offset));
    final tenses = tenses_lifted.value;
    new_offset += tenses_lifted.bytesRead;
    final sentences_lifted = FfiConverterOptionalSequenceWordSentence.read(
        Uint8List.view(buf.buffer, new_offset));
    final sentences = sentences_lifted.value;
    new_offset += sentences_lifted.bytesRead;
    return LiftRetVal(
        LookUpResponse(
          translations: translations,
          word: word,
          tip: tip,
          tags: tags,
          definitions: definitions,
          pronunciations: pronunciations,
          images: images,
          phrases: phrases,
          tenses: tenses,
          sentences: sentences,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(LookUpResponse value) {
    final total_length = FfiConverterSequenceTextTranslation.allocationSize(
            value.translations) +
        FfiConverterOptionalString.allocationSize(value.word) +
        FfiConverterOptionalString.allocationSize(value.tip) +
        FfiConverterOptionalSequenceWordTag.allocationSize(value.tags) +
        FfiConverterOptionalSequenceWordDefinition.allocationSize(
            value.definitions) +
        FfiConverterOptionalSequenceWordPronunciation.allocationSize(
            value.pronunciations) +
        FfiConverterOptionalSequenceWordImage.allocationSize(value.images) +
        FfiConverterOptionalSequenceWordPhrase.allocationSize(value.phrases) +
        FfiConverterOptionalSequenceWordTense.allocationSize(value.tenses) +
        FfiConverterOptionalSequenceWordSentence.allocationSize(
            value.sentences) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(LookUpResponse value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterSequenceTextTranslation.write(
        value.translations, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.word, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.tip, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalSequenceWordTag.write(
        value.tags, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalSequenceWordDefinition.write(
        value.definitions, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalSequenceWordPronunciation.write(
        value.pronunciations, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalSequenceWordImage.write(
        value.images, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalSequenceWordPhrase.write(
        value.phrases, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalSequenceWordTense.write(
        value.tenses, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalSequenceWordSentence.write(
        value.sentences, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(LookUpResponse value) {
    return FfiConverterSequenceTextTranslation.allocationSize(
            value.translations) +
        FfiConverterOptionalString.allocationSize(value.word) +
        FfiConverterOptionalString.allocationSize(value.tip) +
        FfiConverterOptionalSequenceWordTag.allocationSize(value.tags) +
        FfiConverterOptionalSequenceWordDefinition.allocationSize(
            value.definitions) +
        FfiConverterOptionalSequenceWordPronunciation.allocationSize(
            value.pronunciations) +
        FfiConverterOptionalSequenceWordImage.allocationSize(value.images) +
        FfiConverterOptionalSequenceWordPhrase.allocationSize(value.phrases) +
        FfiConverterOptionalSequenceWordTense.allocationSize(value.tenses) +
        FfiConverterOptionalSequenceWordSentence.allocationSize(
            value.sentences) +
        0;
  }
}

class TextDetection {
  final String detectedLanguage;
  final String text;
  TextDetection({
    required this.detectedLanguage,
    required this.text,
  });
}

class FfiConverterTextDetection {
  static TextDetection lift(RustBuffer buf) {
    return FfiConverterTextDetection.read(buf.asUint8List()).value;
  }

  static LiftRetVal<TextDetection> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final detectedLanguage_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final detectedLanguage = detectedLanguage_lifted.value;
    new_offset += detectedLanguage_lifted.bytesRead;
    final text_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final text = text_lifted.value;
    new_offset += text_lifted.bytesRead;
    return LiftRetVal(
        TextDetection(
          detectedLanguage: detectedLanguage,
          text: text,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(TextDetection value) {
    final total_length =
        FfiConverterString.allocationSize(value.detectedLanguage) +
            FfiConverterString.allocationSize(value.text) +
            0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(TextDetection value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterString.write(
        value.detectedLanguage, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterString.write(
        value.text, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(TextDetection value) {
    return FfiConverterString.allocationSize(value.detectedLanguage) +
        FfiConverterString.allocationSize(value.text) +
        0;
  }
}

class TextTranslation {
  final String? detectedSourceLanguage;
  final String text;
  final String? audioUrl;
  TextTranslation({
    this.detectedSourceLanguage,
    required this.text,
    this.audioUrl,
  });
}

class FfiConverterTextTranslation {
  static TextTranslation lift(RustBuffer buf) {
    return FfiConverterTextTranslation.read(buf.asUint8List()).value;
  }

  static LiftRetVal<TextTranslation> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final detectedSourceLanguage_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final detectedSourceLanguage = detectedSourceLanguage_lifted.value;
    new_offset += detectedSourceLanguage_lifted.bytesRead;
    final text_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final text = text_lifted.value;
    new_offset += text_lifted.bytesRead;
    final audioUrl_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final audioUrl = audioUrl_lifted.value;
    new_offset += audioUrl_lifted.bytesRead;
    return LiftRetVal(
        TextTranslation(
          detectedSourceLanguage: detectedSourceLanguage,
          text: text,
          audioUrl: audioUrl,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(TextTranslation value) {
    final total_length = FfiConverterOptionalString.allocationSize(
            value.detectedSourceLanguage) +
        FfiConverterString.allocationSize(value.text) +
        FfiConverterOptionalString.allocationSize(value.audioUrl) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(TextTranslation value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterOptionalString.write(
        value.detectedSourceLanguage, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterString.write(
        value.text, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.audioUrl, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(TextTranslation value) {
    return FfiConverterOptionalString.allocationSize(
            value.detectedSourceLanguage) +
        FfiConverterString.allocationSize(value.text) +
        FfiConverterOptionalString.allocationSize(value.audioUrl) +
        0;
  }
}

class TranslateRequest {
  final String? sourceLanguage;
  final String? targetLanguage;
  final String text;
  TranslateRequest({
    this.sourceLanguage,
    this.targetLanguage,
    required this.text,
  });
}

class FfiConverterTranslateRequest {
  static TranslateRequest lift(RustBuffer buf) {
    return FfiConverterTranslateRequest.read(buf.asUint8List()).value;
  }

  static LiftRetVal<TranslateRequest> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final sourceLanguage_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final sourceLanguage = sourceLanguage_lifted.value;
    new_offset += sourceLanguage_lifted.bytesRead;
    final targetLanguage_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final targetLanguage = targetLanguage_lifted.value;
    new_offset += targetLanguage_lifted.bytesRead;
    final text_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final text = text_lifted.value;
    new_offset += text_lifted.bytesRead;
    return LiftRetVal(
        TranslateRequest(
          sourceLanguage: sourceLanguage,
          targetLanguage: targetLanguage,
          text: text,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(TranslateRequest value) {
    final total_length =
        FfiConverterOptionalString.allocationSize(value.sourceLanguage) +
            FfiConverterOptionalString.allocationSize(value.targetLanguage) +
            FfiConverterString.allocationSize(value.text) +
            0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(TranslateRequest value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterOptionalString.write(
        value.sourceLanguage, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.targetLanguage, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterString.write(
        value.text, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(TranslateRequest value) {
    return FfiConverterOptionalString.allocationSize(value.sourceLanguage) +
        FfiConverterOptionalString.allocationSize(value.targetLanguage) +
        FfiConverterString.allocationSize(value.text) +
        0;
  }
}

class TranslateResponse {
  final List<TextTranslation> translations;
  TranslateResponse({
    required this.translations,
  });
}

class FfiConverterTranslateResponse {
  static TranslateResponse lift(RustBuffer buf) {
    return FfiConverterTranslateResponse.read(buf.asUint8List()).value;
  }

  static LiftRetVal<TranslateResponse> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final translations_lifted = FfiConverterSequenceTextTranslation.read(
        Uint8List.view(buf.buffer, new_offset));
    final translations = translations_lifted.value;
    new_offset += translations_lifted.bytesRead;
    return LiftRetVal(
        TranslateResponse(
          translations: translations,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(TranslateResponse value) {
    final total_length =
        FfiConverterSequenceTextTranslation.allocationSize(value.translations) +
            0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(TranslateResponse value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterSequenceTextTranslation.write(
        value.translations, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(TranslateResponse value) {
    return FfiConverterSequenceTextTranslation.allocationSize(
            value.translations) +
        0;
  }
}

class WordDefinition {
  final String? type;
  final String? name;
  final List<String>? values;
  WordDefinition({
    this.type,
    this.name,
    this.values,
  });
}

class FfiConverterWordDefinition {
  static WordDefinition lift(RustBuffer buf) {
    return FfiConverterWordDefinition.read(buf.asUint8List()).value;
  }

  static LiftRetVal<WordDefinition> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final type_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final type = type_lifted.value;
    new_offset += type_lifted.bytesRead;
    final name_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final name = name_lifted.value;
    new_offset += name_lifted.bytesRead;
    final values_lifted = FfiConverterOptionalSequenceString.read(
        Uint8List.view(buf.buffer, new_offset));
    final values = values_lifted.value;
    new_offset += values_lifted.bytesRead;
    return LiftRetVal(
        WordDefinition(
          type: type,
          name: name,
          values: values,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(WordDefinition value) {
    final total_length = FfiConverterOptionalString.allocationSize(value.type) +
        FfiConverterOptionalString.allocationSize(value.name) +
        FfiConverterOptionalSequenceString.allocationSize(value.values) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(WordDefinition value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterOptionalString.write(
        value.type, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.name, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalSequenceString.write(
        value.values, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(WordDefinition value) {
    return FfiConverterOptionalString.allocationSize(value.type) +
        FfiConverterOptionalString.allocationSize(value.name) +
        FfiConverterOptionalSequenceString.allocationSize(value.values) +
        0;
  }
}

class WordImage {
  final String url;
  WordImage({
    required this.url,
  });
}

class FfiConverterWordImage {
  static WordImage lift(RustBuffer buf) {
    return FfiConverterWordImage.read(buf.asUint8List()).value;
  }

  static LiftRetVal<WordImage> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final url_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final url = url_lifted.value;
    new_offset += url_lifted.bytesRead;
    return LiftRetVal(
        WordImage(
          url: url,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(WordImage value) {
    final total_length = FfiConverterString.allocationSize(value.url) + 0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(WordImage value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterString.write(
        value.url, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(WordImage value) {
    return FfiConverterString.allocationSize(value.url) + 0;
  }
}

class WordPhrase {
  final String text;
  final List<String> translations;
  WordPhrase({
    required this.text,
    required this.translations,
  });
}

class FfiConverterWordPhrase {
  static WordPhrase lift(RustBuffer buf) {
    return FfiConverterWordPhrase.read(buf.asUint8List()).value;
  }

  static LiftRetVal<WordPhrase> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final text_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final text = text_lifted.value;
    new_offset += text_lifted.bytesRead;
    final translations_lifted =
        FfiConverterSequenceString.read(Uint8List.view(buf.buffer, new_offset));
    final translations = translations_lifted.value;
    new_offset += translations_lifted.bytesRead;
    return LiftRetVal(
        WordPhrase(
          text: text,
          translations: translations,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(WordPhrase value) {
    final total_length = FfiConverterString.allocationSize(value.text) +
        FfiConverterSequenceString.allocationSize(value.translations) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(WordPhrase value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterString.write(
        value.text, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterSequenceString.write(
        value.translations, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(WordPhrase value) {
    return FfiConverterString.allocationSize(value.text) +
        FfiConverterSequenceString.allocationSize(value.translations) +
        0;
  }
}

class WordPronunciation {
  final String? type;
  final String? phoneticSymbol;
  final String? audioUrl;
  WordPronunciation({
    this.type,
    this.phoneticSymbol,
    this.audioUrl,
  });
}

class FfiConverterWordPronunciation {
  static WordPronunciation lift(RustBuffer buf) {
    return FfiConverterWordPronunciation.read(buf.asUint8List()).value;
  }

  static LiftRetVal<WordPronunciation> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final type_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final type = type_lifted.value;
    new_offset += type_lifted.bytesRead;
    final phoneticSymbol_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final phoneticSymbol = phoneticSymbol_lifted.value;
    new_offset += phoneticSymbol_lifted.bytesRead;
    final audioUrl_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final audioUrl = audioUrl_lifted.value;
    new_offset += audioUrl_lifted.bytesRead;
    return LiftRetVal(
        WordPronunciation(
          type: type,
          phoneticSymbol: phoneticSymbol,
          audioUrl: audioUrl,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(WordPronunciation value) {
    final total_length = FfiConverterOptionalString.allocationSize(value.type) +
        FfiConverterOptionalString.allocationSize(value.phoneticSymbol) +
        FfiConverterOptionalString.allocationSize(value.audioUrl) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(WordPronunciation value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterOptionalString.write(
        value.type, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.phoneticSymbol, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.audioUrl, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(WordPronunciation value) {
    return FfiConverterOptionalString.allocationSize(value.type) +
        FfiConverterOptionalString.allocationSize(value.phoneticSymbol) +
        FfiConverterOptionalString.allocationSize(value.audioUrl) +
        0;
  }
}

class WordSentence {
  final String text;
  final List<String> translations;
  WordSentence({
    required this.text,
    required this.translations,
  });
}

class FfiConverterWordSentence {
  static WordSentence lift(RustBuffer buf) {
    return FfiConverterWordSentence.read(buf.asUint8List()).value;
  }

  static LiftRetVal<WordSentence> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final text_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final text = text_lifted.value;
    new_offset += text_lifted.bytesRead;
    final translations_lifted =
        FfiConverterSequenceString.read(Uint8List.view(buf.buffer, new_offset));
    final translations = translations_lifted.value;
    new_offset += translations_lifted.bytesRead;
    return LiftRetVal(
        WordSentence(
          text: text,
          translations: translations,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(WordSentence value) {
    final total_length = FfiConverterString.allocationSize(value.text) +
        FfiConverterSequenceString.allocationSize(value.translations) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(WordSentence value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterString.write(
        value.text, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterSequenceString.write(
        value.translations, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(WordSentence value) {
    return FfiConverterString.allocationSize(value.text) +
        FfiConverterSequenceString.allocationSize(value.translations) +
        0;
  }
}

class WordTag {
  final String name;
  WordTag({
    required this.name,
  });
}

class FfiConverterWordTag {
  static WordTag lift(RustBuffer buf) {
    return FfiConverterWordTag.read(buf.asUint8List()).value;
  }

  static LiftRetVal<WordTag> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final name_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final name = name_lifted.value;
    new_offset += name_lifted.bytesRead;
    return LiftRetVal(
        WordTag(
          name: name,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(WordTag value) {
    final total_length = FfiConverterString.allocationSize(value.name) + 0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(WordTag value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterString.write(
        value.name, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(WordTag value) {
    return FfiConverterString.allocationSize(value.name) + 0;
  }
}

class WordTense {
  final String? type;
  final String? name;
  final List<String>? values;
  WordTense({
    this.type,
    this.name,
    this.values,
  });
}

class FfiConverterWordTense {
  static WordTense lift(RustBuffer buf) {
    return FfiConverterWordTense.read(buf.asUint8List()).value;
  }

  static LiftRetVal<WordTense> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final type_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final type = type_lifted.value;
    new_offset += type_lifted.bytesRead;
    final name_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final name = name_lifted.value;
    new_offset += name_lifted.bytesRead;
    final values_lifted = FfiConverterOptionalSequenceString.read(
        Uint8List.view(buf.buffer, new_offset));
    final values = values_lifted.value;
    new_offset += values_lifted.bytesRead;
    return LiftRetVal(
        WordTense(
          type: type,
          name: name,
          values: values,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(WordTense value) {
    final total_length = FfiConverterOptionalString.allocationSize(value.type) +
        FfiConverterOptionalString.allocationSize(value.name) +
        FfiConverterOptionalSequenceString.allocationSize(value.values) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(WordTense value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterOptionalString.write(
        value.type, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.name, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalSequenceString.write(
        value.values, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(WordTense value) {
    return FfiConverterOptionalString.allocationSize(value.type) +
        FfiConverterOptionalString.allocationSize(value.name) +
        FfiConverterOptionalSequenceString.allocationSize(value.values) +
        0;
  }
}

class UniffiInternalError implements Exception {
  static const int bufferOverflow = 0;
  static const int incompleteData = 1;
  static const int unexpectedOptionalTag = 2;
  static const int unexpectedEnumCase = 3;
  static const int unexpectedNullPointer = 4;
  static const int unexpectedRustCallStatusCode = 5;
  static const int unexpectedRustCallError = 6;
  static const int unexpectedStaleHandle = 7;
  static const int rustPanic = 8;
  final int errorCode;
  final String? panicMessage;
  const UniffiInternalError(this.errorCode, this.panicMessage);
  static UniffiInternalError panicked(String message) {
    return UniffiInternalError(rustPanic, message);
  }

  @override
  String toString() {
    switch (errorCode) {
      case bufferOverflow:
        return "UniFfi::BufferOverflow";
      case incompleteData:
        return "UniFfi::IncompleteData";
      case unexpectedOptionalTag:
        return "UniFfi::UnexpectedOptionalTag";
      case unexpectedEnumCase:
        return "UniFfi::UnexpectedEnumCase";
      case unexpectedNullPointer:
        return "UniFfi::UnexpectedNullPointer";
      case unexpectedRustCallStatusCode:
        return "UniFfi::UnexpectedRustCallStatusCode";
      case unexpectedRustCallError:
        return "UniFfi::UnexpectedRustCallError";
      case unexpectedStaleHandle:
        return "UniFfi::UnexpectedStaleHandle";
      case rustPanic:
        return "UniFfi::rustPanic: $panicMessage";
      default:
        return "UniFfi::UnknownError: $errorCode";
    }
  }
}

const int CALL_SUCCESS = 0;
const int CALL_ERROR = 1;
const int CALL_UNEXPECTED_ERROR = 2;

final class RustCallStatus extends Struct {
  @Int8()
  external int code;
  external RustBuffer errorBuf;
}

void checkCallStatus(UniffiRustCallStatusErrorHandler errorHandler,
    Pointer<RustCallStatus> status) {
  if (status.ref.code == CALL_SUCCESS) {
    return;
  } else if (status.ref.code == CALL_ERROR) {
    throw errorHandler.lift(status.ref.errorBuf);
  } else if (status.ref.code == CALL_UNEXPECTED_ERROR) {
    if (status.ref.errorBuf.len > 0) {
      throw UniffiInternalError.panicked(
          FfiConverterString.lift(status.ref.errorBuf));
    } else {
      throw UniffiInternalError.panicked("Rust panic");
    }
  } else {
    throw UniffiInternalError.panicked(
        "Unexpected RustCallStatus code: \${status.ref.code}");
  }
}

T rustCall<T>(T Function(Pointer<RustCallStatus>) callback,
    [UniffiRustCallStatusErrorHandler? errorHandler]) {
  final status = calloc<RustCallStatus>();
  try {
    final result = callback(status);
    checkCallStatus(errorHandler ?? NullRustCallStatusErrorHandler(), status);
    return result;
  } finally {
    calloc.free(status);
  }
}

T rustCallWithLifter<T, F>(
    F Function(Pointer<RustCallStatus>) ffiCall, T Function(F) lifter,
    [UniffiRustCallStatusErrorHandler? errorHandler]) {
  final status = calloc<RustCallStatus>();
  try {
    final rawResult = ffiCall(status);
    checkCallStatus(errorHandler ?? NullRustCallStatusErrorHandler(), status);
    return lifter(rawResult);
  } finally {
    calloc.free(status);
  }
}

class NullRustCallStatusErrorHandler extends UniffiRustCallStatusErrorHandler {
  @override
  Exception lift(RustBuffer errorBuf) {
    errorBuf.free();
    return UniffiInternalError.panicked("Unexpected CALL_ERROR");
  }
}

abstract class UniffiRustCallStatusErrorHandler {
  Exception lift(RustBuffer errorBuf);
}

final class RustBuffer extends Struct {
  @Uint64()
  external int capacity;
  @Uint64()
  external int len;
  external Pointer<Uint8> data;
  static RustBuffer alloc(int size) {
    return rustCall(
        (status) => ffi_beyondtranslate_core_rustbuffer_alloc(size, status));
  }

  static RustBuffer fromBytes(ForeignBytes bytes) {
    return rustCall((status) =>
        ffi_beyondtranslate_core_rustbuffer_from_bytes(bytes, status));
  }

  void free() {
    rustCall(
        (status) => ffi_beyondtranslate_core_rustbuffer_free(this, status));
  }

  RustBuffer reserve(int additionalCapacity) {
    return rustCall((status) => ffi_beyondtranslate_core_rustbuffer_reserve(
        this, additionalCapacity, status));
  }

  Uint8List asUint8List() {
    final dataList = data.asTypedList(len);
    final byteData = ByteData.sublistView(dataList);
    return Uint8List.view(byteData.buffer);
  }

  @override
  String toString() {
    return "RustBuffer{capacity: \$capacity, len: \$len, data: \$data}";
  }
}

RustBuffer toRustBuffer(Uint8List data) {
  final length = data.length;
  final Pointer<Uint8> frameData = calloc<Uint8>(length);
  final pointerList = frameData.asTypedList(length);
  pointerList.setAll(0, data);
  final bytes = calloc<ForeignBytes>();
  bytes.ref.len = length;
  bytes.ref.data = frameData;
  return RustBuffer.fromBytes(bytes.ref);
}

final class ForeignBytes extends Struct {
  @Int32()
  external int len;
  external Pointer<Uint8> data;
  void free() {
    calloc.free(data);
  }
}

class LiftRetVal<T> {
  final T value;
  final int bytesRead;
  const LiftRetVal(this.value, this.bytesRead);
  LiftRetVal<T> copyWithOffset(int offset) {
    return LiftRetVal(value, bytesRead + offset);
  }
}

abstract class FfiConverter<D, F> {
  const FfiConverter();
  D lift(F value);
  F lower(D value);
  D read(ByteData buffer, int offset);
  void write(D value, ByteData buffer, int offset);
  int size(D value);
}

mixin FfiConverterPrimitive<T> on FfiConverter<T, T> {
  @override
  T lift(T value) => value;
  @override
  T lower(T value) => value;
}
Uint8List createUint8ListFromInt(int value) {
  int length = value.bitLength ~/ 8 + 1;
  if (length != 4 && length != 8) {
    length = (value < 0x100000000) ? 4 : 8;
  }
  Uint8List uint8List = Uint8List(length);
  for (int i = length - 1; i >= 0; i--) {
    uint8List[i] = value & 0xFF;
    value >>= 8;
  }
  return uint8List;
}

class FfiConverterOptionalSequenceWordTense {
  static List<WordTense>? lift(RustBuffer buf) {
    return FfiConverterOptionalSequenceWordTense.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<WordTense>?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterSequenceWordTense.read(
        Uint8List.view(buf.buffer, buf.offsetInBytes + 1));
    return LiftRetVal<List<WordTense>?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([List<WordTense>? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterSequenceWordTense.allocationSize(value) + 1;
  }

  static RustBuffer lower(List<WordTense>? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalSequenceWordTense.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalSequenceWordTense.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(List<WordTense>? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterSequenceWordTense.write(
            value, Uint8List.view(buf.buffer, buf.offsetInBytes + 1)) +
        1;
  }
}

class FfiConverterSequenceWordTense {
  static List<WordTense> lift(RustBuffer buf) {
    return FfiConverterSequenceWordTense.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<WordTense>> read(Uint8List buf) {
    List<WordTense> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret =
          FfiConverterWordTense.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<WordTense> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterWordTense.write(
          value[i], Uint8List.view(buf.buffer, offset));
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<WordTense> value) {
    return value
            .map((l) => FfiConverterWordTense.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<WordTense> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterString {
  static String lift(RustBuffer buf) {
    return utf8.decoder.convert(buf.asUint8List());
  }

  static RustBuffer lower(String value) {
    return toRustBuffer(Utf8Encoder().convert(value));
  }

  static LiftRetVal<String> read(Uint8List buf) {
    final end = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0) + 4;
    return LiftRetVal(utf8.decoder.convert(buf, 4, end), end);
  }

  static int allocationSize([String value = ""]) {
    return utf8.encoder.convert(value).length + 4;
  }

  static int write(String value, Uint8List buf) {
    final list = utf8.encoder.convert(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, list.length);
    buf.setAll(4, list);
    return list.length + 4;
  }
}

class FfiConverterOptionalSequenceWordTag {
  static List<WordTag>? lift(RustBuffer buf) {
    return FfiConverterOptionalSequenceWordTag.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<WordTag>?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterSequenceWordTag.read(
        Uint8List.view(buf.buffer, buf.offsetInBytes + 1));
    return LiftRetVal<List<WordTag>?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([List<WordTag>? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterSequenceWordTag.allocationSize(value) + 1;
  }

  static RustBuffer lower(List<WordTag>? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalSequenceWordTag.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalSequenceWordTag.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(List<WordTag>? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterSequenceWordTag.write(
            value, Uint8List.view(buf.buffer, buf.offsetInBytes + 1)) +
        1;
  }
}

class FfiConverterSequenceWordTag {
  static List<WordTag> lift(RustBuffer buf) {
    return FfiConverterSequenceWordTag.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<WordTag>> read(Uint8List buf) {
    List<WordTag> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = FfiConverterWordTag.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<WordTag> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterWordTag.write(
          value[i], Uint8List.view(buf.buffer, offset));
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<WordTag> value) {
    return value
            .map((l) => FfiConverterWordTag.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<WordTag> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalSequenceWordPronunciation {
  static List<WordPronunciation>? lift(RustBuffer buf) {
    return FfiConverterOptionalSequenceWordPronunciation.read(buf.asUint8List())
        .value;
  }

  static LiftRetVal<List<WordPronunciation>?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterSequenceWordPronunciation.read(
        Uint8List.view(buf.buffer, buf.offsetInBytes + 1));
    return LiftRetVal<List<WordPronunciation>?>(
        result.value, result.bytesRead + 1);
  }

  static int allocationSize([List<WordPronunciation>? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterSequenceWordPronunciation.allocationSize(value) + 1;
  }

  static RustBuffer lower(List<WordPronunciation>? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length =
        FfiConverterOptionalSequenceWordPronunciation.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalSequenceWordPronunciation.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(List<WordPronunciation>? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterSequenceWordPronunciation.write(
            value, Uint8List.view(buf.buffer, buf.offsetInBytes + 1)) +
        1;
  }
}

class FfiConverterSequenceWordPronunciation {
  static List<WordPronunciation> lift(RustBuffer buf) {
    return FfiConverterSequenceWordPronunciation.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<WordPronunciation>> read(Uint8List buf) {
    List<WordPronunciation> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = FfiConverterWordPronunciation.read(
          Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<WordPronunciation> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterWordPronunciation.write(
          value[i], Uint8List.view(buf.buffer, offset));
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<WordPronunciation> value) {
    return value
            .map((l) => FfiConverterWordPronunciation.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<WordPronunciation> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterSequenceTextTranslation {
  static List<TextTranslation> lift(RustBuffer buf) {
    return FfiConverterSequenceTextTranslation.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<TextTranslation>> read(Uint8List buf) {
    List<TextTranslation> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret =
          FfiConverterTextTranslation.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<TextTranslation> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterTextTranslation.write(
          value[i], Uint8List.view(buf.buffer, offset));
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<TextTranslation> value) {
    return value
            .map((l) => FfiConverterTextTranslation.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<TextTranslation> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalSequenceWordPhrase {
  static List<WordPhrase>? lift(RustBuffer buf) {
    return FfiConverterOptionalSequenceWordPhrase.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<WordPhrase>?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterSequenceWordPhrase.read(
        Uint8List.view(buf.buffer, buf.offsetInBytes + 1));
    return LiftRetVal<List<WordPhrase>?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([List<WordPhrase>? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterSequenceWordPhrase.allocationSize(value) + 1;
  }

  static RustBuffer lower(List<WordPhrase>? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalSequenceWordPhrase.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalSequenceWordPhrase.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(List<WordPhrase>? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterSequenceWordPhrase.write(
            value, Uint8List.view(buf.buffer, buf.offsetInBytes + 1)) +
        1;
  }
}

class FfiConverterSequenceWordPhrase {
  static List<WordPhrase> lift(RustBuffer buf) {
    return FfiConverterSequenceWordPhrase.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<WordPhrase>> read(Uint8List buf) {
    List<WordPhrase> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret =
          FfiConverterWordPhrase.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<WordPhrase> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterWordPhrase.write(
          value[i], Uint8List.view(buf.buffer, offset));
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<WordPhrase> value) {
    return value
            .map((l) => FfiConverterWordPhrase.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<WordPhrase> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterSequenceString {
  static List<String> lift(RustBuffer buf) {
    return FfiConverterSequenceString.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<String>> read(Uint8List buf) {
    List<String> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = FfiConverterString.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<String> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterString.write(
          value[i], Uint8List.view(buf.buffer, offset));
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<String> value) {
    return value
            .map((l) => FfiConverterString.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<String> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalSequenceWordDefinition {
  static List<WordDefinition>? lift(RustBuffer buf) {
    return FfiConverterOptionalSequenceWordDefinition.read(buf.asUint8List())
        .value;
  }

  static LiftRetVal<List<WordDefinition>?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterSequenceWordDefinition.read(
        Uint8List.view(buf.buffer, buf.offsetInBytes + 1));
    return LiftRetVal<List<WordDefinition>?>(
        result.value, result.bytesRead + 1);
  }

  static int allocationSize([List<WordDefinition>? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterSequenceWordDefinition.allocationSize(value) + 1;
  }

  static RustBuffer lower(List<WordDefinition>? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length =
        FfiConverterOptionalSequenceWordDefinition.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalSequenceWordDefinition.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(List<WordDefinition>? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterSequenceWordDefinition.write(
            value, Uint8List.view(buf.buffer, buf.offsetInBytes + 1)) +
        1;
  }
}

class FfiConverterSequenceWordDefinition {
  static List<WordDefinition> lift(RustBuffer buf) {
    return FfiConverterSequenceWordDefinition.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<WordDefinition>> read(Uint8List buf) {
    List<WordDefinition> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret =
          FfiConverterWordDefinition.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<WordDefinition> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterWordDefinition.write(
          value[i], Uint8List.view(buf.buffer, offset));
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<WordDefinition> value) {
    return value
            .map((l) => FfiConverterWordDefinition.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<WordDefinition> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalSequenceTextDetection {
  static List<TextDetection>? lift(RustBuffer buf) {
    return FfiConverterOptionalSequenceTextDetection.read(buf.asUint8List())
        .value;
  }

  static LiftRetVal<List<TextDetection>?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterSequenceTextDetection.read(
        Uint8List.view(buf.buffer, buf.offsetInBytes + 1));
    return LiftRetVal<List<TextDetection>?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([List<TextDetection>? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterSequenceTextDetection.allocationSize(value) + 1;
  }

  static RustBuffer lower(List<TextDetection>? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length =
        FfiConverterOptionalSequenceTextDetection.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalSequenceTextDetection.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(List<TextDetection>? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterSequenceTextDetection.write(
            value, Uint8List.view(buf.buffer, buf.offsetInBytes + 1)) +
        1;
  }
}

class FfiConverterSequenceTextDetection {
  static List<TextDetection> lift(RustBuffer buf) {
    return FfiConverterSequenceTextDetection.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<TextDetection>> read(Uint8List buf) {
    List<TextDetection> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret =
          FfiConverterTextDetection.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<TextDetection> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterTextDetection.write(
          value[i], Uint8List.view(buf.buffer, offset));
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<TextDetection> value) {
    return value
            .map((l) => FfiConverterTextDetection.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<TextDetection> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalString {
  static String? lift(RustBuffer buf) {
    return FfiConverterOptionalString.read(buf.asUint8List()).value;
  }

  static LiftRetVal<String?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterString.read(
        Uint8List.view(buf.buffer, buf.offsetInBytes + 1));
    return LiftRetVal<String?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([String? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterString.allocationSize(value) + 1;
  }

  static RustBuffer lower(String? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalString.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalString.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(String? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterString.write(
            value, Uint8List.view(buf.buffer, buf.offsetInBytes + 1)) +
        1;
  }
}

class FfiConverterOptionalSequenceWordSentence {
  static List<WordSentence>? lift(RustBuffer buf) {
    return FfiConverterOptionalSequenceWordSentence.read(buf.asUint8List())
        .value;
  }

  static LiftRetVal<List<WordSentence>?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterSequenceWordSentence.read(
        Uint8List.view(buf.buffer, buf.offsetInBytes + 1));
    return LiftRetVal<List<WordSentence>?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([List<WordSentence>? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterSequenceWordSentence.allocationSize(value) + 1;
  }

  static RustBuffer lower(List<WordSentence>? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length =
        FfiConverterOptionalSequenceWordSentence.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalSequenceWordSentence.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(List<WordSentence>? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterSequenceWordSentence.write(
            value, Uint8List.view(buf.buffer, buf.offsetInBytes + 1)) +
        1;
  }
}

class FfiConverterSequenceWordSentence {
  static List<WordSentence> lift(RustBuffer buf) {
    return FfiConverterSequenceWordSentence.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<WordSentence>> read(Uint8List buf) {
    List<WordSentence> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret =
          FfiConverterWordSentence.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<WordSentence> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterWordSentence.write(
          value[i], Uint8List.view(buf.buffer, offset));
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<WordSentence> value) {
    return value
            .map((l) => FfiConverterWordSentence.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<WordSentence> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalSequenceWordImage {
  static List<WordImage>? lift(RustBuffer buf) {
    return FfiConverterOptionalSequenceWordImage.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<WordImage>?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterSequenceWordImage.read(
        Uint8List.view(buf.buffer, buf.offsetInBytes + 1));
    return LiftRetVal<List<WordImage>?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([List<WordImage>? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterSequenceWordImage.allocationSize(value) + 1;
  }

  static RustBuffer lower(List<WordImage>? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalSequenceWordImage.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalSequenceWordImage.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(List<WordImage>? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterSequenceWordImage.write(
            value, Uint8List.view(buf.buffer, buf.offsetInBytes + 1)) +
        1;
  }
}

class FfiConverterSequenceWordImage {
  static List<WordImage> lift(RustBuffer buf) {
    return FfiConverterSequenceWordImage.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<WordImage>> read(Uint8List buf) {
    List<WordImage> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret =
          FfiConverterWordImage.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<WordImage> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterWordImage.write(
          value[i], Uint8List.view(buf.buffer, offset));
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<WordImage> value) {
    return value
            .map((l) => FfiConverterWordImage.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<WordImage> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalSequenceString {
  static List<String>? lift(RustBuffer buf) {
    return FfiConverterOptionalSequenceString.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<String>?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterSequenceString.read(
        Uint8List.view(buf.buffer, buf.offsetInBytes + 1));
    return LiftRetVal<List<String>?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([List<String>? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterSequenceString.allocationSize(value) + 1;
  }

  static RustBuffer lower(List<String>? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalSequenceString.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalSequenceString.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(List<String>? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterSequenceString.write(
            value, Uint8List.view(buf.buffer, buf.offsetInBytes + 1)) +
        1;
  }
}

const int UNIFFI_RUST_FUTURE_POLL_READY = 0;
const int UNIFFI_RUST_FUTURE_POLL_MAYBE_READY = 1;
typedef UniffiRustFutureContinuationCallback = Void Function(Uint64, Int8);
final _uniffiRustFutureContinuationHandles = UniffiHandleMap<Completer<int>>();
Future<T> uniffiRustCallAsync<T, F>(
  Pointer<Void> Function() rustFutureFunc,
  void Function(
          Pointer<Void>,
          Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
          Pointer<Void>)
      pollFunc,
  F Function(Pointer<Void>, Pointer<RustCallStatus>) completeFunc,
  void Function(Pointer<Void>) freeFunc,
  T Function(F) liftFunc, [
  UniffiRustCallStatusErrorHandler? errorHandler,
]) async {
  final rustFuture = rustFutureFunc();
  final completer = Completer<int>();
  final handle = _uniffiRustFutureContinuationHandles.insert(completer);
  final callbackData = Pointer<Void>.fromAddress(handle);
  late final NativeCallable<UniffiRustFutureContinuationCallback> callback;
  void repoll() {
    pollFunc(
      rustFuture,
      callback.nativeFunction,
      callbackData,
    );
  }

  void onResponse(int data, int pollResult) {
    if (pollResult == UNIFFI_RUST_FUTURE_POLL_READY) {
      final readyCompleter =
          _uniffiRustFutureContinuationHandles.maybeRemove(data);
      if (readyCompleter != null && !readyCompleter.isCompleted) {
        readyCompleter.complete(pollResult);
      }
    } else if (pollResult == UNIFFI_RUST_FUTURE_POLL_MAYBE_READY) {
      repoll();
    } else {
      final errorCompleter =
          _uniffiRustFutureContinuationHandles.maybeRemove(data);
      if (errorCompleter != null && !errorCompleter.isCompleted) {
        errorCompleter.completeError(
          UniffiInternalError.panicked(
            "Unexpected poll result from Rust future: \$pollResult",
          ),
        );
      }
    }
  }

  callback = NativeCallable<UniffiRustFutureContinuationCallback>.listener(
    onResponse,
  );
  try {
    repoll();
    await completer.future;
    final status = calloc<RustCallStatus>();
    try {
      final result = completeFunc(rustFuture, status);
      checkCallStatus(
        errorHandler ?? NullRustCallStatusErrorHandler(),
        status,
      );
      return liftFunc(result);
    } finally {
      calloc.free(status);
    }
  } finally {
    callback.close();
    _uniffiRustFutureContinuationHandles.maybeRemove(handle);
    freeFunc(rustFuture);
  }
}

typedef UniffiForeignFutureFree = Void Function(Uint64);
typedef UniffiForeignFutureFreeDart = void Function(int);

class _UniffiForeignFutureState {
  bool cancelled = false;
}

final _uniffiForeignFutureHandleMap =
    UniffiHandleMap<_UniffiForeignFutureState>();
void _uniffiForeignFutureFree(int handle) {
  final state = _uniffiForeignFutureHandleMap.maybeRemove(handle);
  if (state != null) {
    state.cancelled = true;
  }
}

final Pointer<NativeFunction<UniffiForeignFutureFree>>
    _uniffiForeignFutureFreePointer =
    Pointer.fromFunction<UniffiForeignFutureFree>(_uniffiForeignFutureFree);

final class UniffiForeignFuture extends Struct {
  @Uint64()
  external int handle;
  external Pointer<NativeFunction<UniffiForeignFutureFree>> free;
}

class UniffiHandleMap<T> {
  final Map<int, T> _map = {};
  int _counter = 1;
  int insert(T obj) {
    final handle = _counter;
    _counter += 2;
    _map[handle] = obj;
    return handle;
  }

  T get(int handle) {
    final obj = _map[handle];
    if (obj == null) {
      throw UniffiInternalError(
          UniffiInternalError.unexpectedStaleHandle, "Handle not found");
    }
    return obj;
  }

  void remove(int handle) {
    if (maybeRemove(handle) == null) {
      throw UniffiInternalError(
          UniffiInternalError.unexpectedStaleHandle, "Handle not found");
    }
  }

  T? maybeRemove(int handle) {
    return _map.remove(handle);
  }
}

const _uniffiAssetId =
    "package:beyondtranslate_runtime/uniffi:beyondtranslate_runtime";
@Native<RustBuffer Function(Uint64, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer ffi_beyondtranslate_core_rustbuffer_alloc(
    int size, Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(ForeignBytes, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer ffi_beyondtranslate_core_rustbuffer_from_bytes(
    ForeignBytes bytes, Pointer<RustCallStatus> uniffiStatus);

@Native<Void Function(RustBuffer, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rustbuffer_free(
    RustBuffer buf, Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(RustBuffer, Uint64, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer ffi_beyondtranslate_core_rustbuffer_reserve(
    RustBuffer buf, int additional, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_poll_u8(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_cancel_u8(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_free_u8(
    Pointer<Void> handle);

@Native<Uint8 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external int ffi_beyondtranslate_core_rust_future_complete_u8(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_poll_i8(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_cancel_i8(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_free_i8(
    Pointer<Void> handle);

@Native<Int8 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external int ffi_beyondtranslate_core_rust_future_complete_i8(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_poll_u16(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_cancel_u16(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_free_u16(
    Pointer<Void> handle);

@Native<Uint16 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external int ffi_beyondtranslate_core_rust_future_complete_u16(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_poll_i16(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_cancel_i16(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_free_i16(
    Pointer<Void> handle);

@Native<Int16 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external int ffi_beyondtranslate_core_rust_future_complete_i16(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_poll_u32(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_cancel_u32(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_free_u32(
    Pointer<Void> handle);

@Native<Uint32 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external int ffi_beyondtranslate_core_rust_future_complete_u32(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_poll_i32(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_cancel_i32(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_free_i32(
    Pointer<Void> handle);

@Native<Int32 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external int ffi_beyondtranslate_core_rust_future_complete_i32(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_poll_u64(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_cancel_u64(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_free_u64(
    Pointer<Void> handle);

@Native<Uint64 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external int ffi_beyondtranslate_core_rust_future_complete_u64(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_poll_i64(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_cancel_i64(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_free_i64(
    Pointer<Void> handle);

@Native<Int64 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external int ffi_beyondtranslate_core_rust_future_complete_i64(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_poll_f32(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_cancel_f32(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_free_f32(
    Pointer<Void> handle);

@Native<Float Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external double ffi_beyondtranslate_core_rust_future_complete_f32(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_poll_f64(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_cancel_f64(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_free_f64(
    Pointer<Void> handle);

@Native<Double Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external double ffi_beyondtranslate_core_rust_future_complete_f64(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_poll_rust_buffer(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_cancel_rust_buffer(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_free_rust_buffer(
    Pointer<Void> handle);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer ffi_beyondtranslate_core_rust_future_complete_rust_buffer(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_poll_void(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_cancel_void(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_free_void(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external void ffi_beyondtranslate_core_rust_future_complete_void(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<Uint32 Function()>(assetId: _uniffiAssetId)
external int ffi_beyondtranslate_core_uniffi_contract_version();

void _checkApiVersion() {
  final bindingsVersion = 30;
  final scaffoldingVersion = ffi_beyondtranslate_core_uniffi_contract_version();
  if (bindingsVersion != scaffoldingVersion) {
    throw UniffiInternalError.panicked(
        "UniFFI contract version mismatch: bindings version \$bindingsVersion, scaffolding version \$scaffoldingVersion");
  }
}

void _checkApiChecksums() {}
void ensureInitialized() {
  _checkApiVersion();
  _checkApiChecksums();
}

@Deprecated("Use ensureInitialized instead")
void initialize() {
  ensureInitialized();
}
