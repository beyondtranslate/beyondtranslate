import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

  var engine: FlutterEngine?

  override func applicationDidFinishLaunching(_ notification: Notification) {
    ThemeAppearanceController.applySavedPreference()

    engine = FlutterEngine(name: "project", project: nil)
    engine?.run(withEntrypoint: nil)
    if let engine {
      RegisterGeneratedPlugins(registry: engine)
      MacSettingsPlugin.register(
        with: engine.registrar(forPlugin: "MacSettingsPlugin")
      )
      MacWindowAppearancePlugin.register(
        with: engine.registrar(forPlugin: "MacWindowAppearancePlugin")
      )
    }
  }
}
