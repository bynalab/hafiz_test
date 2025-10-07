import 'package:flutter/material.dart';
import 'package:hafiz_test/locator.dart';
import 'package:hafiz_test/splash_screen.dart';
import 'package:hafiz_test/util/app_theme.dart';
import 'package:hafiz_test/util/theme_controller.dart';
import 'package:hafiz_test/services/rating_service.dart';
import 'package:just_audio_background/just_audio_background.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  await setupLocator();

  // Initialize rating service
  await RatingService.initializeAppLaunch();

  runApp(const QuranHafiz());
}

class QuranHafiz extends StatefulWidget {
  const QuranHafiz({super.key});

  @override
  State<QuranHafiz> createState() => _QuranHafizState();
}

class _QuranHafizState extends State<QuranHafiz> {
  late final ThemeController _themeController;

  @override
  void initState() {
    super.initState();
    _themeController = getIt<ThemeController>();
    _themeController.addListener(_onThemeChanged);
  }

  void _onThemeChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _themeController.removeListener(_onThemeChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.values.byName(_themeController.mode),
      home: const SplashScreen(),
    );
  }
}
