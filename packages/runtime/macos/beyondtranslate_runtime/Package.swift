// swift-tools-version: 5.9
//
// Swift Package for the macOS side of the beyondtranslate_runtime Flutter plugin.
//
// Flutter's macOS plugin tooling auto-discovers this manifest because the
// host pubspec declares `pluginClass: BeyondtranslateRuntimePlugin` (combined with
// `ffiPlugin: true`). When the Flutter build runs, it adds this package as
// a SPM dependency of `FlutterGeneratedPluginSwiftPackage`, so any host app
// can simply `import beyondtranslate_runtime` from native Swift code without touching
// its Xcode project.
//
// Two targets:
//
//   * `beyondtranslate_runtimeFFI` exposes the C ABI declared in `beyondtranslate_runtimeFFI.h`
//     to Swift via a Clang module (the name matches the `import` in the
//     generated Swift binding).
//   * `beyondtranslate_runtime` re-exports the uniffi-rs generated Swift binding
//     (`Generated/beyondtranslate_runtime.swift`) plus a tiny `FlutterPlugin` stub
//     (`BeyondtranslateRuntimePlugin.swift`) whose `register(with:)` performs a one-shot
//     `dlopen` of the bundled runtime framework. The dlopen is needed
//     because Dart's native_assets system bundles the cdylib but only loads
//     it lazily on the first `@Native(...)` call - native Swift call sites
//     would otherwise see NULL function pointers.
//
// `dynamic_lookup` defers symbol resolution to runtime; the symbols come
// from the framework `dlopen`'d in `register(with:)`.
import PackageDescription

let package = Package(
  name: "beyondtranslate_runtime",
  platforms: [.macOS(.v10_15)],
  products: [
    .library(name: "beyondtranslate-runtime", targets: ["beyondtranslate_runtime"])
  ],
  dependencies: [
    // Provided by Flutter's macOS SPM tooling at build time. Resolves to
    // `FlutterMacOS.framework` so we can `import FlutterMacOS` from
    // `BeyondtranslateRuntimePlugin`.
    .package(name: "FlutterFramework", path: "../FlutterFramework")
  ],
  targets: [
    .target(
      name: "beyondtranslate_runtime",
      dependencies: [
        "beyondtranslate_runtimeFFI",
        .product(name: "FlutterFramework", package: "FlutterFramework"),
      ],
      path: "Sources/beyondtranslate_runtime",
      linkerSettings: [
        .unsafeFlags(["-Xlinker", "-undefined", "-Xlinker", "dynamic_lookup"])
      ]
    ),
    .target(
      name: "beyondtranslate_runtimeFFI",
      path: "Sources/beyondtranslate_runtimeFFI",
      publicHeadersPath: "include"
    ),
  ]
)
