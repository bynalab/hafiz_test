import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hafiz_test/juz/juz_list_screen.dart';
import 'package:hafiz_test/services/storage.services.dart';
import 'package:hafiz_test/settings_dialog.dart';
import 'package:hafiz_test/surah/surah_list_screen.dart';
import 'package:hafiz_test/surah/test_by_surah.dart';
import 'package:hafiz_test/widget/test_menu_card.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<StatefulWidget> createState() => _MainMenu();
}

class _MainMenu extends State<MainMenu> {
  Future<void> navigateTo(Widget screen) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => screen));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: SvgPicture.asset('assets/img/logo.svg'),
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (_) {
                    return const SettingDialog();
                  },
                );
              },
              icon: SvgPicture.asset('assets/img/settings.svg'),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(23),
                    child: Image.asset('assets/img/banner.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(23),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Last Read',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF222222),
                              ),
                            ),
                            const SizedBox(height: 21),
                            FutureBuilder(
                              future: StorageServices.getInstance.getLastRead(),
                              builder: (_, snapshot) {
                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator();
                                }

                                final (surah, ayah) = snapshot.data!;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      surah.name.replaceAll('سُورَةُ ', ''),
                                      style: const TextStyle(
                                        fontFamily: 'Kitab',
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF222222),
                                      ),
                                    ),
                                    Text(
                                      'Ayah no. ${ayah.numberInSurah}',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                        color: const Color(0xFF222222),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 26),
                            Container(
                              width: 115,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 11,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFAF6EB),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Continue',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF004B40),
                                    ),
                                  ),
                                  Image.asset(
                                    'assets/img/arrow_right_circle.png',
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Image.asset(
                          'assets/img/quran_opened_star.png',
                          height: 120,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 34),
              Text(
                'Test',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF222222),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TestMenuCard(
                      title: 'Quran',
                      image: 'card_quran',
                      color: const Color(0xFF2BFF00),
                      onTap: () async {
                        navigateTo(const TestBySurah(surahNumber: 0));
                      },
                    ),
                  ),
                  const SizedBox(width: 17),
                  Expanded(
                    child: TestMenuCard(
                      title: 'Surah',
                      image: 'card_surah',
                      color: const Color(0xFFFF8E6F),
                      onTap: () => navigateTo(const SurahListScreen()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 17),
              Row(
                children: [
                  Expanded(
                    child: TestMenuCard(
                      title: 'Juz',
                      image: 'card_juz',
                      color: const Color(0xFFFBBE15),
                      onTap: () => navigateTo(const JuzListScreen()),
                    ),
                  ),
                  const SizedBox(width: 17),
                  Expanded(
                    child: TestMenuCard(
                      title: 'Random',
                      image: 'card_random',
                      color: const Color(0xFF6E81F6),
                      onTap: () => navigateTo(const JuzListScreen()),
                    ),
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
