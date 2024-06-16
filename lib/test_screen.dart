import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hafiz_test/model/ayah.model.dart';
import 'package:hafiz_test/model/surah.model.dart';
import 'package:hafiz_test/services/storage.services.dart';
import 'package:hafiz_test/surah/view_full_surah.dart';
import 'package:hafiz_test/util/util.dart';
import 'package:hafiz_test/widget/button.dart';
import 'package:marquee/marquee.dart';

class TestScreen extends StatefulWidget {
  final Surah surah;
  final Ayah ayah;
  final List<Ayah> ayahs;
  final Function()? onRefresh;

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

  Surah surah = Surah();
  List<Ayah> ayahs = [];
  Ayah ayah = Ayah();

  bool isPlaying = false;
  bool autoplay = true;

  Duration? duration;

  Future<void> init() async {
    surah = widget.surah;
    ayah = widget.ayah;
    ayahs = widget.ayahs;

    autoplay = await StorageServices.getInstance.checkAutoPlay();

    handleAudioPlay();
  }

  Future<void> playAudio(String url) async {
    try {
      await audioPlayer.play(UrlSource(url));
      duration = await audioPlayer.getDuration();
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

  Future<void> handleAudioPlay() async {
    if (autoplay) {
      setState(() => isPlaying = true);

      await playAudio(ayah.audio);
    } else {
      audioPlayer.pause();

      setState(() => isPlaying = false);
    }

    StorageServices.getInstance.saveLastRead(surah, ayah);
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

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          if (ayah.numberInSurah < ayahs.length)
            Container(
              width: MediaQuery.sizeOf(context).width,
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
                blankSpace: 10,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF004B40),
                ),
              ),
            ),
          const SizedBox(height: 13),
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
          StreamBuilder<AudioEvent>(
            stream: audioPlayer.eventStream,
            builder: (_, durationState) {
              final progress = durationState.data?.position ?? Duration.zero;

              return ProgressBar(
                barHeight: 8,
                thumbRadius: 0,
                thumbGlowColor: const Color(0xFF004B40).withOpacity(0.3),
                progressBarColor: const Color(0xFF004B40),
                baseBarColor: const Color(0xFFFAF6EB),
                progress: progress,
                total: duration ?? Duration.zero,
                onDragUpdate: (details) {
                  audioPlayer.seek(details.timeStamp);
                },
                onSeek: (value) {
                  audioPlayer.seek(value);
                },
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
                    onPressed: () {
                      isPlaying ? audioPlayer.pause() : playAudio(ayah.audio);

                      isPlaying = !isPlaying;

                      setState(() {});
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
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GradientBorderButton(
                  text: 'Speed 1x',
                  icon: SvgPicture.asset(
                    'assets/img/solar_playback-speed-outline.svg',
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: GradientBorderButton(
                  text: 'Refresh',
                  icon:
                      SvgPicture.asset('assets/img/pepicons-pencil_repeat.svg'),
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
            onTap: () {
              Navigator.push(
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
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
