import 'package:flutter/material.dart';
import 'package:hafiz_test/extension/quran_extension.dart';
import 'package:hafiz_test/model/surah.model.dart';
import 'package:hafiz_test/quran/error.dart';
import 'package:hafiz_test/quran/quran_list.dart';
import 'package:hafiz_test/quran/surah_loader.dart';
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
  final itemScrollController = ItemScrollController();

  AudioPlayer get audioPlayer => audioService.audioPlayer;

  bool isLoading = true;
  bool hasError = false;

  final playingIndexNotifier = ValueNotifier<int?>(null);
  final isPlayingNotifier = ValueNotifier<bool>(false);

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
      isPlayingNotifier.value = state.playing;

      if (state.processingState == ProcessingState.completed) {
        isPlayingNotifier.value = false;
      }
    });

    audioPlayer.currentIndexStream.listen((index) {
      if (index != null && isPlaylist) {
        playingIndexNotifier.value = index;
      }
    });
  }

  Future<void> init() async {
    try {
      setState(() => isLoading = true);

      surah = await SurahServices().getSurah(widget.surah.number);

      await audioService.setPlaylistAudio(surah.audioSources);

      hasError = false;
    } catch (e) {
      debugPrint('Error: $e');
      setState(() => hasError = true);
    } finally {
      setState(() => isLoading = false);
    }
  }

  bool isPlaylist = false;
  Future<void> _togglePlayPause() async {
    if (!isPlaylist) {
      await _initializePlaylist();
      return;
    }

    await _togglePlayback();
  }

  Future<void> _initializePlaylist() async {
    isPlaylist = true;
    playingIndexNotifier.value = playlistIndex;

    await audioService.setPlaylistAudio(surah.audioSources);
    await audioService.audioPlayer.seek(playlistPosition, index: playlistIndex);
    await audioService.play();
  }

  Future<void> _togglePlayback() async {
    if (isPlayingNotifier.value) {
      await audioService.pause();
    } else {
      await audioService.play();
    }
  }

  void scrollToVerse(int? index) {
    if (index == null) return;

    itemScrollController.scrollTo(
      index: index,
      alignment: 0.5,
      duration: Duration(milliseconds: 1500),
      curve: Curves.easeInOutQuart,
    );
  }

  void savePlaylistState() {
    playlistIndex = audioPlayer.currentIndex ?? 0;
    playlistPosition = audioPlayer.position;
  }

  void playSingleAyah(int index) {
    isPlaylist = false;
    playingIndexNotifier.value = index;
    audioService.setAudioSource(surah.ayahs[index].audioSource);

    _togglePlayback();
  }

  void onAyahControlPressed(int index) {
    if (isPlaylist) {
      savePlaylistState();
    }

    playSingleAyah(index);
  }

  @override
  void dispose() {
    audioService.dispose();

    super.dispose();
  }

  bool get isPlayingPlaylist => isPlaylist && isPlayingNotifier.value;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(body: SurahLoader());
    }

    if (hasError) {
      return Scaffold(
        body: CustomErrorWidget(
          title: 'Failed to Load Surah',
          message:
              'Please check your internet connection or try again shortly.',
          icon: Icons.menu_book_rounded,
          color: Colors.green.shade700,
          onRetry: init,
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 80),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/surah_background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: QuranAyahList(
              surah: surah,
              playingIndexNotifier: playingIndexNotifier,
              scrollController: itemScrollController,
              onControlPressed: onAyahControlPressed,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ValueListenableBuilder<bool>(
              valueListenable: isPlayingNotifier,
              builder: (_, __, ___) {
                return Container(
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
                        isPlayingPlaylist
                            ? 'Playing Full Surah (v${surah.ayahs[playingIndexNotifier.value ?? 0].numberInSurah})'
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
                          onPressed: () {
                            scrollToVerse(playingIndexNotifier.value);
                          },
                        ),
                      ),
                      GestureDetector(
                        onTap: _togglePlayPause,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isPlayingPlaylist
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
                            isPlayingPlaylist ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
