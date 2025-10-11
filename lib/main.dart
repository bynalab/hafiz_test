import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hafiz_test/locator.dart';
import 'package:hafiz_test/splash_screen.dart';
import 'package:hafiz_test/util/app_theme.dart';
import 'package:hafiz_test/util/theme_controller.dart';
import 'package:hafiz_test/services/rating_service.dart';
import 'package:hafiz_test/services/analytics_service.dart';
import 'package:hafiz_test/services/user_identification_service.dart';
import 'package:just_audio_background/just_audio_background.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  await setupLocator();

  try {
    // Initialize analytics
    await AnalyticsService.initialize();

    // Initialize user identification
    await UserIdentificationService.initializeUserIdentification();

    // Initialize rating service
    await RatingService.initializeAppLaunch();

    // Track app launch
    AnalyticsService.trackAppLaunch();
  } catch (e) {
    if (kDebugMode) {
      print('Error initializing services: $e');
    }
  }

  runApp(const QuranHafiz());
}

class QuranHafiz extends StatefulWidget {
  const QuranHafiz({super.key});

  @override
  State<QuranHafiz> createState() => _QuranHafizState();
}

class _QuranHafizState extends State<QuranHafiz> with WidgetsBindingObserver {
  late final ThemeController _themeController;

  @override
  void initState() {
    super.initState();
    _themeController = getIt<ThemeController>();
    _themeController.addListener(_onThemeChanged);
    WidgetsBinding.instance.addObserver(this);
  }

  void _onThemeChanged() {
    if (mounted) setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Track app lifecycle changes
    switch (state) {
      case AppLifecycleState.resumed:
        AnalyticsService.trackAppLifecycle('resumed');
        break;
      case AppLifecycleState.paused:
        AnalyticsService.trackAppLifecycle('paused');
        AnalyticsService.trackSessionEnd();
        break;
      case AppLifecycleState.inactive:
        AnalyticsService.trackAppLifecycle('inactive');
        break;
      case AppLifecycleState.detached:
        AnalyticsService.trackAppLifecycle('detached');
        AnalyticsService.trackSessionEnd();
        break;
      case AppLifecycleState.hidden:
        AnalyticsService.trackAppLifecycle('hidden');
        break;
    }
  }

  @override
  void dispose() {
    _themeController.removeListener(_onThemeChanged);
    WidgetsBinding.instance.removeObserver(this);
    AnalyticsService.trackSessionEnd();
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
