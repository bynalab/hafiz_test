import 'dart:convert';

import 'package:hafiz_test/model/ayah.model.dart';
import 'package:hafiz_test/model/surah.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageServices {
  static StorageServices? _instance;
  static StorageServices get getInstance {
    return _instance = _instance ?? StorageServices();
  }

  Future<bool> checkAutoPlay() async {
    final settings = await SharedPreferences.getInstance();

    return settings.getBool('autoplay') ?? true;
  }

  Future<bool> setAutoPlay(bool autoPlay) async {
    final settings = await SharedPreferences.getInstance();
    return settings.setBool('autoplay', autoPlay);
  }

  Future<bool> saveLastRead(Surah surah, Ayah ayah) async {
    final settings = await SharedPreferences.getInstance();

    return settings.setString(
      'last_read',
      jsonEncode({'surah': surah, 'ayah': ayah}),
    );
  }

  Future<(Surah, Ayah)> getLastRead() async {
    final settings = await SharedPreferences.getInstance();

    final decoded = jsonDecode(settings.getString('last_read') ?? '{}');

    return (
      Surah.fromJson(decoded['surah']),
      Ayah.fromJson(decoded['ayah']),
    );
  }
}
