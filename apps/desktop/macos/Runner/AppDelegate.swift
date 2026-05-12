import Cocoa
import FlutterMacOS
import SwiftUI
import beyondtranslate_runtime

class AppDelegate: FlutterAppDelegate {
  private var engine: FlutterEngine?

  @MainActor
  var flutterEngine: FlutterEngine {
    if let engine {
      return engine
    }

    ThemeAppearanceController.applySavedPreference()

    let engine = FlutterEngine(
      name: "beyondtranslate",
      project: nil,
      allowHeadlessExecution: true
    )
    engine.run(withEntrypoint: nil)
    RegisterGeneratedPlugins(registry: engine)
    MacSettingsPlugin.register(
      with: engine.registrar(forPlugin: "MacSettingsPlugin")
    )
    MacWindowAppearancePlugin.register(
      with: engine.registrar(forPlugin: "MacWindowAppearancePlugin")
    )
    smokeTestBeyondtranslateRuntime()
    self.engine = engine
    return engine
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

  override func applicationDidFinishLaunching(_ notification: Notification) {
    super.applicationDidFinishLaunching(notification)
    _ = flutterEngine
  }

  private func smokeTestBeyondtranslateRuntime() {
    NSLog("[beyondtranslate_runtime] version() = %@", beyondtranslate_runtime.version())
    NSLog(
      "[beyondtranslate_runtime] add(a: 2, b: 3) = %d",
      add(a: 2, b: 3)
    )
    NSLog(
      "[beyondtranslate_runtime] greet(name: \"AppDelegate\") = %@",
      greet(name: "AppDelegate")
    )
  }
}

@main
struct RunnerApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

  var body: some Scene {
    let _ = appDelegate.flutterEngine

    Window("Settings", id: "AppSettings") {
      SettingsView()
    }
  }
}
