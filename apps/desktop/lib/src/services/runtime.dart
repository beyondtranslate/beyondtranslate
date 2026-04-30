import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as path;

import '../rust/api/runtime.dart' as rust_api;
import '../rust/domain/settings.dart';

export '../rust/api/runtime.dart'
    show RustLookupResponse, RustProviderEntry, RustTranslateResponse;

class RuntimeService {
  RuntimeService._();

  static final RuntimeService instance = RuntimeService._();
  Future<rust_api.Runtime>? _client;
  RuntimeSettingsService? _settings;

  Future<String> get storageDir async {
    final homeDirectoryPath = Platform.environment['HOME'] ??
        Platform.environment['USERPROFILE'] ??
        Directory.current.path;
    final directory = Directory(
      path.join(homeDirectoryPath, '.beyondtranslate'),
    );
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    return directory.path;
  }

  Future<String> get settingsFilePath async {
    return path.join(await storageDir, 'settings.json');
  }

  Future<rust_api.Runtime> get client {
    final client = _client;
    if (client != null) {
      return client;
    }

    final nextClient = _createClient();
    _client = nextClient;
    return nextClient;
  }

  RuntimeSettingsService get settings =>
      _settings ??= RuntimeSettingsService._(this);

  RuntimeTranslationService translation(String providerId) {
    return RuntimeTranslationService._(this, providerId);
  }

  RuntimeDictionaryService dictionary(String providerId) {
    return RuntimeDictionaryService._(this, providerId);
  }

  Future<rust_api.Runtime> _createClient() async {
    return rust_api.Runtime(storageDir: await storageDir);
  }
}

class RuntimeSettingsService {
  RuntimeSettingsService._(this._runtime);

  final RuntimeService _runtime;

  Future<RustSettingsDto> get() async {
    return (await _runtime.client).settings().get_();
  }

  Future<String> getJson() async {
    return (await _runtime.client).settings().getJson();
  }

  Future<RustSettingsDto> setTheme(String theme) async {
    return (await _runtime.client).settings().setWindowTheme(
          theme: theme,
        );
  }

  Future<RustSettingsDto> setLanguage(String language) async {
    return (await _runtime.client).settings().setWindowLanguage(
          language: language,
        );
  }

  Future<List<rust_api.RustProviderEntry>> listProviders() async {
    return (await _runtime.client).settings().listProviders();
  }

  Future<rust_api.RustProviderEntry?> getProvider(String providerId) async {
    return (await _runtime.client).settings().getProvider(
          providerId: providerId,
        );
  }

  Future<rust_api.RustProviderEntry> updateProvider({
    required String providerId,
    required String configYaml,
  }) async {
    return (await _runtime.client).settings().updateProvider(
          providerId: providerId,
          configYaml: configYaml,
        );
  }

  Future<rust_api.RustProviderEntry?> deleteProvider(String providerId) async {
    return (await _runtime.client).settings().deleteProvider(
          providerId: providerId,
        );
  }
}

class RuntimeTranslationService {
  RuntimeTranslationService._(this._runtime, this._providerId);

  final RuntimeService _runtime;
  final String _providerId;

  Future<rust_api.RustTranslateResponse> translate({
    required String providerConfigYaml,
    String? sourceLanguage,
    required String targetLanguage,
    required String text,
  }) async {
    return (await _runtime.client)
        .translation(providerId: _providerId)
        .translate(
          request: rust_api.RustTranslateRequest(
            providerConfigYaml: providerConfigYaml,
            sourceLanguage: sourceLanguage,
            targetLanguage: targetLanguage,
            text: text,
          ),
        );
  }
}

class RuntimeDictionaryService {
  RuntimeDictionaryService._(this._runtime, this._providerId);

  final RuntimeService _runtime;
  final String _providerId;

  Future<rust_api.RustLookupResponse> lookup({
    required String providerConfigYaml,
    required String sourceLanguage,
    required String targetLanguage,
    required String word,
  }) async {
    return (await _runtime.client)
        .dictionary(providerId: _providerId)
        .lookup(
          request: rust_api.RustLookupRequest(
            providerConfigYaml: providerConfigYaml,
            sourceLanguage: sourceLanguage,
            targetLanguage: targetLanguage,
            word: word,
          ),
        );
  }
}

final runtime = RuntimeService.instance;
