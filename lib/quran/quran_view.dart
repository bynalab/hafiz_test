import 'package:flutter/material.dart';
import 'package:hafiz_test/locator.dart';
import 'package:hafiz_test/model/surah.model.dart';
import 'package:hafiz_test/quran/widgets/error.dart';
import 'package:hafiz_test/quran/quran_list.dart';
import 'package:hafiz_test/quran/quran_viewmodel.dart';
import 'package:hafiz_test/quran/surah_loader.dart';
import 'package:hafiz_test/services/audio_services.dart';
import 'package:hafiz_test/services/surah.services.dart';

class QuranView extends StatefulWidget {
  final Surah surah;

  const QuranView({super.key, required this.surah});

  @override
  State<QuranView> createState() => _QuranViewState();
}

class _QuranViewState extends State<QuranView> {
  final viewModel = QuranViewModel(
    audioService: getIt<AudioServices>(),
    surahService: getIt<SurahServices>(),
  );

  @override
  void initState() {
    super.initState();

    viewModel.initiateListeners();
    viewModel.initialize(widget.surah.number).then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    viewModel.dispose();

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
    if (viewModel.isLoading) {
      return Scaffold(body: SurahLoader());
    }

    if (viewModel.hasError) {
      return Scaffold(
        body: CustomErrorWidget(
          title: 'Failed to Load Surah',
          message:
              'Please check your internet connection or try again shortly.',
          icon: Icons.menu_book_rounded,
          color: Colors.green.shade700,
          onRetry: () async {
            setState(() {});
            await viewModel.initialize(widget.surah.number);
            setState(() {});
          },
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.green.shade500.withValues(alpha: 0.5),
        elevation: 0,
        foregroundColor: Colors.black,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.9),
                Colors.white.withValues(alpha: 0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        title: ValueListenableBuilder<int?>(
          valueListenable: viewModel.playingIndexNotifier,
          builder: (context, index, _) {
            final verseText = index != null
                ? ' - Verse ${viewModel.surah.ayahs[index].numberInSurah} of ${viewModel.surah.numberOfAyahs}'
                : '';
            return Text(
              '${viewModel.surah.englishName}$verseText',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
              ),
            );
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Stack(
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
                surah: viewModel.surah,
                playingIndexNotifier: viewModel.playingIndexNotifier,
                scrollController: viewModel.itemScrollController,
                onControlPressed: viewModel.onAyahControlPressed,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ValueListenableBuilder<bool>(
                valueListenable: viewModel.isPlayingNotifier,
                builder: (_, __, ___) {
                  return Container(
                    height: 80,
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(230),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          viewModel.isPlayingPlaylist
                              ? 'Playing Full Surah'
                              : 'Play Full Surah',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GestureDetector(
                          onTap: viewModel.togglePlayPause,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: viewModel.isPlayingPlaylist
                                  ? Colors.red.shade600
                                  : Colors.green.shade300,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(13),
                                  blurRadius: 4,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              viewModel.isPlayingPlaylist
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                              size: 25,
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
      ),
    );
  }
}
