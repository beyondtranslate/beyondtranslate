library beyondtranslate_runtime;

import "dart:async";
import "dart:convert";
import "dart:ffi";
import "dart:io" show Platform, File, Directory;
import "dart:isolate";
import "dart:typed_data";
import "package:ffi/ffi.dart";
import "beyondtranslate_core.dart";
import "beyondtranslate_core.dart" as beyondtranslate_core;

class UniffiInternalError implements Exception {
  static const int bufferOverflow = 0;
  static const int incompleteData = 1;
  static const int unexpectedOptionalTag = 2;
  static const int unexpectedEnumCase = 3;
  static const int unexpectedNullPointer = 4;
  static const int unexpectedRustCallStatusCode = 5;
  static const int unexpectedRustCallError = 6;
  static const int unexpectedStaleHandle = 7;
  static const int rustPanic = 8;
  final int errorCode;
  final String? panicMessage;
  const UniffiInternalError(this.errorCode, this.panicMessage);
  static UniffiInternalError panicked(String message) {
    return UniffiInternalError(rustPanic, message);
  }

  @override
  String toString() {
    switch (errorCode) {
      case bufferOverflow:
        return "UniFfi::BufferOverflow";
      case incompleteData:
        return "UniFfi::IncompleteData";
      case unexpectedOptionalTag:
        return "UniFfi::UnexpectedOptionalTag";
      case unexpectedEnumCase:
        return "UniFfi::UnexpectedEnumCase";
      case unexpectedNullPointer:
        return "UniFfi::UnexpectedNullPointer";
      case unexpectedRustCallStatusCode:
        return "UniFfi::UnexpectedRustCallStatusCode";
      case unexpectedRustCallError:
        return "UniFfi::UnexpectedRustCallError";
      case unexpectedStaleHandle:
        return "UniFfi::UnexpectedStaleHandle";
      case rustPanic:
        return "UniFfi::rustPanic: $panicMessage";
      default:
        return "UniFfi::UnknownError: $errorCode";
    }
  }
}

const int CALL_SUCCESS = 0;
const int CALL_ERROR = 1;
const int CALL_UNEXPECTED_ERROR = 2;

final class RustCallStatus extends Struct {
  @Int8()
  external int code;
  external RustBuffer errorBuf;
}

void checkCallStatus(UniffiRustCallStatusErrorHandler errorHandler,
    Pointer<RustCallStatus> status) {
  if (status.ref.code == CALL_SUCCESS) {
    return;
  } else if (status.ref.code == CALL_ERROR) {
    throw errorHandler.lift(status.ref.errorBuf);
  } else if (status.ref.code == CALL_UNEXPECTED_ERROR) {
    if (status.ref.errorBuf.len > 0) {
      throw UniffiInternalError.panicked(
          FfiConverterString.lift(status.ref.errorBuf));
    } else {
      throw UniffiInternalError.panicked("Rust panic");
    }
  } else {
    throw UniffiInternalError.panicked(
        "Unexpected RustCallStatus code: \${status.ref.code}");
  }
}

T rustCall<T>(T Function(Pointer<RustCallStatus>) callback,
    [UniffiRustCallStatusErrorHandler? errorHandler]) {
  final status = calloc<RustCallStatus>();
  try {
    final result = callback(status);
    checkCallStatus(errorHandler ?? NullRustCallStatusErrorHandler(), status);
    return result;
  } finally {
    calloc.free(status);
  }
}

T rustCallWithLifter<T, F>(
    F Function(Pointer<RustCallStatus>) ffiCall, T Function(F) lifter,
    [UniffiRustCallStatusErrorHandler? errorHandler]) {
  final status = calloc<RustCallStatus>();
  try {
    final rawResult = ffiCall(status);
    checkCallStatus(errorHandler ?? NullRustCallStatusErrorHandler(), status);
    return lifter(rawResult);
  } finally {
    calloc.free(status);
  }
}

class NullRustCallStatusErrorHandler extends UniffiRustCallStatusErrorHandler {
  @override
  Exception lift(RustBuffer errorBuf) {
    errorBuf.free();
    return UniffiInternalError.panicked("Unexpected CALL_ERROR");
  }
}

