import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hafiz_test/model/ayah.model.dart';
import 'package:hafiz_test/model/surah.model.dart';
import 'package:hafiz_test/services/ayah.services.dart';
import 'package:hafiz_test/services/surah.services.dart';
import 'package:hafiz_test/test_screen.dart';

class TestBySurah extends StatefulWidget {
  final int surahNumber;

  const TestBySurah({Key? key, required this.surahNumber}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TestPage();
}

class _TestPage extends State<TestBySurah> {
  final surahServices = SurahServices();
  final ayahServices = AyahServices();

  bool isLoading = false;
  bool isPlaying = false;

  List<Ayah> ayahs = [];
  late Ayah ayah;

  int surahNumber = 1;
  bool get isRandomSurah => widget.surahNumber == 0;

  @override
  void initState() {
    super.initState();

    init();
  }

  bool autoplay = true;
  Surah surah = Surah();

  Future<void> init() async {
    setState(() => isLoading = true);

    surahNumber = widget.surahNumber;

    if (isRandomSurah) {
      surahNumber = surahServices.getRandomSurahNumber();
    }

    if (isRandomSurah || ayahs.isEmpty) {
      surah = await surahServices.getSurah(surahNumber);
    }

    ayahs = surah.ayahs;
    ayah = ayahServices.getRandomAyahForSurah(ayahs);

    setState(() => isLoading = false);
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
