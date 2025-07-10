import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hafiz_test/model/ayah.model.dart';
import 'package:hafiz_test/model/surah.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageServices {
  static StorageServices? _instance;
  static StorageServices get getInstance {
    return _instance = _instance ?? StorageServices();
  }

  late final _sharedPreferences = SharedPreferences.getInstance();

  Future<SharedPreferences> get sharedPreferences async {
    return await _sharedPreferences;
  }

  Future<bool> checkAutoPlay() async {
    return (await sharedPreferences).getBool('autoplay') ?? true;
  }

  Future<bool> setAutoPlay(bool autoPlay) async {
    return (await sharedPreferences).setBool('autoplay', autoPlay);
  }

  Future<bool> setReciter(String identifier) async {
    return (await sharedPreferences).setString('reciter', identifier);
  }

  Future<String?> getReciter() async {
    return (await sharedPreferences).getString('reciter') ?? 'ar.alafasy';
  }

  Future<bool> saveLastRead(Surah surah, Ayah ayah) async {
    return (await sharedPreferences).setString(
      'last_read',
      jsonEncode({'surah': surah, 'ayah': ayah}),
    );
  }

  Future<(Surah, Ayah)> getLastRead() async {
    final decoded = jsonDecode(
      (await sharedPreferences).getString('last_read') ?? '{}',
    );

    return (
      Surah.fromJson(decoded['surah']),
      Ayah.fromJson(decoded['ayah']),
    );
  }

  /// Checks if the user has already viewed the guide identified by the storage key.
  Future<bool> hasViewedShowcase() async {
    try {
      final value = (await sharedPreferences).getBool('has_view_showcase');

      return value ?? false;
    } catch (e) {
      debugPrint('Error checking if user guide was viewed: $e');
      return false;
    }
  }

  /// Saves the state of a user guide as viewed in persistent storage.
  Future<void> saveUserGuide() async {
    try {
      (await sharedPreferences).setBool('has_view_showcase', true);
    } catch (e) {
      debugPrint('Error saving user guide state: $e');
    }
  }
}