abstract class UniffiRustCallStatusErrorHandler {
  Exception lift(RustBuffer errorBuf);
}

final class RustBuffer extends Struct {
  @Uint64()
  external int capacity;
  @Uint64()
  external int len;
  external Pointer<Uint8> data;
  static RustBuffer alloc(int size) {
    return rustCall(
        (status) => ffi_beyondtranslate_runtime_rustbuffer_alloc(size, status));
  }

  static RustBuffer fromBytes(ForeignBytes bytes) {
    return rustCall((status) =>
        ffi_beyondtranslate_runtime_rustbuffer_from_bytes(bytes, status));
  }

  void free() {
    rustCall(
        (status) => ffi_beyondtranslate_runtime_rustbuffer_free(this, status));
  }

  RustBuffer reserve(int additionalCapacity) {
    return rustCall((status) => ffi_beyondtranslate_runtime_rustbuffer_reserve(
        this, additionalCapacity, status));
  }

  Uint8List asUint8List() {
    final dataList = data.asTypedList(len);
    final byteData = ByteData.sublistView(dataList);
    return Uint8List.view(byteData.buffer);
  }

  @override
  String toString() {
    return "RustBuffer{capacity: \$capacity, len: \$len, data: \$data}";
  }
}

RustBuffer toRustBuffer(Uint8List data) {
  final length = data.length;
  final Pointer<Uint8> frameData = calloc<Uint8>(length);
  final pointerList = frameData.asTypedList(length);
  pointerList.setAll(0, data);
  final bytes = calloc<ForeignBytes>();
  bytes.ref.len = length;
  bytes.ref.data = frameData;
  return RustBuffer.fromBytes(bytes.ref);
}

final class ForeignBytes extends Struct {
  @Int32()
  external int len;
  external Pointer<Uint8> data;
  void free() {
    calloc.free(data);
  }
}

class LiftRetVal<T> {
  final T value;
  final int bytesRead;
  const LiftRetVal(this.value, this.bytesRead);
  LiftRetVal<T> copyWithOffset(int offset) {
    return LiftRetVal(value, bytesRead + offset);
  }
}

abstract class FfiConverter<D, F> {
  const FfiConverter();
  D lift(F value);
  F lower(D value);
  D read(ByteData buffer, int offset);
  void write(D value, ByteData buffer, int offset);
  int size(D value);
}

mixin FfiConverterPrimitive<T> on FfiConverter<T, T> {
  @override
  T lift(T value) => value;
  @override
  T lower(T value) => value;
}
Uint8List createUint8ListFromInt(int value) {
  int length = value.bitLength ~/ 8 + 1;
  if (length != 4 && length != 8) {
    length = (value < 0x100000000) ? 4 : 8;
  }
  Uint8List uint8List = Uint8List(length);
  for (int i = length - 1; i >= 0; i--) {
    uint8List[i] = value & 0xFF;
    value >>= 8;
  }
  return uint8List;
}

class FfiConverterString {
  static String lift(RustBuffer buf) {
    return utf8.decoder.convert(buf.asUint8List());
  }

  static RustBuffer lower(String value) {
    return toRustBuffer(Utf8Encoder().convert(value));
  }

  static LiftRetVal<String> read(Uint8List buf) {
    final end = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0) + 4;
    return LiftRetVal(utf8.decoder.convert(buf, 4, end), end);
  }

  static int allocationSize([String value = ""]) {
    return utf8.encoder.convert(value).length + 4;
  }

  static int write(String value, Uint8List buf) {
    final list = utf8.encoder.convert(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, list.length);
    buf.setAll(4, list);
    return list.length + 4;
  }
}

class FfiConverterInt32 {
  static int lift(int value) => value;
  static LiftRetVal<int> read(Uint8List buf) {
    return LiftRetVal(buf.buffer.asByteData(buf.offsetInBytes).getInt32(0), 4);
  }

  static int lower(int value) {
    if (value < -2147483648 || value > 2147483647) {
      throw ArgumentError("Value out of range for i32: " + value.toString());
    }
    return value;
  }

