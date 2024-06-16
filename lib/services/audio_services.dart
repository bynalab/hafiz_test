import 'package:audioplayers/audioplayers.dart';

class AudioServices {
  final audioPlayer = AudioPlayer();

  static AudioServices? _audioServices;
  static AudioServices get getInstance {
    return _audioServices = _audioServices ?? AudioServices();
  }

  Future<void> play(String url) async {
    await audioPlayer.play(UrlSource(url));
  }

  Future<void> pause() async {
    await audioPlayer.pause();
  }
}
