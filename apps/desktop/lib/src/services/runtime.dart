import 'dart:io';

import 'package:path/path.dart' as path;

import '../rust/api/runtime.dart' as rust_api;
export '../rust/api/mirrors.dart'
    show LookUpRequest, LookUpResponse, TranslateRequest, TranslateResponse;
export '../rust/domain/settings.dart' show ProviderConfigEntry;

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