  static int allocationSize([int value = 0]) {
    return 4;
  }

  static int write(int value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, lower(value));
    return 4;
  }
}

const int UNIFFI_RUST_FUTURE_POLL_READY = 0;
const int UNIFFI_RUST_FUTURE_POLL_MAYBE_READY = 1;
typedef UniffiRustFutureContinuationCallback = Void Function(Uint64, Int8);
final _uniffiRustFutureContinuationHandles = UniffiHandleMap<Completer<int>>();
Future<T> uniffiRustCallAsync<T, F>(
  Pointer<Void> Function() rustFutureFunc,
  void Function(
          Pointer<Void>,
          Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
          Pointer<Void>)
      pollFunc,
  F Function(Pointer<Void>, Pointer<RustCallStatus>) completeFunc,
  void Function(Pointer<Void>) freeFunc,
  T Function(F) liftFunc, [
  UniffiRustCallStatusErrorHandler? errorHandler,
]) async {
  final rustFuture = rustFutureFunc();
  final completer = Completer<int>();
  final handle = _uniffiRustFutureContinuationHandles.insert(completer);
  final callbackData = Pointer<Void>.fromAddress(handle);
  late final NativeCallable<UniffiRustFutureContinuationCallback> callback;
  void repoll() {
    pollFunc(
      rustFuture,
      callback.nativeFunction,
      callbackData,
    );
  }

  void onResponse(int data, int pollResult) {
    if (pollResult == UNIFFI_RUST_FUTURE_POLL_READY) {
      final readyCompleter =
          _uniffiRustFutureContinuationHandles.maybeRemove(data);
      if (readyCompleter != null && !readyCompleter.isCompleted) {
        readyCompleter.complete(pollResult);
      }
    } else if (pollResult == UNIFFI_RUST_FUTURE_POLL_MAYBE_READY) {
      repoll();
    } else {
      final errorCompleter =
          _uniffiRustFutureContinuationHandles.maybeRemove(data);
      if (errorCompleter != null && !errorCompleter.isCompleted) {
        errorCompleter.completeError(
          UniffiInternalError.panicked(
            "Unexpected poll result from Rust future: \$pollResult",
          ),
        );
      }
    }
  }

  callback = NativeCallable<UniffiRustFutureContinuationCallback>.listener(
    onResponse,
  );
  try {
    repoll();
    await completer.future;
    final status = calloc<RustCallStatus>();
    try {
      final result = completeFunc(rustFuture, status);
      checkCallStatus(
        errorHandler ?? NullRustCallStatusErrorHandler(),
        status,
      );
      return liftFunc(result);
    } finally {
      calloc.free(status);
    }
  } finally {
    callback.close();
    _uniffiRustFutureContinuationHandles.maybeRemove(handle);
    freeFunc(rustFuture);
  }
}

typedef UniffiForeignFutureFree = Void Function(Uint64);
typedef UniffiForeignFutureFreeDart = void Function(int);

class _UniffiForeignFutureState {
  bool cancelled = false;
}

final _uniffiForeignFutureHandleMap =
    UniffiHandleMap<_UniffiForeignFutureState>();
void _uniffiForeignFutureFree(int handle) {
  final state = _uniffiForeignFutureHandleMap.maybeRemove(handle);
  if (state != null) {
    state.cancelled = true;
  }
}

final Pointer<NativeFunction<UniffiForeignFutureFree>>
    _uniffiForeignFutureFreePointer =
    Pointer.fromFunction<UniffiForeignFutureFree>(_uniffiForeignFutureFree);

final class UniffiForeignFuture extends Struct {
  @Uint64()
  external int handle;
  external Pointer<NativeFunction<UniffiForeignFutureFree>> free;
}

class UniffiHandleMap<T> {
  final Map<int, T> _map = {};
  int _counter = 1;
  int insert(T obj) {
    final handle = _counter;
    _counter += 2;
    _map[handle] = obj;
    return handle;
  }

  T get(int handle) {
    final obj = _map[handle];
    if (obj == null) {
      throw UniffiInternalError(
          UniffiInternalError.unexpectedStaleHandle, "Handle not found");
    }
    return obj;
  }

