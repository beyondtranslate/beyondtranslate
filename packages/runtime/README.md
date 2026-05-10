# beyondtranslate_runtime

A Flutter FFI plugin that exposes a small Rust crate to Dart and Swift via
[`uniffi-rs`](https://mozilla.github.io/uniffi-rs/) and
[`uniffi-dart`](https://github.com/Uniffi-Dart/uniffi-dart).

## Layout

```
packages/runtime/
├── rust/                         Cargo crate (workspace member)
│   ├── Cargo.toml
│   ├── build.rs                  Generates the uniffi scaffolding
│   ├── uniffi.toml               Configures the Dart binding (package_name, cdylib_name)
│   └── src/
│       ├── api.udl               UniFFI namespace declaration
│       ├── lib.rs                #[uniffi::export] add / greet / version
│       └── bin/
│           ├── uniffi-bindgen.rs       Wraps uniffi_bindgen_main() (Swift / Kotlin / ...)
│           └── uniffi-bindgen-dart.rs  Calls uniffi_dart::gen::generate_dart_bindings(...)
├── lib/
│   ├── beyondtranslate_runtime.dart          Public re-export
│   └── src/generated/            Committed Dart binding (uniffi-dart)
├── swift/Generated/              Committed Swift binding (uniffi-rs)
├── macos/beyondtranslate_runtime/            Swift Package consumed by Flutter's macOS SPM
│   ├── Package.swift
│   └── Sources/
│       ├── beyondtranslate_runtime/          BeyondtranslateRuntimePlugin.swift + Generated/
│       └── beyondtranslate_runtimeFFI/       C header + module.modulemap (mirror of swift/)
├── hook/build.dart               Native-assets build hook
├── test/beyondtranslate_runtime_test.dart    Smoke test
└── example/                      Minimal Flutter app
```

## Exposed API

The Rust source ([`rust/src/lib.rs`](rust/src/lib.rs)) exports three functions:

| Rust                                      | Dart                            | Swift                                   |
| ----------------------------------------- | ------------------------------- | --------------------------------------- |
| `fn add(a: i32, b: i32) -> i32`           | `add(a: 1, b: 2)`               | `add(a: 1, b: 2)`                       |
| `fn greet(name: String) -> String`        | `greet(name: "World")`          | `greet(name: "World")`                  |
| `fn version() -> String`                  | `version()`                     | `version()`                             |

## Regenerating the bindings

```bash
python3 scripts/generate/runtime_bindings.py
```

This runs `cargo build --release`, then both bindgen binaries against the
host `libbeyondtranslate_runtime.<dylib|so|dll>`, dropping the result into:

- `lib/src/generated/beyondtranslate_runtime.dart`
- `swift/Generated/{beyondtranslate_runtime.swift, beyondtranslate_runtimeFFI.h, beyondtranslate_runtimeFFI.modulemap}`

Both directories are committed so consumers don't need a Rust toolchain to
read the API surface.

## Loading the native library

`hook/build.dart` runs `cargo build --release --target <triple>` for the
target Flutter is building for, then registers a `CodeAsset(package:
"beyondtranslate_runtime", name: "uniffi:beyondtranslate_runtime")` so Dart's
`@Native(assetId: "package:beyondtranslate_runtime/uniffi:beyondtranslate_runtime")` annotations
resolve at runtime.

## Calling the Swift binding from native macOS code

`hook/build.dart` only registers the cdylib for **Dart's** native_assets
system. To also call the UniFFI Swift binding from native code (e.g. from
an `AppDelegate.swift` or a share extension), the plugin ships a Swift
Package at [`macos/beyondtranslate_runtime/`](macos/beyondtranslate_runtime/) that Flutter's macOS
SPM tooling auto-discovers via `pluginClass: BeyondtranslateRuntimePlugin` in
[`pubspec.yaml`](pubspec.yaml).

In the host app you only need to import the module - **no Xcode project
edits, no bridging header, no Ruby script**:

```swift
import Cocoa
import FlutterMacOS
import beyondtranslate_runtime

class AppDelegate: FlutterAppDelegate {
  override func applicationDidFinishLaunching(_ notification: Notification) {
    super.applicationDidFinishLaunching(notification)
    RegisterGeneratedPlugins(registry: self)

    NSLog("version() = %@", beyondtranslate_runtime.version())
    NSLog("add(2,3)  = %d", beyondtranslate_runtime.add(a: 2, b: 3))
    NSLog("greet     = %@", beyondtranslate_runtime.greet(name: "AppDelegate"))
  }
}
```

Run the app and grep for `[beyondtranslate_runtime]` lines in stderr / Console.app:

```text
[beyondtranslate_runtime] version() = 0.1.0
[beyondtranslate_runtime] add(a: 2, b: 3) = 5
[beyondtranslate_runtime] greet(name: "AppDelegate") = Hello, AppDelegate!
```

### How the SPM package works

- `Package.swift` declares two targets:
  - `beyondtranslate_runtimeFFI` is the C umbrella (header + modulemap) for the uniffi
    C ABI, mirrored from `swift/Generated/` by `scripts/generate/runtime_bindings.py`.
  - `beyondtranslate_runtime` re-exports the generated Swift binding plus a tiny
    `FlutterPlugin` stub. It depends on Flutter's `FlutterFramework`
    package (auto-injected by the macOS toolchain) and uses
    `-Xlinker -undefined -Xlinker dynamic_lookup` so unresolved symbols are
    looked up at runtime.
- `BeyondtranslateRuntimePlugin.register(with:)` runs during plugin
  auto-registration and `dlopen`s
  `Frameworks/beyondtranslate_runtime.framework/beyondtranslate_runtime`.
  Call the Swift binding after `RegisterGeneratedPlugins(...)` so the bundled
  runtime has already been loaded.

> iOS support follows the same pattern. Drop a mirror of
> `macos/beyondtranslate_runtime/` under `ios/beyondtranslate_runtime/` and add
> `pluginClass: BeyondtranslateRuntimePlugin` to the iOS entry in `pubspec.yaml`.

## Caveats

1. **Native assets are experimental.** Enable them once per machine:
   ```bash
   flutter config --enable-native-assets
   ```
2. **Cross-compilation Rust toolchains** must be installed for whichever
   targets you build. For example:
   ```bash
   rustup target add aarch64-apple-ios aarch64-apple-ios-sim x86_64-apple-darwin aarch64-apple-darwin
   rustup target add aarch64-linux-android armv7-linux-androideabi x86_64-linux-android i686-linux-android
   ```
   Android also needs the NDK on your `PATH` (`cargo-ndk` is the easiest
   path; the hook will fall back to a clear error if it can't find a
   suitable linker).
3. **The Swift binding** at [`swift/Generated/`](swift/Generated/) is a
   standalone artifact. iOS / macOS host code that wants to call into Rust
   directly (outside of Flutter, e.g. from a share extension) can compile
   those `.swift` and `.h` files alongside the same `libbeyondtranslate_runtime.dylib`
   that native_assets bundles.
4. **uniffi-dart 0.2.x limitations.** `HashMap`, `BigInt`, trait methods
   and proc-macro-only crates are not yet supported. The demo functions
   stay inside the supported subset.
