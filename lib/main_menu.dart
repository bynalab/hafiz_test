import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hafiz_test/services/storage.services.dart';
import 'package:hafiz_test/widget/last_read_card.dart';
import 'package:hafiz_test/widget/showcase.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:hafiz_test/juz/juz_list_screen.dart';
import 'package:hafiz_test/settings_dialog.dart';
import 'package:hafiz_test/surah/surah_list_screen.dart';
import 'package:hafiz_test/surah/test_by_surah.dart';
import 'package:hafiz_test/widget/test_menu_card.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: (_) => _MainMenu(key: key),
      onFinish: StorageServices.getInstance.saveUserGuide,
    );
  }
}

class _MainMenu extends StatefulWidget {
  const _MainMenu({super.key});

  @override
  State<StatefulWidget> createState() => _MainMenuState();
}

class _MainMenuState extends State<_MainMenu> {
  final _settingKey = GlobalKey();
  final _lastReadKey = GlobalKey();
  final _quranCardKey = GlobalKey();
  final _surahCardKey = GlobalKey();
  final _juzCardKey = GlobalKey();
  final _randomCardKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => startShowcase());
  }

  void startShowcase() {
    StorageServices.getInstance.hasViewedUserGuide().then((value) {
      if (!mounted || value) return;

      ShowCaseWidget.of(context).startShowCase([
        _settingKey,
        _lastReadKey,
        _quranCardKey,
        _surahCardKey,
        _juzCardKey,
        _randomCardKey,
      ]);
    });
  }

  Future<void> navigateTo(Widget screen) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: onMainMenuPopInvoked,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: SvgPicture.asset('assets/img/logo.svg'),
          actions: [
            ShowCase(
              widgetKey: _settingKey,
              title: 'Settings',
              description:
                  'Change autoplay settings and select your favorite reciter',
              child: IconButton(
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
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LastReadCard(lastReadKey: _lastReadKey),
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
                    child: ShowCase(
                      widgetKey: _quranCardKey,
                      title: 'By Quran',
                      description:
                          'Begin your journey with a randomly chosen verse from the Holy Quran.',
                      child: TestMenuCard(
                        title: 'Quran',
                        image: 'card_quran',
                        color: const Color(0xFF2BFF00),
                        onTap: () =>
                            navigateTo(const TestBySurah(surahNumber: 0)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 17),
                  Expanded(
                    child: ShowCase(
                      widgetKey: _surahCardKey,
                      title: 'By Surah',
                      description:
                          'Begin your test journey by selecting a specific Surah.',
                      child: TestMenuCard(
                        title: 'Surah',
                        image: 'card_surah',
                        color: const Color(0xFFFF8E6F),
                        onTap: () => navigateTo(const SurahListScreen()),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 17),
              Row(
                children: [
                  Expanded(
                    child: ShowCase(
                      widgetKey: _juzCardKey,
                      title: 'By Juz',
                      description:
                          'Begin your test journey by selecting a specific Juz of the Quran.',
                      child: TestMenuCard(
                        title: 'Juz',
                        image: 'card_juz',
                        color: const Color(0xFFFBBE15),
                        onTap: () => navigateTo(const JuzListScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 17),
                  Expanded(
                    child: ShowCase(
                      widgetKey: _randomCardKey,
                      title: 'Random Test',
                      description:
                          'Challenge yourself with verses selected at random from across the Holy Quran.',
                      child: TestMenuCard(
                        title: 'Random',
                        image: 'card_random',
                        color: const Color(0xFF6E81F6),
                        onTap: () =>
                            navigateTo(const TestBySurah(surahNumber: 0)),
                      ),
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

  Future<void> onMainMenuPopInvoked(bool didPop, Object? result) async {
    if (didPop) return;

    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to exit?'),
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

    if (shouldExit == true) {
      SystemNavigator.pop();
    }
  }
}
