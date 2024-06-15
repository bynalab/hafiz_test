import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hafiz_test/model/surah.model.dart';
import 'package:intl/intl.dart' hide TextDirection;

class SurahScreen extends StatefulWidget {
  final Surah surah;

  const SurahScreen({Key? key, required this.surah}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Surah();
}

class _Surah extends State<SurahScreen> {
  bool isLoading = false;
  bool isPlaying = false;

  Surah surah = Surah();

  void getSurah() {
    setState(() => isLoading = true);

    surah = widget.surah;

    setState(() => isLoading = false);
  }

  final audioPlayer = AudioPlayer();

  Future<void> playAudio(String url) async {
    try {
      await audioPlayer.play(UrlSource(url));

      setState(() => isPlaying = true);
    } catch (e) {
      setState(() => isPlaying = false);
    }
  }

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    getSurah();

    audioPlayer.onPlayerComplete.listen((_) async {
      setState(() {
        isPlaying = false;
      });
    });
  }

  String makeAyahNumber(int ayahNumber) {
    final formatedAyahNumber = NumberFormat('#', 'ar_EG').format(ayahNumber);
    final runes = Runes('   \u{fd3f}$formatedAyahNumber\u{fd3e}');

    return String.fromCharCodes(runes);
  }

  @override
  void dispose() {
    audioPlayer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
              '${surah.englishName}: ${surah.englishNameTranslation}',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF222222),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        padding: const EdgeInsets.only(top: 20),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/surah_background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (isLoading)
                const CircularProgressIndicator(
                  strokeWidth: 5,
                  backgroundColor: Colors.blueGrey,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              else
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          Text(
                            surah.name,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Color(0xFF000000),
                              fontFamily: 'Kitab',
                            ),
                          ),
                          Text(
                            '${surah.number}. ${surah.englishName}: ${surah.englishNameTranslation}',
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF222222),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Color(0xFF222222),
                      thickness: 0.09,
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: surah.ayahs.length,
                      itemBuilder: (context, index) {
                        final ayah = surah.ayahs[index];

                        return InkWell(
                          child: Container(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 20,
                              bottom: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (index == selectedIndex)
                                  if (isPlaying)
                                    const Icon(
                                      Icons.volume_up_rounded,
                                      color: Colors.blueGrey,
                                    ),
                                Expanded(
                                  child: Text.rich(
                                    textDirection: TextDirection.rtl,
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: ayah.text,
                                          style: const TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 20,
                                            fontFamily: 'Kitab',
                                          ),
                                        ),
                                        TextSpan(
                                          text: makeAyahNumber(
                                            ayah.numberInSurah,
                                          ),
                                          style: const TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Quran',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onLongPress: () async {
                            setState(() => selectedIndex = index);

                            await playAudio(ayah.audio);
                          },
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider(
                          color: Color(0xFF222222),
                          thickness: 0.09,
                        );
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
