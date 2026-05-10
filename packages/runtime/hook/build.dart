// Native-assets build hook for the beyondtranslate_runtime Flutter package.
//
// Builds the Rust crate at `rust/` for the current Flutter build target,
// then registers the produced cdylib as a `CodeAsset` so that
// `@Native(assetId: "package:beyondtranslate_runtime/uniffi:beyondtranslate_runtime")` annotations
// in the generated Dart bindings resolve at runtime.
//
// Pre-requisites:
//  - `rustup` is installed and the relevant cross-compilation targets
//    have been added (e.g. `rustup target add aarch64-apple-ios ...`).
//  - For Android: a working NDK toolchain reachable on `PATH`. Easiest
//    path is `cargo install cargo-ndk` and let cargo pick the right linker
//    via `~/.cargo/config.toml`.
//  - Flutter has native-assets enabled: `flutter config --enable-native-assets`.

import 'dart:io';

import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';

const _cdylibBaseName = 'beyondtranslate_runtime';
const _assetName = 'uniffi:$_cdylibBaseName';

Future<void> main(List<String> args) async {
  await build(args, (input, output) async {
    // The Flutter / Dart hooks runner can invoke this hook for non-code
    // build phases (e.g. data-asset-only invocations). Only proceed when
    // code assets have actually been requested.
    if (!input.config.buildCodeAssets) {
      stdout.writeln(
          '[beyondtranslate_runtime] no code-asset config; skipping cargo');
      return;
    }

    final packageRoot = input.packageRoot;
    final rustDir = packageRoot.resolve('rust/');
    final manifest = rustDir.resolve('Cargo.toml').toFilePath();

    final code = input.config.code;
    final targetOS = code.targetOS;
    final targetArch = code.targetArchitecture;
    final triple = _rustTriple(code, targetOS, targetArch);

    final cargoArgs = <String>[
      'build',
      '--release',
      '--manifest-path',
      manifest,
      '--target',
      triple,
      '--lib',
    ];

    stdout.writeln('[beyondtranslate_runtime] cargo ${cargoArgs.join(' ')}');
    final result = await Process.run(
      'cargo',
      cargoArgs,
      environment: await _cargoEnvironment(targetOS, triple),
      includeParentEnvironment: true,
      runInShell: true,
    );
    stdout.write(result.stdout);
    stderr.write(result.stderr);
    if (result.exitCode != 0) {
      throw Exception(
        '[beyondtranslate_runtime] cargo build failed with exit code ${result.exitCode}',
      );
    }

    final cdylibFile = _resolveCdylib(rustDir, triple, targetOS);
    if (!File.fromUri(cdylibFile).existsSync()) {
      throw Exception(
        '[beyondtranslate_runtime] cdylib not found at ${cdylibFile.toFilePath()} '
        'after a successful cargo build',
      );
    }

    output.assets.code.add(
      CodeAsset(
        package: input.packageName,
        name: _assetName,
        linkMode: DynamicLoadingBundled(),
        file: cdylibFile,
      ),
    );
    output.dependencies.addAll([
      rustDir.resolve('Cargo.toml'),
      rustDir.resolve('build.rs'),
      rustDir.resolve('uniffi.toml'),
      rustDir.resolve('src/api.udl'),
      rustDir.resolve('src/lib.rs'),
    ]);
  });
}

Future<Map<String, String>> _cargoEnvironment(OS os, String triple) async {
  if (os != OS.macOS && os != OS.iOS) {
    return const {};
  }

  final sdk = os == OS.iOS ? 'iphoneos' : 'macosx';
  final sdkPath = await _xcrun(['--sdk', sdk, '--show-sdk-path']);
  final cflags = '-isysroot $sdkPath';
  final normalizedTriple = triple.replaceAll('-', '_');

  return {
    'SDKROOT': sdkPath,
    'CFLAGS_$triple': cflags,
    'CFLAGS_$normalizedTriple': cflags,
    'MACOSX_DEPLOYMENT_TARGET': '10.15',
  };
}

Future<String> _xcrun(List<String> args) async {
  final result = await Process.run('xcrun', args, runInShell: true);
  if (result.exitCode != 0) {
    throw Exception(
      '[beyondtranslate_runtime] xcrun ${args.join(' ')} failed with exit code '
      '${result.exitCode}: ${result.stderr}',
    );
  }
  return (result.stdout as String).trim();
}

String _rustTriple(CodeConfig code, OS os, Architecture arch) {
  if (os == OS.macOS) {
    return switch (arch) {
      Architecture.arm64 => 'aarch64-apple-darwin',
      Architecture.x64 => 'x86_64-apple-darwin',
      _ => _unsupported(os, arch),
    };
  }
  if (os == OS.iOS) {
    final isSimulator = code.iOS.targetSdk == IOSSdk.iPhoneSimulator;
    return switch (arch) {
      Architecture.arm64 =>
        isSimulator ? 'aarch64-apple-ios-sim' : 'aarch64-apple-ios',
      Architecture.x64 => 'x86_64-apple-ios',
      _ => _unsupported(os, arch),
    };
  }
  if (os == OS.android) {
    return switch (arch) {
      Architecture.arm64 => 'aarch64-linux-android',
      Architecture.arm => 'armv7-linux-androideabi',
      Architecture.x64 => 'x86_64-linux-android',
      Architecture.ia32 => 'i686-linux-android',
      _ => _unsupported(os, arch),
    };
  }
  if (os == OS.linux) {
    return switch (arch) {
      Architecture.x64 => 'x86_64-unknown-linux-gnu',
      Architecture.arm64 => 'aarch64-unknown-linux-gnu',
      _ => _unsupported(os, arch),
    };
  }
  if (os == OS.windows) {
    return switch (arch) {
      Architecture.x64 => 'x86_64-pc-windows-msvc',
      Architecture.arm64 => 'aarch64-pc-windows-msvc',
      _ => _unsupported(os, arch),
    };
  }
  return _unsupported(os, arch);
}

Never _unsupported(OS os, Architecture arch) {
  throw UnsupportedError(
    '[beyondtranslate_runtime] no Rust target triple mapped for $os/$arch',
  );
}

Uri _resolveCdylib(Uri rustDir, String triple, OS os) {
  final fileName = switch (os) {
    OS.macOS || OS.iOS => 'lib$_cdylibBaseName.dylib',
    OS.windows => '$_cdylibBaseName.dll',
    _ => 'lib$_cdylibBaseName.so',
  };
  // The Rust workspace lives at the repo root (../../../target relative to
  // packages/runtime/rust/Cargo.toml), so build artifacts land there.
  return rustDir.resolve('../../../target/$triple/release/$fileName');
}
