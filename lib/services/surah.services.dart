import 'dart:convert';

import 'package:hafiz_test/model/surah.model.dart';
import 'package:hafiz_test/services/network.services.dart';
import 'package:hafiz_test/services/storage/abstract_storage_service.dart';
import 'package:hafiz_test/util/surah_picker.dart';

class SurahServices {
  final NetworkServices networkServices;
  final IStorageService storageServices;
  final SurahPicker surahPicker;

  SurahServices({
    required this.networkServices,
    required this.storageServices,
    required this.surahPicker,
  });

  int getRandomSurahNumber() {
    return surahPicker.getNextSurah();
  }

  Future<Surah> getSurah(int surahNumber) async {
    final reciter = storageServices.getReciter();
    final response = await networkServices.get('surah/$surahNumber/$reciter');
    final body = json.decode(response?.data);

    return Surah.fromJson(body['data']);
  }
}
