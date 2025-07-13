import 'package:flutter/material.dart';
import 'package:hafiz_test/extension/quran_extension.dart';
import 'package:hafiz_test/model/surah.model.dart';
import 'package:hafiz_test/quran/ayah_card.dart';
import 'package:hafiz_test/services/audio_services.dart';
import 'package:hafiz_test/services/surah.services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class QuranView extends StatefulWidget {
  final Surah surah;

  const QuranView({super.key, required this.surah});

  @override
  State<QuranView> createState() => _QuranViewState();
}

class _QuranViewState extends State<QuranView> {
  final audioService = AudioServices();
  AudioPlayer get audioPlayer => audioService.audioPlayer;
  final itemScrollController = ItemScrollController();

  int playingIndex = 0;
  bool isLoading = true;
  bool isPlaying = false;
  late Surah surah;

  @override
  void initState() {
    super.initState();

    init();
    initiateListerners();
  }

  int playlistIndex = 0;
  Duration playlistPosition = Duration.zero;

  void initiateListerners() {
    audioPlayer.playerStateStream.listen((state) {
      setState(() => isPlaying = state.playing);

      if (state.processingState == ProcessingState.completed) {
        setState(() => isPlaying = false);
      }
    });

    audioPlayer.currentIndexStream.listen((index) {
      if (index != null && isPlaylist) {
        scrollToVerse(index);
        setState(() => playingIndex = index);
      }
    });
  }

  Future<void> init() async {
    surah = await SurahServices().getSurah(widget.surah.number);

    await audioService.setPlaylistAudio(surah.audioSources);

    setState(() => isLoading = false);
  }

  bool isPlaylist = false;
  Future<void> _togglePlayPause() async {
    if (!isPlaylist) {
      setState(() {
        isPlaylist = true;
        playingIndex = playlistIndex;
      });

      await audioService.setPlaylistAudio(surah.audioSources);
      await audioService.audioPlayer
          .seek(playlistPosition, index: playlistIndex);

      await audioService.play();

      return;
    }

    setState(() => isPlaylist = true);

    isPlaying ? await audioService.pause() : await audioService.play();
  }

  @override
  void dispose() {
    audioService.stop();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text('Loading Surah...', style: TextStyle(fontSize: 16)),
                ],
              ),
            )
          : Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 80),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/img/surah_background.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: ScrollablePositionedList.builder(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    itemCount: surah.ayahs.length,
                    itemScrollController: itemScrollController,
                    itemBuilder: (_, index) {
                      return AyahCard(
                        index: index,
                        ayah: surah.ayahs[index],
                        isPlaying: index == playingIndex,
                        onPlayPressed: (index) {
                          // save index and duration of the playlist
                          if (isPlaylist) {
                            playlistIndex = audioPlayer.currentIndex ?? 0;
                            playlistPosition = audioPlayer.position;
                          }

                          isPlaylist = false;
                          setState(() => playingIndex = index);
                        },
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 65,
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          (isPlaylist && isPlaying)
                              ? 'Playing Full Surah (v${surah.ayahs[playingIndex].numberInSurah})'
                              : 'Play Full Surah',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Tooltip(
                          message: 'Scroll to verse',
                          child: IconButton(
                            icon: Icon(Icons.my_location),
                            onPressed: () => scrollToVerse(playingIndex),
                          ),
                        ),
                        GestureDetector(
                          onTap: _togglePlayPause,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isPlaying && isPlaylist
                                  ? Colors.red.shade600
                                  : Colors.green.shade300,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              (isPlaying && isPlaylist)
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void scrollToVerse(int index) {
    itemScrollController.scrollTo(
      index: index,
      alignment: 0.5,
      // duration: const Duration(milliseconds: 1800),
      // curve: Curves.easeInOutCubic, simple

      // duration: Duration(seconds: 2),
      // curve: Curves.easeInOutExpo, simple

      // duration: Duration(milliseconds: 1500),
      // curve: Curves.easeInOutQuart, simple

      duration: Duration(seconds: 1),
      curve: Curves.easeOutBack,

      // duration: Duration(seconds: 2),
      // curve: Curves.elasticOut,

      // duration: Duration(milliseconds: 1500),
      // curve: Curves.easeInOutBack,
    );
  }
}
