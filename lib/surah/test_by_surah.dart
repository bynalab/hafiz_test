import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hafiz_test/surah/view_full_surah.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hafiz_test/model/ayah.model.dart';
import 'package:hafiz_test/model/surah.model.dart';
import 'package:hafiz_test/services/ayah.services.dart';
import 'package:hafiz_test/services/storage.services.dart';
import 'package:hafiz_test/services/surah.services.dart';
import 'package:hafiz_test/util/util.dart';

class TestBySurah extends StatefulWidget {
  final int surahNumber;

  const TestBySurah({Key? key, required this.surahNumber}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TestPage();
}

class _TestPage extends State<TestBySurah> {
  AudioPlayer audioPlayer = AudioPlayer();
  final storageServices = StorageServices();
  final surahServices = SurahServices();
  final ayahServices = AyahServices();

  bool isLoading = false;
  bool isPlaying = false;

  List<Ayah> ayahs = [];
  late Ayah ayah;

  int surahNumber = 1;
  bool get isRandomSurah => widget.surahNumber == 0;

  Future<void> playAudio(String url) async {
    try {
      await audioPlayer.play(UrlSource(url));
    } catch (e) {
      setState(() => isPlaying = false);

      if (kDebugMode) {
        print(e);
      }
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
    audioPlayer.dispose();

    super.dispose();
  }

  bool autoplay = true;
  Surah surah = Surah();

  Future<void> init() async {
    setState(() => isLoading = true);

    surahNumber = widget.surahNumber;

    if (isRandomSurah) {
      surahNumber = surahServices.getRandomSurahNumber();
    }

    if (isRandomSurah || ayahs.isEmpty) {
      surah = await surahServices.getSurah(surahNumber);
    }

    ayahs = surah.ayahs;
    ayah = ayahServices.getRandomAyahForSurah(ayahs);

    autoplay = await storageServices.checkAutoPlay();

    if (autoplay) {
      setState(() => isPlaying = true);

      await playAudio(ayah.audio);
    }

    setState(() => isLoading = false);
  }

  Future<void> playNextAyah() async {
    if (ayah.numberInSurah >= ayahs.length) {
      showSnackBar(context, 'End of Surah');

      return;
    }

    ayah = ayahs[ayah.numberInSurah];

    if (autoplay) {
      setState(() => isPlaying = true);

      await playAudio(ayah.audio);
    } else {
      audioPlayer.pause();

      setState(() => isPlaying = false);
    }
  }

  Future<void> playPreviousAyah() async {
    if (ayah.numberInSurah == 1) {
      showSnackBar(context, 'Beginning of Surah');

      return;
    }

    setState(() {
      ayah = ayahs[ayah.numberInSurah - 2];
    });

    if (autoplay) {
      setState(() => isPlaying = true);

      await playAudio(ayah.audio);
    } else {
      audioPlayer.pause();

      setState(() => isPlaying = false);
    }
  }

  Future<void> refresh() async {
    audioPlayer.stop();

    await init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hafiz'),
        backgroundColor: Colors.blueGrey,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(
                strokeWidth: 5,
                backgroundColor: Colors.blueGrey,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Center(
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
                          fontSize: 20,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '(${surah.englishName} - ${ayah.numberInSurah})',
                      style: const TextStyle(
                        // fontSize: 14,
                        color: Colors.blueGrey,
                      ),
                    ),
                    Text(
                      '(${surah.name})',
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
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
                      onPressed: () async => await refresh(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
