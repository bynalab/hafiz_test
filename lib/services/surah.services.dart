import 'dart:convert';

import 'package:hafiz_test/model/surah.model.dart';
import 'package:hafiz_test/services/network.services.dart';
import 'package:hafiz_test/services/storage.services.dart';
import 'package:hafiz_test/util/surah_picker.dart';

class SurahServices {
  final _networkServices = NetworkServices();
  final surahPicker = SurahPicker();

  int getRandomSurahNumber() {
    final surahNumber = surahPicker.getNextSurah();

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