  void remove(int handle) {
    if (maybeRemove(handle) == null) {
      throw UniffiInternalError(
          UniffiInternalError.unexpectedStaleHandle, "Handle not found");
    }
  }

  T? maybeRemove(int handle) {
    return _map.remove(handle);
  }
}

const _uniffiAssetId =
    "package:beyondtranslate_runtime/uniffi:beyondtranslate_runtime";
int add({
  required int a,
  required int b,
}) {
  return rustCallWithLifter(
      (status) => uniffi_beyondtranslate_runtime_fn_func_add(
          FfiConverterInt32.lower(a), FfiConverterInt32.lower(b), status),
      FfiConverterInt32.lift,
      null);
}

DetectLanguageRequest echoDetectLanguageRequest({
  required DetectLanguageRequest request,
}) {
  return rustCallWithLifter(
      (status) =>
          uniffi_beyondtranslate_runtime_fn_func_echo_detect_language_request(
              FfiConverterDetectLanguageRequest.lower(request), status),
      FfiConverterDetectLanguageRequest.lift,
      null);
}

DetectLanguageResponse echoDetectLanguageResponse({
  required DetectLanguageResponse response,
}) {
  return rustCallWithLifter(
      (status) =>
          uniffi_beyondtranslate_runtime_fn_func_echo_detect_language_response(
              FfiConverterDetectLanguageResponse.lower(response), status),
      FfiConverterDetectLanguageResponse.lift,
      null);
}

LanguagePair echoLanguagePair({
  required LanguagePair languagePair,
}) {
  return rustCallWithLifter(
      (status) => uniffi_beyondtranslate_runtime_fn_func_echo_language_pair(
          FfiConverterLanguagePair.lower(languagePair), status),
      FfiConverterLanguagePair.lift,
      null);
}

LookUpRequest echoLookUpRequest({
  required LookUpRequest request,
}) {
  return rustCallWithLifter(
      (status) => uniffi_beyondtranslate_runtime_fn_func_echo_look_up_request(
          FfiConverterLookUpRequest.lower(request), status),
      FfiConverterLookUpRequest.lift,
      null);
}

LookUpResponse echoLookUpResponse({
  required LookUpResponse response,
}) {
  return rustCallWithLifter(
      (status) => uniffi_beyondtranslate_runtime_fn_func_echo_look_up_response(
          FfiConverterLookUpResponse.lower(response), status),
      FfiConverterLookUpResponse.lift,
      null);
}

TextDetection echoTextDetection({
  required TextDetection textDetection,
}) {
  return rustCallWithLifter(
      (status) => uniffi_beyondtranslate_runtime_fn_func_echo_text_detection(
          FfiConverterTextDetection.lower(textDetection), status),
      FfiConverterTextDetection.lift,
      null);
}

TextTranslation echoTextTranslation({
  required TextTranslation textTranslation,
}) {
  return rustCallWithLifter(
      (status) => uniffi_beyondtranslate_runtime_fn_func_echo_text_translation(
          FfiConverterTextTranslation.lower(textTranslation), status),
      FfiConverterTextTranslation.lift,
      null);
}

TranslateRequest echoTranslateRequest({
  required TranslateRequest request,
}) {
  return rustCallWithLifter(
      (status) => uniffi_beyondtranslate_runtime_fn_func_echo_translate_request(
          FfiConverterTranslateRequest.lower(request), status),
      FfiConverterTranslateRequest.lift,
      null);
}

TranslateResponse echoTranslateResponse({
  required TranslateResponse response,
}) {
  return rustCallWithLifter(
      (status) =>
          uniffi_beyondtranslate_runtime_fn_func_echo_translate_response(
              FfiConverterTranslateResponse.lower(response), status),
      FfiConverterTranslateResponse.lift,
      null);
}

WordDefinition echoWordDefinition({
  required WordDefinition wordDefinition,
}) {
  return rustCallWithLifter(
      (status) => uniffi_beyondtranslate_runtime_fn_func_echo_word_definition(
          FfiConverterWordDefinition.lower(wordDefinition), status),
      FfiConverterWordDefinition.lift,
      null);
}

