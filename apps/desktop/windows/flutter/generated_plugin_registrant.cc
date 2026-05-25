//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <audioplayers_windows/audioplayers_windows_plugin.h>
#include <hotkey_manager_windows/hotkey_manager_windows_plugin_c_api.h>
#include <keypress_simulator_windows/keypress_simulator_windows_plugin_c_api.h>
#include <protocol_handler/protocol_handler_plugin.h>
#include <vclibs/vclibs_plugin_c_api.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  AudioplayersWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("AudioplayersWindowsPlugin"));
  HotkeyManagerWindowsPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("HotkeyManagerWindowsPluginCApi"));
  KeypressSimulatorWindowsPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("KeypressSimulatorWindowsPluginCApi"));
  ProtocolHandlerPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ProtocolHandlerPlugin"));
  VclibsPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("VclibsPluginCApi"));
}
