import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:hafiz_test/model/ayah.model.dart';
import 'package:hafiz_test/services/network.services.dart';
import 'package:hafiz_test/services/storage/abstract_storage_service.dart';

class AyahServices {
  final NetworkServices networkServices;
  final IStorageService storageServices;

  AyahServices({
    required this.networkServices,
    required this.storageServices,
  });

  Future<List<Ayah>> getSurahAyahs(int surahNumber) async {
    try {
      final reciter = storageServices.getReciter();
      final response = await networkServices.get('surah/$surahNumber/$reciter');

      if (response.data != null) {
        final ayahs = Ayah.fromJsonList(response.data['data']['ayahs']);
        return ayahs;
      }
    } catch (error) {
      if (kDebugMode) print('getSurahAyahs error: $error');
    }

    return [];
  }

  Future<Ayah> getRandomAyahFromJuz(int juzNumber) async {
    try {
      final response =
          await networkServices.get('juz/$juzNumber/quran-uthmani');

      if (response.data != null) {
        final ayahs = Ayah.fromJsonList(response.data['data']['ayahs']);
        return getRandomAyahForSurah(ayahs);
      }
    } catch (error) {
      if (kDebugMode) print('getRandomAyahFromJuz error: $error');
    }

    return Ayah();
  }

  Ayah getRandomAyahForSurah(List<Ayah> ayahs) {
    try {
      if (ayahs.isEmpty) return Ayah();

      final random = Random();
      final ayah = ayahs[random.nextInt(ayahs.length)];
      return ayah;
    } catch (error) {
      if (kDebugMode) print('getRandomAyahForSurah error: $error');
    }

    return Ayah();
  }
}
