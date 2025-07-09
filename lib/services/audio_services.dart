import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class AudioServices {
  AudioServices._internal();

  static final AudioServices _instance = AudioServices._internal();

  factory AudioServices() => _instance;

  final audioPlayer = AudioPlayer();

  Future<void> setAudioSource(
    String url, {
    String id = '',
    String title = '',
  }) async {
    await audioPlayer.setAudioSource(
      AudioSource.uri(
        Uri.parse(url),
        tag: MediaItem(
          id: id,
          title: title,
          artUri: Uri.parse(
            'https://static.vecteezy.com/system/resources/thumbnails/052/112/816/small_2x/3d-many-qurans-on-the-wooden-table-islamic-concept-the-holy-al-quran-with-written-arabic-calligraphy-meaning-of-al-quran-photo.jpg',
          ),
        ),
      ),
    );
  }

  Future<void> play() async {
    await audioPlayer.play();
  }

  Future<void> pause() async {
    await audioPlayer.pause();
  }

  void dispose() {
    audioPlayer.dispose();
  }
}
