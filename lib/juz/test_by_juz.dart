import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hafiz_test/extension/quran_extension.dart';
import 'package:hafiz_test/locator.dart';
import 'package:hafiz_test/model/ayah.model.dart';
import 'package:hafiz_test/model/surah.model.dart';
import 'package:hafiz_test/services/audio_services.dart';
import 'package:hafiz_test/services/ayah.services.dart';
import 'package:hafiz_test/services/surah.services.dart';
import 'package:hafiz_test/test_screen.dart';

class TestByJuz extends StatefulWidget {
  final int juzNumber;

  const TestByJuz({super.key, required this.juzNumber});

  @override
  State<StatefulWidget> createState() => _TestPage();
}

class _TestPage extends State<TestByJuz> {
  final audioServices = AudioServices();

  bool isLoading = false;

  List<Ayah> ayahs = [];
  late Ayah ayah;

  bool autoplay = true;
  Surah surah = Surah();

  Future<void> init() async {
    setState(() => isLoading = true);

    final ayahFromJuz =
        await getIt<AyahServices>().getRandomAyahFromJuz(widget.juzNumber);

    surah =
        await getIt<SurahServices>().getSurah(ayahFromJuz.surah?.number ?? 0);
    ayahs = surah.ayahs;

    ayah = ayahs.firstWhere((ayah) => ayah.number == ayahFromJuz.number);

    await audioServices.setAudioSource(ayah.audioSource);

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: const Color(0xFF004B40),
        scrolledUnderElevation: 10,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: SvgPicture.asset('assets/img/arrow_back.svg'),
            ),
            const SizedBox(width: 13),
            Text(
              surah.englishName,
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF222222),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
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
            SingleChildScrollView(
              child: TestScreen(
                surah: surah,
                ayah: ayah,
                ayahs: ayahs,
                onRefresh: () async => await init(),
              ),
            ),
        ],
      ),
    );
  }
}