WordImage echoWordImage({
  required WordImage wordImage,
}) {
  return rustCallWithLifter(
      (status) => uniffi_beyondtranslate_runtime_fn_func_echo_word_image(
          FfiConverterWordImage.lower(wordImage), status),
      FfiConverterWordImage.lift,
      null);
}

WordPhrase echoWordPhrase({
  required WordPhrase wordPhrase,
}) {
  return rustCallWithLifter(
      (status) => uniffi_beyondtranslate_runtime_fn_func_echo_word_phrase(
          FfiConverterWordPhrase.lower(wordPhrase), status),
      FfiConverterWordPhrase.lift,
      null);
}

WordPronunciation echoWordPronunciation({
  required WordPronunciation wordPronunciation,
}) {
  return rustCallWithLifter(
      (status) =>
          uniffi_beyondtranslate_runtime_fn_func_echo_word_pronunciation(
              FfiConverterWordPronunciation.lower(wordPronunciation), status),
      FfiConverterWordPronunciation.lift,
      null);
}

WordSentence echoWordSentence({
  required WordSentence wordSentence,
}) {
  return rustCallWithLifter(
      (status) => uniffi_beyondtranslate_runtime_fn_func_echo_word_sentence(
          FfiConverterWordSentence.lower(wordSentence), status),
      FfiConverterWordSentence.lift,
      null);
}

WordTag echoWordTag({
  required WordTag wordTag,
}) {
  return rustCallWithLifter(
      (status) => uniffi_beyondtranslate_runtime_fn_func_echo_word_tag(
          FfiConverterWordTag.lower(wordTag), status),
      FfiConverterWordTag.lift,
      null);
}

WordTense echoWordTense({
  required WordTense wordTense,
}) {
  return rustCallWithLifter(
      (status) => uniffi_beyondtranslate_runtime_fn_func_echo_word_tense(
          FfiConverterWordTense.lower(wordTense), status),
      FfiConverterWordTense.lift,
      null);
}

String greet({
  required String name,
}) {
  return rustCallWithLifter(
      (status) => uniffi_beyondtranslate_runtime_fn_func_greet(
          FfiConverterString.lower(name), status),
      FfiConverterString.lift,
      null);
}

String version() {
  return rustCallWithLifter(
      (status) => uniffi_beyondtranslate_runtime_fn_func_version(status),
      FfiConverterString.lift,
      null);
}

