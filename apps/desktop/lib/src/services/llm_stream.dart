import 'dart:async';

import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';

import 'runtime.dart';

/// Wraps a uniffi [StreamCallback] as a Dart [Stream] of [StreamChunkData].
///
/// Usage:
/// ```dart
/// final stream = LlmStream.translate(
///   providerId: 'openai',
///   sourceLang: 'en',
///   targetLang: 'zh',
///   text: 'Hello world',
/// );
/// await for (final chunk in stream) {
///   print(chunk.content);
/// }
/// ```
class LlmStream {
  /// Creates a Dart stream from an LLM streaming translation call.
  ///
  /// The stream yields [StreamChunkData] items with incremental text content.
  /// Completes normally when the LLM finishes, or with an error on failure.
  static Stream<StreamChunkData> translate({
    required String providerId,
    required String sourceLang,
    required String targetLang,
    required String text,
  }) {
    final controller = StreamController<StreamChunkData>();

    final callback = _StreamCallbackImpl(
      onChunk: (content) {
        if (!controller.isClosed) {
          controller.add(StreamChunkData(content: content, isDone: false));
        }
      },
      onFinish: (reason) {
        if (!controller.isClosed) {
          controller.add(
              StreamChunkData(content: '', isDone: true, finishReason: reason));
          controller.close();
        }
      },
      onError: (error) {
        if (!controller.isClosed) {
          controller.addError(Exception(error));
          controller.close();
        }
      },
    );

    try {
      runtime.llm(providerId: providerId).translateStream(
            sourceLang: sourceLang,
            targetLang: targetLang,
            text: text,
            callback: callback,
          );
    } catch (e, st) {
      if (!controller.isClosed) {
        controller.addError(e, st);
        controller.close();
      }
    }

    return controller.stream;
  }
}

/// A single chunk of streaming translation data.
class StreamChunkData {
  final String content;
  final bool isDone;
  final String? finishReason;

  const StreamChunkData({
    required this.content,
    required this.isDone,
    this.finishReason,
  });
}

/// Implements the uniffi-generated [StreamCallback] abstract class.
class _StreamCallbackImpl extends StreamCallback {
  final void Function(String content) _onChunk;
  final void Function(String reason) _onFinish;
  final void Function(String error) _onError;

  _StreamCallbackImpl({
    required void Function(String) onChunk,
    required void Function(String) onFinish,
    required void Function(String) onError,
  })  : _onChunk = onChunk,
        _onFinish = onFinish,
        _onError = onError;

  @override
  void onChunk(String content) => _onChunk(content);

  @override
  void onFinish(String finishReason) => _onFinish(finishReason);

  @override
  void onError(String error) => _onError(error);
}
