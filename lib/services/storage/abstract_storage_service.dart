import 'package:hafiz_test/model/ayah.model.dart';
import 'package:hafiz_test/model/surah.model.dart';

abstract class IStorageService {
  bool checkAutoPlay();
  Future<bool> setAutoPlay(bool autoPlay);

  Future<bool> setReciter(String identifier);
  String getReciter();

  Future<bool> saveLastRead(Surah surah, Ayah ayah);
  (Surah, Ayah)? getLastRead();

  bool hasViewedShowcase();
  Future<void> saveUserGuide();
}
