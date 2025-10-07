import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  // Motivational messages for daily notifications
  static const List<String> _motivationalMessages = [
    '🌟 Every moment spent with the Quran is a moment of blessing. Continue your journey!',
    '⭐ The Prophet (PBUH) said: "Whoever recites a letter from the Book of Allah will have a reward."',
    '🕌 The Quran is a source of peace and guidance. Your memorization journey is blessed!',
    '🕊️ The Quran is healing for the heart and soul. Let today\'s session bring you peace!',
    '📚 Consistency is key in memorization. Your daily practice is building a strong foundation!',
    '📖 The Quran is the word of Allah. What a privilege to memorize His divine words!',
    '📚 The Quran is a companion for life. Each verse you memorize is a friend for eternity!',
    '⭐ Every verse you memorize is a step towards becoming a Hafiz. You\'re on a blessed path!',
    '🌙 The Prophet (PBUH) said: "The one who is proficient in the Quran will be with the noble angels."',
    '🌅 Begin your day with Allah\'s words. Your memorization journey is a blessed one!',
    '🕊️ Your dedication to memorizing the Quran is inspiring. Keep up the excellent work!',
    '💎 Your effort to memorize the Quran is a form of worship that brings you closer to Allah!',
    '✨ The Quran is a treasure, and you\'re collecting its gems. Today is another opportunity!',
    '🕌 Your effort to memorize the Quran is a form of Ibadah. May Allah reward you abundantly!',
    '🎯 Consistency in memorization leads to mastery. Your daily practice is building excellence!',
    '🌙 The Prophet (PBUH) said: "The best of you are those who learn the Quran and teach it."',
    '📖 Each day of practice is an investment in your spiritual growth. Keep going!',
    '⭐ Every verse you learn is a step closer to becoming a Hafiz. You\'re on the right path!',
    '🎯 Small consistent steps lead to great achievements. Keep memorizing, keep growing!',
    '📚 The Quran is a companion for life. Each verse you memorize is a friend for eternity!',
  ];

  /// Initialize the notification service
  static Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone
    tz.initializeTimeZones();

    // Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Combined initialization settings
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // Initialize the plugin
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
  }

  /// Handle notification tap
  static void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap if needed
  }

  /// Request notification permissions
  static Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      // Request notification permission
      final bool? granted =
          await androidImplementation?.requestNotificationsPermission();

      // Request exact alarm permission for Android 12+
      await androidImplementation?.requestExactAlarmsPermission();

      return granted ?? false;
    } else if (Platform.isIOS) {
      final bool? result = await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      return result ?? false;
    }
    return true;
  }

  /// Schedule daily motivational notifications with fallback for exact alarm restrictions
  static Future<void> scheduleDailyNotificationsWithFallback() async {
    if (!_initialized) {
      await initialize();
    }

    // Request permissions
    final bool hasPermission = await requestPermissions();
    if (!hasPermission) {
      return;
    }

    // Check if exact alarms are available
    final bool canScheduleExact = await canScheduleExactAlarms();

    // Get user's notification settings
    final settings = await getNotificationSettings();
    final int hour = settings['hour'] ?? 8;
    final int minute = settings['minute'] ?? 0;

    // Cancel existing notifications
    await cancelAllNotifications();

    // Schedule 30 daily notifications
    for (int i = 0; i < 30; i++) {
      final DateTime scheduledDate = DateTime.now().add(Duration(days: i));
      final tz.TZDateTime scheduledTZDateTime = tz.TZDateTime.from(
        DateTime(scheduledDate.year, scheduledDate.month, scheduledDate.day,
            hour, minute),
        tz.local,
      );

      final String message =
          _motivationalMessages[i % _motivationalMessages.length];

      await _notificationsPlugin.zonedSchedule(
        i,
        'Daily Motivation 🌟',
        message,
        scheduledTZDateTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_motivation',
            'Daily Motivation',
            channelDescription:
                'Daily motivational messages for Quran memorization',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            showWhen: true,
            enableVibration: true,
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: canScheduleExact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexact,
        payload: 'daily_motivation_$i',
      );
    }
  }

  /// Cancel all pending notifications
  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  /// Cancel a specific notification
  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  /// Send a test notification immediately
  static Future<void> sendTestNotification() async {
    if (!_initialized) {
      await initialize();
    }

    // Request permissions
    final bool hasPermission = await requestPermissions();
    if (!hasPermission) {
      return;
    }

    // Get a random motivational message
    final String message = _motivationalMessages[
        DateTime.now().millisecondsSinceEpoch % _motivationalMessages.length];

    await _notificationsPlugin.show(
      999, // Use ID 999 for test notifications
      'Test Notification 🔔',
      message,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_notification',
          'Test Notification',
          channelDescription: 'Test notifications for debugging',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          showWhen: true,
          enableVibration: true,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: 'test_notification',
    );
  }

  /// Save notification settings to SharedPreferences
  static Future<void> saveNotificationSettings({
    required bool enabled,
    required int hour,
    required int minute,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', enabled);
    await prefs.setInt('notification_hour', hour);
    await prefs.setInt('notification_minute', minute);
  }

  /// Get notification settings from SharedPreferences
  static Future<Map<String, dynamic>> getNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'enabled': prefs.getBool('notifications_enabled') ?? true,
      'hour': prefs.getInt('notification_hour') ?? 8,
      'minute': prefs.getInt('notification_minute') ?? 0,
    };
  }

  /// Reschedule notifications with new time
  static Future<void> rescheduleNotificationsWithNewTime({
    required bool enabled,
    required int hour,
    required int minute,
  }) async {
    // Save new settings
    await saveNotificationSettings(
        enabled: enabled, hour: hour, minute: minute);

    if (enabled) {
      // Cancel existing notifications and reschedule with new time
      await cancelAllNotifications();
      await scheduleDailyNotificationsWithFallback();
    } else {
      // Cancel all notifications if disabled
      await cancelAllNotifications();
    }
  }

  /// Check if exact alarms can be scheduled on Android
  static Future<bool> canScheduleExactAlarms() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      return await androidImplementation?.canScheduleExactNotifications() ??
          false;
    }
    return true; // iOS doesn't have this restriction
  }

  /// Check if notifications are enabled on the device
  static Future<bool> areNotificationsEnabled() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      return await androidImplementation?.areNotificationsEnabled() ?? false;
    }
    return true; // iOS doesn't have this restriction
  }
}
