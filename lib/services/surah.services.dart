import 'dart:convert';
import 'dart:math';

import 'package:hafiz_test/model/surah.model.dart';
import 'package:hafiz_test/services/network.services.dart';
import 'package:hafiz_test/services/storage.services.dart';

class SurahServices {
  final _networkServices = NetworkServices();

  int getRandomSurahNumber() {
    final surahNumber = 1 + Random().nextInt(114 - 1);

    return surahNumber;
  }

  Future<Surah> getSurah(int surahNumber) async {
    try {
      final reciter = await StorageServices.getInstance.getReciter();

      final response =
          await _networkServices.get('surah/$surahNumber/$reciter');

      final body = json.decode(response.body);

      final surah = Surah.fromJson(body['data']);

      return surah;
    } catch (e) {
      return Surah();
    }
  }
}
