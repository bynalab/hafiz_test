import 'package:flutter/foundation.dart';
import 'package:hafiz_test/services/analytics_service.dart';
import 'package:hafiz_test/services/storage/abstract_storage_service.dart';
import 'package:hafiz_test/locator.dart';
import 'package:uuid/uuid.dart';

class UserIdentificationService {
  static const String _userIdKey = 'user_id';

  static final IStorageService _storage = getIt<IStorageService>();

  /// Initialize user identification on app launch
  static Future<void> initializeUserIdentification() async {
    try {
      // Check if user is already identified
      final userId = _storage.getString(_userIdKey);

      if (userId != null) {
        // User is already identified, re-identify them
        AnalyticsService.identifyUser(userId);
      } else {
        // Create anonymous user
        await _createAnonymousUser();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing user identification: $e');
      }

      // Fallback to anonymous user
      await _createAnonymousUser();
    }
  }

  /// Create an anonymous user
  static Future<void> _createAnonymousUser() async {
    final anonymousId = generateAnonymousId();

    // Store the anonymous ID
    _storage.setString(_userIdKey, anonymousId);

    // Identify with Mixpanel
    AnalyticsService.identifyUser(anonymousId);
  }

  /// Generate a unique anonymous ID for the device
  static String generateAnonymousId() {
    // Generate a cryptographically secure UUID
    return 'quran_hafiz_anonymous_${Uuid().v4()}';
  }
}
