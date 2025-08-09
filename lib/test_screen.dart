import 'dart:async';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hafiz_test/extension/quran_extension.dart';
import 'package:hafiz_test/locator.dart';
import 'package:hafiz_test/model/ayah.model.dart';
import 'package:hafiz_test/model/surah.model.dart';
import 'package:hafiz_test/services/audio_services.dart';
import 'package:hafiz_test/services/storage/abstract_storage_service.dart';
import 'package:hafiz_test/surah/view_full_surah.dart';
import 'package:hafiz_test/util/util.dart';
import 'package:hafiz_test/widget/button.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';

class TestScreen extends StatefulWidget {
  final Surah surah;
  final Ayah ayah;
  final List<Ayah> ayahs;
  final bool isLoading;
  final Function()? onRefresh;

  const TestScreen({
    super.key,
    required this.surah,
    required this.ayah,
    this.ayahs = const [],
    this.onRefresh,
    this.isLoading = false,
  });

  @override
  State<StatefulWidget> createState() => _TestPage();
}

class _TestPage extends State<TestScreen> {
  final audioServices = AudioServices();
  AudioPlayer get audioPlayer => audioServices.audioPlayer;

  Ayah ayah = Ayah();
  Surah surah = Surah();
  List<Ayah> ayahs = [];

  bool loop = false;
  bool isPlaying = false;
  bool autoplay = true;

  LoopMode loopMode = LoopMode.off;

  final storageServices = getIt<IStorageService>();

  Future<void> init() async {
    surah = widget.surah;
    ayah = widget.ayah;
    ayahs = widget.ayahs;

    autoplay = storageServices.checkAutoPlay();

    audioPlayer.setLoopMode(loopMode);
    await audioPlayer.play();
  }

  void playNextAyah() {
    if (ayah.numberInSurah >= ayahs.length) {
      showSnackBar(context, 'End of Surah');

      return;
    }

    ayah = ayahs[ayah.numberInSurah];

    handleAudioPlay();
  }

  void playPreviousAyah() {
    if (ayah.numberInSurah == 1) {
      showSnackBar(context, 'Beginning of Surah');

      return;
    }

    ayah = ayahs[ayah.numberInSurah - 2];

    handleAudioPlay();
  }

  Future<void> handleAudioPlay() async {
    try {
      await audioServices.setAudioSource(ayah.audioSource);

      if (autoplay) {
        await audioPlayer.play();
      } else {
        await audioPlayer.pause();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    init();

    audioPlayer.playerStateStream.listen((state) {
      setState(() {
        isPlaying = state.playing;
      });

      if (state.processingState == ProcessingState.completed) {
        setState(() => isPlaying = false);

        storageServices.saveLastRead(surah, ayah);
      }
    });
  }

  @override
  dispose() {
    audioServices.stop();

    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  double speed = 1;
  void updatePlaybackRate() {
    speed = (speed == 2.5) ? 0.5 : speed + 0.5;

    audioPlayer.setSpeed(speed);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (ayah.numberInSurah < ayahs.length)
          Container(
            height: 40,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFF5BE),
                  Color(0xFFD0F7EA),
                ],
              ),
            ),
            child: Marquee(
              text: 'Guess the next Ayah!!!',
              blankSpace: 20,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF004B40),
              ),
            ),
          ),
        const SizedBox(height: 13),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: 293,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(23),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF004B40),
                      Color(0xFF00B197),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Image.asset('assets/img/faded_vector_quran.png'),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text(
                              'v${ayah.numberInSurah}',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              ayah.text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Kitab',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Text(
                            surah.englishName,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            surah.englishNameTranslation,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 140,
                            child: Divider(color: Colors.white),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                surah.revelationType.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 5),
                              const CircleAvatar(
                                backgroundColor: Color(0xFFFF8E6F),
                                radius: 2,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${surah.numberOfAyahs} verses'.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 31),
              StreamBuilder<Duration>(
                stream: audioPlayer.positionStream,
                builder: (_, durationState) {
                  final progress = durationState.data ?? Duration.zero;

                  return ProgressBar(
                    barHeight: 8,
                    thumbRadius: 0,
                    thumbGlowColor:
                        const Color(0xFF004B40).withValues(alpha: 0.3),
                    progressBarColor: const Color(0xFF004B40),
                    baseBarColor: const Color(0xFFFAF6EB),
                    progress: progress,
                    total: audioPlayer.duration ?? Duration.zero,
                    onDragUpdate: (details) async {
                      await audioPlayer.pause();
                      await audioPlayer.seek(details.timeStamp);
                    },
                    onSeek: (duration) async {
                      await audioPlayer.seek(duration);
                      await audioPlayer.play();
                    },
                    timeLabelLocation: TimeLabelLocation.sides,
                    timeLabelTextStyle: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF004B40),
                    ),
                  );
                },
              ),
              const SizedBox(height: 31),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Column(
                      children: [
                        const Icon(
                          Icons.skip_previous_rounded,
                          size: 50,
                          color: Color(0xFF004B40),
                        ),
                        Text(
                          'Previous',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF004B40),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () => playPreviousAyah(),
                  ),
                  const SizedBox(width: 20),
                  Container(
                    width: 85,
                    height: 85,
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Color(0xFFFFE456),
                          Color(0xFF95CB92),
                        ],
                      ),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: IconButton(
                        icon: Icon(
                          isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          size: 50,
                          color: const Color(0xFF004B40),
                        ),
                        onPressed: () async {
                          if (isPlaying) {
                            await audioPlayer.pause();
                          } else {
                            if (audioPlayer.processingState ==
                                ProcessingState.completed) {
                              await audioPlayer.seek(Duration.zero);
                            }

                            await audioPlayer.play();
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: Column(
                      children: [
                        const Icon(
                          Icons.skip_next_rounded,
                          size: 50,
                          color: Color(0xFF004B40),
                        ),
                        Text(
                          'Next',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF004B40),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () => playNextAyah(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Loop verse',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF222222),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Switch(
                    value: loop,
                    onChanged: (_) {
                      loop = !loop;

                      loopMode = loop ? LoopMode.one : LoopMode.off;
                      audioPlayer.setLoopMode(loopMode);

                      setState(() {});
                    },
                    activeTrackColor: const Color(0xFF004B40),
                    activeColor: Colors.white,
                  )
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GradientBorderButton(
                      text: 'Speed ${speed}x',
                      icon: SvgPicture.asset(
                        'assets/img/solar_playback-speed-outline.svg',
                      ),
                      onTap: updatePlaybackRate,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: GradientBorderButton(
                      text: 'Refresh',
                      icon: SvgPicture.asset(
                        'assets/img/pepicons-pencil_repeat.svg',
                      ),
                      onTap: () async {
                        await widget.onRefresh?.call();
                        init();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return SurahScreen(surah: surah);
                      },
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/img/iconoir_list.svg'),
                      const SizedBox(width: 8),
                      Text(
                        'See Full List',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF004B40),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
