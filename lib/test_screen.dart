import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hafiz_test/model/ayah.model.dart';
import 'package:hafiz_test/model/surah.model.dart';
import 'package:hafiz_test/services/storage.services.dart';
import 'package:hafiz_test/surah/view_full_surah.dart';
import 'package:hafiz_test/util/util.dart';

class TestScreen extends StatefulWidget {
  final Surah surah;
  final Ayah ayah;
  final List<Ayah> ayahs;
  final void Function()? onRefresh;

  const TestScreen({
    Key? key,
    required this.surah,
    required this.ayah,
    this.ayahs = const [],
    this.onRefresh,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TestPage();
}

class _TestPage extends State<TestScreen> {
  final audioPlayer = AudioPlayer();
  final storageServices = StorageServices();

  Surah surah = Surah();
  List<Ayah> ayahs = [];
  Ayah ayah = Ayah();

  bool isPlaying = false;
  bool autoplay = true;

  Future<void> init() async {
    surah = widget.surah;
    ayah = widget.ayah;
    ayahs = widget.ayahs;

    autoplay = await storageServices.checkAutoPlay();

    handleAudioPlay();
  }

  Future<void> playAudio(String url) async {
    try {
      await audioPlayer.play(UrlSource(url));
    } catch (e) {
      setState(() => isPlaying = false);
    }
  }

  Future<void> playNextAyah() async {
    if (ayah.numberInSurah >= ayahs.length) {
      showSnackBar(context, 'End of Surah');

      return;
    }

    ayah = ayahs[ayah.numberInSurah];

    handleAudioPlay();
  }

  Future<void> playPreviousAyah() async {
    if (ayah.numberInSurah == 1) {
      showSnackBar(context, 'Beginning of Surah');

      return;
    }

    ayah = ayahs[ayah.numberInSurah - 2];

    handleAudioPlay();
  }

  void handleAudioPlay() {
    if (autoplay) {
      setState(() => isPlaying = true);

      playAudio(ayah.audio);
    } else {
      audioPlayer.pause();

      setState(() => isPlaying = false);
    }
  }

  @override
  void initState() {
    super.initState();

    init();

    audioPlayer.onPlayerComplete.listen((_) async {
      setState(() {
        isPlaying = false;
      });
    });
  }

  @override
  dispose() {
    audioPlayer.stop();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (ayah.numberInSurah < ayahs.length)
              const Text(
                'Guess the next Ayah!!!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 20,
                ),
              ).animate(
                onPlay: (controller) {
                  controller.repeat(reverse: true);
                },
              ).scaleXY(end: 1.5, delay: 1000.ms),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                ayah.text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '(${surah.englishName})',
                    style: const TextStyle(
                      color: Colors.blueGrey,
                    ),
                  ),
                  TextSpan(
                    text: ' - (Q${surah.number} v${ayah.numberInSurah})',
                    style: const TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '(${surah.name})',
              style: const TextStyle(
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              child: Icon(
                isPlaying
                    ? Icons.pause_circle_outline
                    : Icons.play_circle_outline,
                size: 80.0,
                color: Colors.blueGrey,
              ),
              onTap: () {
                isPlaying ? audioPlayer.pause() : playAudio(ayah.audio);

                isPlaying = !isPlaying;

                setState(() {});
              },
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.blueGrey,
                    ),
                  ),
                  onPressed: () => playPreviousAyah(),
                  icon: const Icon(
                    Icons.skip_previous,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Previous',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => playNextAyah(),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.blueGrey,
                    ),
                  ),
                  icon: const Text(
                    'Next',
                    style: TextStyle(color: Colors.white),
                  ),
                  label: const Icon(
                    Icons.skip_next,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.blueGrey,
                ),
              ),
              icon: const Icon(
                Icons.remove_red_eye,
                color: Colors.white,
              ),
              label: const Text(
                'View All',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return SurahScreen(surah: surah);
                    },
                  ),
                );
              },
            ),
            ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.blueGrey,
                ),
              ),
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              label: const Text(
                'Refresh',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => widget.onRefresh?.call(),
            ),
          ],
        ),
      ),
    );
  }
}
