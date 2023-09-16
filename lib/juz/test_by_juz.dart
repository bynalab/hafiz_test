import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hafiz_test/model/ayah.model.dart';
import 'package:hafiz_test/model/surah.model.dart';
import 'package:hafiz_test/services/ayah.services.dart';
import 'package:hafiz_test/services/surah.services.dart';
import 'package:hafiz_test/test_screen.dart';

class TestByJuz extends StatefulWidget {
  final int juzNumber;

  const TestByJuz({Key? key, required this.juzNumber}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TestPage();
}

class _TestPage extends State<TestByJuz> {
  bool isLoading = false;

  List<Ayah> ayahs = [];
  late Ayah ayah;

  bool autoplay = true;
  Surah surah = Surah();

  Future<void> init() async {
    setState(() => isLoading = true);

    final ayahFromJuz =
        await AyahServices().getRandomAyahFromJuz(widget.juzNumber);

    surah = await SurahServices().getSurah(ayahFromJuz.surah!.number);
    ayahs = surah.ayahs;

    ayah = ayahs.firstWhere((ayah) => ayah.number == ayahFromJuz.number);

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test By Juz'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            const Center(
              child: CircularProgressIndicator.adaptive(
                strokeWidth: 5,
                backgroundColor: Colors.blueGrey,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          else
            TestScreen(
              surah: surah,
              ayah: ayah,
              ayahs: ayahs,
              onRefresh: () async => await init(),
            ),
        ],
      ),
    );
  }
}
