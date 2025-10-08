// ignore_for_file: avoid_print

import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:hafiz_test/config/analytics_config.dart';

class AnalyticsService {
  static const String _projectToken = AnalyticsConfig.mixpanelProjectToken;
  static Mixpanel? _mixpanel;
  static bool _isInitialized = false;

  /// Initialize Mixpanel with the project token
  static Future<void> initialize() async {
    if (_isInitialized || !AnalyticsConfig.enableAnalytics) return;

    try {
      if (AnalyticsConfig.debugMode) {
        print(
            'Initializing Mixpanel with token: ${_projectToken.substring(0, 8)}...');
      }

      _mixpanel =
          await Mixpanel.init(_projectToken, trackAutomaticEvents: true);
      _isInitialized = true;

      if (AnalyticsConfig.debugMode) {
        print('✅ Mixpanel initialized successfully');
        print('Project token: ${_projectToken.substring(0, 8)}...');
      }
    } catch (e) {
      print('❌ Failed to initialize Mixpanel: $e');
    }
  }

  /// Track an event with optional properties
  static void trackEvent(String eventName, {Map<String, dynamic>? properties}) {
    if (!AnalyticsConfig.enableAnalytics ||
        !_isInitialized ||
        _mixpanel == null) {
      if (AnalyticsConfig.debugMode) {
        print(
            'Mixpanel not initialized or disabled. Cannot track event: $eventName');
      }
      return;
    }

    try {
      _mixpanel!.track(eventName, properties: properties);

      if (AnalyticsConfig.debugMode) {
        print('Tracked event: $eventName with properties: $properties');
        _mixpanel!.flush();
      }
    } catch (e) {
      print('Failed to track event $eventName: $e');
    }
  }

  /// Identify a user with a unique ID
  static void identifyUser(String userId) {
    if (!AnalyticsConfig.enableAnalytics ||
        !_isInitialized ||
        _mixpanel == null) {
      if (AnalyticsConfig.debugMode) {
        print('Mixpanel not initialized or disabled. Cannot identify user');
      }
      return;
    }

    try {
      _mixpanel!.identify(userId);

      if (AnalyticsConfig.debugMode) {
        print('User identified: $userId');
      }
    } catch (e) {
      print('Failed to identify user: $e');
    }
  }

  /// Track app-specific events
  static void trackAppLaunch() {
    trackEvent('App Launched', properties: {
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  static void trackSurahSelected(String surahName, int surahNumber) {
    trackEvent('Surah Selected', properties: {
      'surah_name': surahName,
      'surah_number': surahNumber,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  static void trackJuzSelected(int juzNumber) {
    trackEvent('Juz Selected', properties: {
      'juz_number': juzNumber,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  static void trackAudioPlayed(String audioType, String audioName) {
    trackEvent('Audio Played', properties: {
      'audio_type': audioType,
      'audio_name': audioName,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  static void trackAudioPaused(String audioType, String audioName) {
    trackEvent('Audio Paused', properties: {
      'audio_type': audioType,
      'audio_name': audioName,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  static void trackTestStarted(
      String testType, Map<String, dynamic> testDetails) {
    trackEvent('Test Started', properties: {
      'test_type': testType,
      ...testDetails,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  static void trackTestCompleted(
      String testType, Map<String, dynamic> testResults) {
    trackEvent('Test Completed', properties: {
      'test_type': testType,
      ...testResults,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  static void trackSettingsChanged(
      String settingName, dynamic oldValue, dynamic newValue) {
    trackEvent('Settings Changed', properties: {
      'setting_name': settingName,
      'old_value': oldValue.toString(),
      'new_value': newValue.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  static void trackScreenView(String screenName) {
    trackEvent('Screen View', properties: {
      'screen_name': screenName,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
}
