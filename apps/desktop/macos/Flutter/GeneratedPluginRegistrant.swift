//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import audioplayers_darwin
import clipboard_watcher
import hotkey_manager_macos
import keypress_simulator_macos
import ocr_engine_builtin
import package_info_plus
import path_provider_foundation
import protocol_handler
import screen_capturer_macos
import screen_text_extractor

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  AudioplayersDarwinPlugin.register(with: registry.registrar(forPlugin: "AudioplayersDarwinPlugin"))
  ClipboardWatcherPlugin.register(with: registry.registrar(forPlugin: "ClipboardWatcherPlugin"))
  HotkeyManagerMacosPlugin.register(with: registry.registrar(forPlugin: "HotkeyManagerMacosPlugin"))
  KeypressSimulatorMacosPlugin.register(with: registry.registrar(forPlugin: "KeypressSimulatorMacosPlugin"))
  OcrEngineBuiltinPlugin.register(with: registry.registrar(forPlugin: "OcrEngineBuiltinPlugin"))
  FPPPackageInfoPlusPlugin.register(with: registry.registrar(forPlugin: "FPPPackageInfoPlusPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  ProtocolHandlerPlugin.register(with: registry.registrar(forPlugin: "ProtocolHandlerPlugin"))
  ScreenCapturerMacosPlugin.register(with: registry.registrar(forPlugin: "ScreenCapturerMacosPlugin"))
  ScreenTextExtractorPlugin.register(with: registry.registrar(forPlugin: "ScreenTextExtractorPlugin"))
}
