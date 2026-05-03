import 'dart:io';

import 'package:path/path.dart' as path;

import '../rust/api/runtime.dart' as rust_api;
export '../rust/api/mirrors.dart'
    show
        ProviderCapability,
        LookUpRequest,
        LookUpResponse,
        TextTranslation,
        TranslateRequest,
        TranslateResponse,
        WordDefinition,
        WordImage,
        WordPhrase,
        WordPronunciation,
        WordSentence,
        WordTag,
        WordTense;
export '../rust/domain/settings.dart' show ProviderConfigEntry;

/// A simple error class to replace [UniTranslateClientError] from the
/// `uni_translate_client` package. Used to record translation / dictionary
/// lookup failures in [TranslationResultRecord].
class TranslationError {
  final String message;

  const TranslationError({required this.message});

  factory TranslationError.fromJson(Map<String, dynamic> json) =>
      TranslationError(message: json['message'] ?? '');

  Map<String, dynamic> toJson() => {'message': message};
}

String? _dataDir;

String get dataDir {
  if (_dataDir == null) {
    final homeDirectoryPath = Platform.environment['HOME'] ??
        Platform.environment['USERPROFILE'] ??
        Directory.current.path;
    final directory = Directory(
      path.join(homeDirectoryPath),
    );
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    _dataDir = directory.path;
  }
  return _dataDir!;
}

// This is the runtime instance that should be used throughout the app.
final runtime = rust_api.Runtime(dataDir: dataDir);
