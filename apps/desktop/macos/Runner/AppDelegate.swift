import Cocoa
import FlutterMacOS
import beyondtranslate_runtime

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
      smokeTestBeyondtranslateRuntime()
    }
  }

  private func smokeTestBeyondtranslateRuntime() {
    NSLog("[beyondtranslate_runtime] version() = %@", beyondtranslate_runtime.version())
    NSLog(
      "[beyondtranslate_runtime] add(a: 2, b: 3) = %d",
      beyondtranslate_runtime.add(a: 2, b: 3)
    )
    NSLog(
      "[beyondtranslate_runtime] greet(name: \"AppDelegate\") = %@",
      beyondtranslate_runtime.greet(name: "AppDelegate")
    )
  }
}
