//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <audioplayers_linux/audioplayers_linux_plugin.h>
#include <clipboard_watcher/clipboard_watcher_plugin.h>
#include <hotkey_manager_linux/hotkey_manager_linux_plugin.h>
#include <screen_capturer_linux/screen_capturer_linux_plugin.h>
#include <screen_retriever/screen_retriever_plugin.h>
#include <screen_text_extractor/screen_text_extractor_plugin.h>
#include <tray_manager/tray_manager_plugin.h>
#include <url_launcher_linux/url_launcher_plugin.h>
#include <window_manager/window_manager_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) audioplayers_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "AudioplayersLinuxPlugin");
  audioplayers_linux_plugin_register_with_registrar(audioplayers_linux_registrar);
  g_autoptr(FlPluginRegistrar) clipboard_watcher_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "ClipboardWatcherPlugin");
  clipboard_watcher_plugin_register_with_registrar(clipboard_watcher_registrar);
  g_autoptr(FlPluginRegistrar) hotkey_manager_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "HotkeyManagerLinuxPlugin");
  hotkey_manager_linux_plugin_register_with_registrar(hotkey_manager_linux_registrar);
  g_autoptr(FlPluginRegistrar) screen_capturer_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "ScreenCapturerLinuxPlugin");
  screen_capturer_linux_plugin_register_with_registrar(screen_capturer_linux_registrar);
  g_autoptr(FlPluginRegistrar) screen_retriever_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "ScreenRetrieverPlugin");
  screen_retriever_plugin_register_with_registrar(screen_retriever_registrar);
  g_autoptr(FlPluginRegistrar) screen_text_extractor_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "ScreenTextExtractorPlugin");
  screen_text_extractor_plugin_register_with_registrar(screen_text_extractor_registrar);
  g_autoptr(FlPluginRegistrar) tray_manager_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "TrayManagerPlugin");
  tray_manager_plugin_register_with_registrar(tray_manager_registrar);
  g_autoptr(FlPluginRegistrar) url_launcher_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "UrlLauncherPlugin");
  url_launcher_plugin_register_with_registrar(url_launcher_linux_registrar);
  g_autoptr(FlPluginRegistrar) window_manager_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "WindowManagerPlugin");
  window_manager_plugin_register_with_registrar(window_manager_registrar);
}
