import 'package:flutter/material.dart';
import 'package:hafiz_test/model/surah.model.dart';
import 'package:hafiz_test/quran/widgets/ayah_card.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class QuranAyahList extends StatelessWidget {
  final Surah surah;
  final ValueNotifier<int?> playingIndexNotifier;
  final ItemScrollController scrollController;
  final void Function(int index) onControlPressed;

  const QuranAyahList({
    super.key,
    required this.surah,
    required this.playingIndexNotifier,
    required this.scrollController,
    required this.onControlPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.separated(
      padding: const EdgeInsets.symmetric(vertical: 30),
      itemCount: surah.ayahs.length,
      itemScrollController: scrollController,
      itemBuilder: (_, index) {
        return AyahCard(
          index: index,
          ayah: surah.ayahs[index],
          playingIndexNotifier: playingIndexNotifier,
          onPlayPressed: (_) => onControlPressed(index),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 5),
    );
  }
}
