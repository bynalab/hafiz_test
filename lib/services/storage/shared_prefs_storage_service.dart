import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hafiz_test/model/ayah.model.dart';
import 'package:hafiz_test/model/surah.model.dart';
import 'abstract_storage_service.dart';

class SharedPrefsStorageService implements IStorageService {
  final SharedPreferences prefs;

  SharedPrefsStorageService(this.prefs);

  @override
  bool checkAutoPlay() {
    return prefs.getBool('autoplay') ?? true;
  }

  @override
  Future<bool> setAutoPlay(bool autoPlay) async {
    return prefs.setBool('autoplay', autoPlay);
  }

  @override
  Future<bool> setReciter(String identifier) async {
    return prefs.setString('reciter', identifier);
  }

  @override
  String getReciter() {
    return prefs.getString('reciter') ?? 'ar.alafasy';
  }

  @override
  Future<bool> saveLastRead(Surah surah, Ayah ayah) async {
    try {
      return prefs.setString(
        'last_read',
        jsonEncode({'surah': surah.toJson(), 'ayah': ayah.toJson()}),
      );
    } catch (e) {
      return false;
    }
  }

  @override
  (Surah, Ayah)? getLastRead() {
    final raw = prefs.getString('last_read');
    if (raw == null) return null;

    try {
      final decoded = jsonDecode(raw);
      return (
        Surah.fromJson(decoded['surah']),
        Ayah.fromJson(decoded['ayah']),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  bool hasViewedShowcase() {
    return prefs.getBool('has_view_showcase') ?? false;
  }

  @override
  Future<void> saveUserGuide() async {
    await prefs.setBool('has_view_showcase', true);
  }

  @override
  Future<bool> setThemeMode(String mode) async {
    final serialized =
        ['light', 'dark', 'system'].contains(mode) ? mode : 'system';

    return prefs.setString('theme_mode', serialized);
  }

  @override
  String getThemeMode() {
    final raw = prefs.getString('theme_mode');
    return ['light', 'dark', 'system'].contains(raw)
        ? raw ?? 'system'
        : 'system';
  }
}
