import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';
import 'package:path_provider/path_provider.dart';

// Re-export uniffi-generated types so that files importing this service do
// not need a separate import of beyondtranslate_runtime.
export 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart'
    show
        // Settings types
        AdvancedSettings,
        AdvancedSettingsPatch,
        AppearanceSettings,
        AppearanceSettingsPatch,
        GeneralSettings,
        GeneralSettingsPatch,
        InputSubmitMode,
        ProviderConfigEntry,
        ShortcutSettings,
        ShortcutSettingsPatch,
        TranslationMode,
        TranslationTarget,
        // Translation / look-up types
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

/// [ProviderCapability] is a pure-Dart enum that mirrors the capability
/// strings produced by the Rust engine (e.g. "dictionary", "translation").
export 'provider_capability.dart' show ProviderCapability;

/// Singleton [Runtime] instance, backed by the Rust native library.
///
/// Call [initRuntime] during app startup (before [settingsStore.init]) to
/// populate this variable.
late final Runtime runtime;

/// Initialises the Rust runtime with the platform's application-support
/// directory as the data directory.
///
/// Must be called before any code that accesses [runtime].
Future<void> initRuntime() async {
  final dataDir = await getApplicationSupportDirectory();
  runtime = Runtime(dataDir: dataDir.path);
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
