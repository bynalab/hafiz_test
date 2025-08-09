import 'package:flutter/material.dart';
import 'package:hafiz_test/extension/quran_extension.dart';
import 'package:hafiz_test/model/memory.model.dart';
import 'package:hafiz_test/model/surah.model.dart';
import 'package:hafiz_test/services/audio_services.dart';
import 'package:hafiz_test/services/surah.services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class QuranViewModel {
  final AudioServices audioService;
  final SurahServices surahService;

  final itemScrollController = ItemScrollController();

  QuranViewModel({required this.audioService, required this.surahService});

  late Surah surah;
  bool isLoading = true;
  bool hasError = false;
  bool isPlaylist = false;

  PlaylistMemory playlistMemory = PlaylistMemory();

  final playingIndexNotifier = ValueNotifier<int?>(null);
  final isPlayingNotifier = ValueNotifier<bool>(false);

  AudioPlayer get audioPlayer => audioService.audioPlayer;

  Future<void> initialize(int surahNumber) async {
    try {
      isLoading = true;
      surah = await surahService.getSurah(surahNumber);
      await audioService.setPlaylistAudio(surah.audioSources);
      hasError = false;
    } catch (e) {
      debugPrint('Error loading surah: $e');
      hasError = true;
    } finally {
      isLoading = false;
    }
  }

  void initiateListeners() {
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

  Future<void> _togglePlayback() async {
    if (isPlayingNotifier.value) {
      await audioService.pause();
    } else {
      await audioService.play();
    }
  }

  Future<void> togglePlayPause() async {
    if (!isPlaylist) {
      await _initializePlaylist();

      return;
    }

    _togglePlayback();
  }

  Future<void> _initializePlaylist() async {
    isPlaylist = true;
    playingIndexNotifier.value = playlistMemory.index;

    await audioService.setPlaylistAudio(surah.audioSources);
    await audioPlayer.seek(
      playlistMemory.position,
      index: playlistMemory.index,
    );

    await audioService.play();
  }

  void scrollToVerse(int? index) {
    if (index == null) return;

    itemScrollController.scrollTo(
      index: index,
      alignment: 0.5,
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeInOutQuart,
    );
  }

  void savePlaylistState() {
    playlistMemory = PlaylistMemory(
      index: audioPlayer.currentIndex,
      position: audioPlayer.position,
    );
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

  void dispose() {
    audioService.dispose();
  }

  bool get isPlayingPlaylist => isPlaylist && isPlayingNotifier.value;
}
