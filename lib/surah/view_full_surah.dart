import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hafiz_test/extension/quran_extension.dart';
import 'package:hafiz_test/model/ayah.model.dart';
import 'package:hafiz_test/model/surah.model.dart';
import 'package:hafiz_test/services/audio_services.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:just_audio/just_audio.dart';

class SurahScreen extends StatefulWidget {
  final Surah surah;

  const SurahScreen({super.key, required this.surah});

  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
  final audioService = AudioServices();
  int playingIndex = 0;

  @override
  void dispose() {
    super.dispose();

    audioService.stop();
  }

  Surah get surah => widget.surah;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: const Color(0xFF004B40),
        scrolledUnderElevation: 10,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: SvgPicture.asset('assets/img/arrow_back.svg'),
                ),
                Flexible(
                  child: Text(
                    '${surah.number}. ${surah.englishName}: ${surah.englishNameTranslation}',
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF222222),
                    ),
                  ),
                ),
              ],
            ),
            Text(
              surah.name,
              style: GoogleFonts.montserrat(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF222222),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/surah_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 30),
          itemCount: surah.ayahs.length,
          itemBuilder: (_, index) {
            return QuranVerseCard(
              index: index,
              ayah: surah.ayahs[index],
              isPlaying: playingIndex == index,
              onPlayPressed: (index) {
                setState(() => playingIndex = index);
              },
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
              color: Color(0xFF222222),
              thickness: 0.09,
            );
          },
        ),
      ),
    );
  }
}

class QuranVerseCard extends StatefulWidget {
  final Ayah ayah;
  final int index;
  final bool isPlaying;
  final void Function(int)? onPlayPressed;

  const QuranVerseCard({
    super.key,
    required this.ayah,
    required this.index,
    this.isPlaying = false,
    this.onPlayPressed,
  });

  @override
  State<QuranVerseCard> createState() => QuranVersenCardState();
}

class QuranVersenCardState extends State<QuranVerseCard> {
  final audioServices = AudioServices();

  bool isLoading = false;
  bool isPlaying = false;

  int selectedIndex = 0;

  Future<void> handleAudio(String url) async {
    try {
      audioServices.setAudioSource(widget.ayah.audioSource);

      await audioServices.pause();
      widget.onPlayPressed?.call(selectedIndex);

      if (isPlaying && widget.isPlaying) {
        await audioServices.pause();
      } else {
        await audioServices.play();
      }
    } catch (e) {
      setState(() => isPlaying = false);
    }
  }

  @override
  void initState() {
    super.initState();

    audioServices.audioPlayer.playerStateStream.listen((state) {
      setState(() {
        isPlaying = state.playing;
      });

      if (state.processingState == ProcessingState.completed) {
        setState(() => isPlaying = false);
      }
    });
  }

  String makeAyahNumber(int ayahNumber) {
    final formatedAyahNumber = NumberFormat('#', 'ar_EG').format(ayahNumber);
    final runes = Runes('   \u{fd3f}$formatedAyahNumber\u{fd3e}');

    return String.fromCharCodes(runes);
  }

  @override
  void dispose() {
    audioServices.audioPlayer.stop();

    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.key,
      padding: const EdgeInsets.only(
        left: 10,
        right: 20,
        bottom: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (widget.index == selectedIndex)
            if (isPlaying && widget.isPlaying)
              const Icon(
                Icons.volume_up_rounded,
                color: Color(0xFF004B40),
                size: 15,
              ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text.rich(
                  textDirection: TextDirection.rtl,
                  TextSpan(
                    children: [
                      TextSpan(
                        text: widget.ayah.text,
                        style: const TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 20,
                          fontFamily: 'Quran',
                        ),
                      ),
                      TextSpan(
                        text: makeAyahNumber(widget.ayah.numberInSurah),
                        style: const TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Quran',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  child: Icon(
                    isPlaying && widget.isPlaying
                        ? Icons.stop_circle_rounded
                        : Icons.play_circle_rounded,
                  ),
                  onTap: () async {
                    selectedIndex = widget.index;
                    setState(() {});

                    if (isPlaying && widget.isPlaying) {
                      await audioServices.pause();
                    } else {
                      await handleAudio(widget.ayah.audio);
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
