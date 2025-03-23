import 'dart:convert';

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
}
