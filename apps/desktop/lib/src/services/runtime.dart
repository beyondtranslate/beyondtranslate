import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';
import 'package:path_provider/path_provider.dart';

// Re-export uniffi-generated types so that files importing this service do
// not need a separate import of beyondtranslate_runtime.
export 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart'
    show
        // Settings types
        AdvancedSettings,
        AdvancedSettingsPatch,
        ApiServerInfo,
        AppearanceSettings,
        AppearanceSettingsPatch,
        GeneralSettings,
        GeneralSettingsPatch,
        InputSubmitMode,
        ProviderConfigEntry,
        ShortcutSettings,
        ShortcutSettingsPatch,
        TranslationTarget,
        // Translation / look-up types
        DetectLanguageRequest,
        DetectLanguageResponse,
        LookUpRequest,
        LookUpResponse,
        TextTranslation,
        TranslateRequest,
        TranslateResponse,
        WordDefinition,
        WordEtymology,
        WordImage,
        WordPhrase,
        WordPronunciation,
        WordSentence,
        WordSynonym,
        WordTag,
        WordTense,
        ProviderCapability,
        ProviderType,
        RuntimeApiServer,
        RuntimeTextExtractor;

/// [ProviderCapability] is provided by the generated FFI bindings, not
/// from provider_capability.dart which is no longer used.
// export 'provider_capability.dart' show ProviderCapability;

/// Singleton [Runtime] handle, backed by the Rust native library.
///
/// The Rust side keeps a single shared instance per `data_dir`, so this
/// handle references the **same** in-memory state as the [Runtime] used
/// by the native macOS Settings UI (Swift). Writes from either side are
/// immediately visible to the other on the next read.
///
/// Call [initRuntime] during app startup (before [settingsStore.init]) to
/// populate this variable.
late final Runtime runtime;
RuntimeApiServer? _apiServer;
ApiServerInfo? _apiServerInfo;

ApiServerInfo? get apiServerInfo => _apiServerInfo;

/// Initialises the Rust runtime with the platform's application-support
/// directory as the data directory.
///
/// Must be called before any code that accesses [runtime].
Future<void> initRuntime() async {
  final dataDir = await getApplicationSupportDirectory();
  runtime = Runtime(dataDir: dataDir.path);
}

Future<ApiServerInfo?> applyApiServerSettings(AdvancedSettings settings) async {
  if (!settings.apiServerEnabled) {
    stopApiServer();
    return null;
  }

  final host = settings.apiServerHost.trim().isEmpty
      ? '127.0.0.1'
      : settings.apiServerHost.trim();
  final port = settings.apiServerPort;
  final current = _apiServerInfo;
  if (_apiServer != null &&
      current != null &&
      current.host == host &&
      (port == 0 || current.port == port)) {
    return current;
  }

  stopApiServer();
  final server = runtime.startApiServer(host: host, port: port);
  _apiServer = server;
  _apiServerInfo = server.info();
  return _apiServerInfo;
}

void stopApiServer() {
  _apiServer?.stop();
  _apiServer = null;
  _apiServerInfo = null;
}

/// A simple error class used to record translation / dictionary lookup
/// failures in [TranslationResultRecord].
class TranslationError {
  final String message;

  const TranslationError({required this.message});

  factory TranslationError.fromJson(Map<String, dynamic> json) =>
      TranslationError(message: json['message'] ?? '');

  Map<String, dynamic> toJson() => {'message': message};
}
