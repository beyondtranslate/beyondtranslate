import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

abstract mixin class AudioPlayerListener {
  void onPlayerStateChanged(PlayerState state) {}
}

class _GlobalAudioPlayer {
  _GlobalAudioPlayer._() {
    _audioPlayer.onPlayerStateChanged.listen(_handlePlayerStateChanged);
    _audioPlayer.onPlayerComplete.listen((event) {
      _handlePlayerStateChanged(PlayerState.completed);
    });
  }

  /// The shared instance of [_GlobalAudioPlayer].
  static final _GlobalAudioPlayer instance = _GlobalAudioPlayer._();

  final ObserverList<AudioPlayerListener> _listeners =
      ObserverList<AudioPlayerListener>();

  final AudioPlayer _audioPlayer = AudioPlayer();

  UrlSource? source;

  void addListener(AudioPlayerListener listener) {
    _listeners.add(listener);
  }

  void removeListener(AudioPlayerListener listener) {
    _listeners.remove(listener);
  }

  Future<void> play(UrlSource source) async {
    this.source = source;
    await _audioPlayer.stop();
    await Future.delayed(const Duration(milliseconds: 100));
    await _audioPlayer.play(source);
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  void _handlePlayerStateChanged(PlayerState state) {
    for (final AudioPlayerListener listener in _listeners) {
      listener.onPlayerStateChanged(state);
    }
  }
}

final globalAudioPlayer = _GlobalAudioPlayer.instance;
