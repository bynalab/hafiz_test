import 'dart:convert';
import 'dart:math';

import 'package:hafiz_test/model/surah.model.dart';
import 'package:hafiz_test/services/network.services.dart';

class SurahServices {
  final _networkServices = NetworkServices();

  int getRandomSurahNumber() {
    final surahNumber = 1 + Random().nextInt(114 - 1);

    return surahNumber;
  }

  Future<Surah> getSurah(int surahNumber) async {
    final response =
        await _networkServices.get('surah/$surahNumber/ar.alafasy');

    final body = json.decode(response.body);

    final surah = Surah.fromJson(body['data']);

    return surah;
  }
}
