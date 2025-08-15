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

class TestBySurah extends StatefulWidget {
  final int? surahNumber;
  final int? ayahNumber;

  const TestBySurah({super.key, this.surahNumber, this.ayahNumber});

  @override
  State<StatefulWidget> createState() => _TestPage();
}

class _TestPage extends State<TestBySurah> {
  final surahServices = getIt<SurahServices>();

  bool isLoading = false;

  late int surahNumber;
  late Ayah currentAyah;

  @override
  void initState() {
    super.initState();

    init();
  }

  Surah surah = Surah();

  Future<void> init() async {
    setState(() => isLoading = true);

    if (widget.surahNumber == null) {
      surahNumber = surahServices.getRandomSurahNumber();
    } else {
      surahNumber = widget.surahNumber!;
    }

    if (surah.ayahs.isEmpty) {
      // Avoid refetching surah if it's ayahs are already loaded
      surah = await surahServices.getSurah(surahNumber);
    }

    currentAyah = _getAyahForSurah();

    await getIt<AudioServices>().setAudioSource(currentAyah.audioSource);

    setState(() => isLoading = false);
  }

  Ayah _getAyahForSurah() {
    return widget.ayahNumber != null
        ? surah.getAyah(widget.ayahNumber)
        : getIt<AyahServices>().getRandomAyahForSurah(surah.ayahs);
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
                currentAyah: currentAyah,
                isLoading: isLoading,
                onRefresh: () async => await init(),
              ),
            ),
        ],
      ),
    );
  }
}
