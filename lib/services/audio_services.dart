import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class AudioServices {
  AudioServices._internal();

  static final AudioServices _instance = AudioServices._internal();

  factory AudioServices() => _instance;

  final audioPlayer = AudioPlayer();

  Future<void> setAudioSource(AudioSource audioSource) async {
    try {
      await audioPlayer.setAudioSource(audioSource);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> setPlaylistAudio(List<AudioSource> audioSources) async {
    try {
      await audioPlayer.setAudioSources(audioSources);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> play() async {
    try {
      await audioPlayer.play();
    } catch (e) {
      debugPrint('Error playing audio: ${e.toString()}');
    }
  }

  Future<void> pause() async {
    try {
      await audioPlayer.pause();
    } catch (e) {
      debugPrint('Error pausing audio: ${e.toString()}');
    }
  }

  Future<void> stop() async {
    try {
      await audioPlayer.stop();
    } catch (e) {
      debugPrint('Error stopping audio: ${e.toString()}');
    }
  }
}