@Native<Int32 Function(Int32, Int32, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external int uniffi_beyondtranslate_runtime_fn_func_add(
    int a, int b, Pointer<RustCallStatus> uniffiStatus);

@Native<
    beyondtranslate_core.RustBuffer Function(beyondtranslate_core.RustBuffer,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external beyondtranslate_core.RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_detect_language_request(
        beyondtranslate_core.RustBuffer request,
        Pointer<RustCallStatus> uniffiStatus);

@Native<
    beyondtranslate_core.RustBuffer Function(beyondtranslate_core.RustBuffer,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external beyondtranslate_core.RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_detect_language_response(
        beyondtranslate_core.RustBuffer response,
        Pointer<RustCallStatus> uniffiStatus);

@Native<
    beyondtranslate_core.RustBuffer Function(beyondtranslate_core.RustBuffer,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external beyondtranslate_core.RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_language_pair(
        beyondtranslate_core.RustBuffer language_pair,
        Pointer<RustCallStatus> uniffiStatus);

@Native<
    beyondtranslate_core.RustBuffer Function(beyondtranslate_core.RustBuffer,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external beyondtranslate_core.RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_look_up_request(
        beyondtranslate_core.RustBuffer request,
        Pointer<RustCallStatus> uniffiStatus);

@Native<
    beyondtranslate_core.RustBuffer Function(beyondtranslate_core.RustBuffer,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external beyondtranslate_core.RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_look_up_response(
        beyondtranslate_core.RustBuffer response,
        Pointer<RustCallStatus> uniffiStatus);

@Native<
    beyondtranslate_core.RustBuffer Function(beyondtranslate_core.RustBuffer,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external beyondtranslate_core.RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_text_detection(
        beyondtranslate_core.RustBuffer text_detection,
        Pointer<RustCallStatus> uniffiStatus);

@Native<
    beyondtranslate_core.RustBuffer Function(beyondtranslate_core.RustBuffer,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external beyondtranslate_core.RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_text_translation(
        beyondtranslate_core.RustBuffer text_translation,
        Pointer<RustCallStatus> uniffiStatus);

@Native<
    beyondtranslate_core.RustBuffer Function(beyondtranslate_core.RustBuffer,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external beyondtranslate_core.RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_translate_request(
        beyondtranslate_core.RustBuffer request,
        Pointer<RustCallStatus> uniffiStatus);

@Native<
    beyondtranslate_core.RustBuffer Function(beyondtranslate_core.RustBuffer,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external beyondtranslate_core.RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_translate_response(
        beyondtranslate_core.RustBuffer response,
        Pointer<RustCallStatus> uniffiStatus);

@Native<
    beyondtranslate_core.RustBuffer Function(beyondtranslate_core.RustBuffer,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external beyondtranslate_core.RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_word_definition(
        beyondtranslate_core.RustBuffer word_definition,
        Pointer<RustCallStatus> uniffiStatus);

@Native<
    beyondtranslate_core.RustBuffer Function(beyondtranslate_core.RustBuffer,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external beyondtranslate_core.RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_word_image(
        beyondtranslate_core.RustBuffer word_image,
        Pointer<RustCallStatus> uniffiStatus);

@Native<
    beyondtranslate_core.RustBuffer Function(beyondtranslate_core.RustBuffer,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external beyondtranslate_core.RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_word_phrase(
        beyondtranslate_core.RustBuffer word_phrase,
        Pointer<RustCallStatus> uniffiStatus);

@Native<
    beyondtranslate_core.RustBuffer Function(beyondtranslate_core.RustBuffer,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external beyondtranslate_core.RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_word_pronunciation(
        beyondtranslate_core.RustBuffer word_pronunciation,
        Pointer<RustCallStatus> uniffiStatus);

@Native<
    beyondtranslate_core.RustBuffer Function(beyondtranslate_core.RustBuffer,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external beyondtranslate_core.RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_word_sentence(
        beyondtranslate_core.RustBuffer word_sentence,
        Pointer<RustCallStatus> uniffiStatus);

@Native<
    beyondtranslate_core.RustBuffer Function(beyondtranslate_core.RustBuffer,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external beyondtranslate_core.RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_word_tag(
        beyondtranslate_core.RustBuffer word_tag,
        Pointer<RustCallStatus> uniffiStatus);

@Native<
    beyondtranslate_core.RustBuffer Function(beyondtranslate_core.RustBuffer,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external beyondtranslate_core.RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_word_tense(
        beyondtranslate_core.RustBuffer word_tense,
        Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(RustBuffer, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer uniffi_beyondtranslate_runtime_fn_func_greet(
    RustBuffer name, Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external RustBuffer uniffi_beyondtranslate_runtime_fn_func_version(
    Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(Uint64, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer ffi_beyondtranslate_runtime_rustbuffer_alloc(
    int size, Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(ForeignBytes, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer ffi_beyondtranslate_runtime_rustbuffer_from_bytes(
    ForeignBytes bytes, Pointer<RustCallStatus> uniffiStatus);

@Native<Void Function(RustBuffer, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rustbuffer_free(
    RustBuffer buf, Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(RustBuffer, Uint64, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer ffi_beyondtranslate_runtime_rustbuffer_reserve(
    RustBuffer buf, int additional, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_poll_u8(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_cancel_u8(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_free_u8(
    Pointer<Void> handle);

@Native<Uint8 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external int ffi_beyondtranslate_runtime_rust_future_complete_u8(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_poll_i8(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_cancel_i8(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_free_i8(
    Pointer<Void> handle);

@Native<Int8 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external int ffi_beyondtranslate_runtime_rust_future_complete_i8(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_poll_u16(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_cancel_u16(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_free_u16(
    Pointer<Void> handle);

@Native<Uint16 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external int ffi_beyondtranslate_runtime_rust_future_complete_u16(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_poll_i16(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_cancel_i16(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_free_i16(
    Pointer<Void> handle);

@Native<Int16 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external int ffi_beyondtranslate_runtime_rust_future_complete_i16(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_poll_u32(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_cancel_u32(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_free_u32(
    Pointer<Void> handle);

@Native<Uint32 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external int ffi_beyondtranslate_runtime_rust_future_complete_u32(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_poll_i32(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_cancel_i32(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_free_i32(
    Pointer<Void> handle);

@Native<Int32 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external int ffi_beyondtranslate_runtime_rust_future_complete_i32(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_poll_u64(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_cancel_u64(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_free_u64(
    Pointer<Void> handle);

@Native<Uint64 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external int ffi_beyondtranslate_runtime_rust_future_complete_u64(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_poll_i64(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_cancel_i64(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_free_i64(
    Pointer<Void> handle);

@Native<Int64 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external int ffi_beyondtranslate_runtime_rust_future_complete_i64(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_poll_f32(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_cancel_f32(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_free_f32(
    Pointer<Void> handle);

@Native<Float Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external double ffi_beyondtranslate_runtime_rust_future_complete_f32(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_poll_f64(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_cancel_f64(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_free_f64(
    Pointer<Void> handle);

@Native<Double Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external double ffi_beyondtranslate_runtime_rust_future_complete_f64(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_poll_rust_buffer(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_cancel_rust_buffer(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_free_rust_buffer(
    Pointer<Void> handle);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer
    ffi_beyondtranslate_runtime_rust_future_complete_rust_buffer(
        Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_poll_void(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_cancel_void(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_free_void(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_complete_void(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_beyondtranslate_runtime_checksum_func_add();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_func_echo_detect_language_request();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_func_echo_detect_language_response();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_beyondtranslate_runtime_checksum_func_echo_language_pair();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_func_echo_look_up_request();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_func_echo_look_up_response();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_beyondtranslate_runtime_checksum_func_echo_text_detection();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_func_echo_text_translation();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_func_echo_translate_request();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_func_echo_translate_response();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_func_echo_word_definition();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_beyondtranslate_runtime_checksum_func_echo_word_image();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_beyondtranslate_runtime_checksum_func_echo_word_phrase();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_func_echo_word_pronunciation();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_beyondtranslate_runtime_checksum_func_echo_word_sentence();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_beyondtranslate_runtime_checksum_func_echo_word_tag();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_beyondtranslate_runtime_checksum_func_echo_word_tense();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_beyondtranslate_runtime_checksum_func_greet();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_beyondtranslate_runtime_checksum_func_version();

@Native<Uint32 Function()>(assetId: _uniffiAssetId)
external int ffi_beyondtranslate_runtime_uniffi_contract_version();

void _checkApiVersion() {
  final bindingsVersion = 30;
  final scaffoldingVersion =
      ffi_beyondtranslate_runtime_uniffi_contract_version();
  if (bindingsVersion != scaffoldingVersion) {
    throw UniffiInternalError.panicked(
        "UniFFI contract version mismatch: bindings version \$bindingsVersion, scaffolding version \$scaffoldingVersion");
  }
}

void _checkApiChecksums() {
  if (uniffi_beyondtranslate_runtime_checksum_func_add() != 17790) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_detect_language_request() !=
      8599) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_detect_language_response() !=
      47914) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_language_pair() !=
      18868) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_look_up_request() !=
      3060) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_look_up_response() !=
      3637) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_text_detection() !=
      46612) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_text_translation() !=
      36395) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_translate_request() !=
      25811) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_translate_response() !=
      58236) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_word_definition() !=
      5681) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_word_image() != 60210) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_word_phrase() != 9437) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_word_pronunciation() !=
      42325) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_word_sentence() !=
      4677) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_word_tag() != 35137) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_word_tense() != 21321) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_greet() != 35598) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_version() != 42317) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
}

void ensureInitialized() {
  _checkApiVersion();
  _checkApiChecksums();
}

@Deprecated("Use ensureInitialized instead")
void initialize() {
  ensureInitialized();
}
