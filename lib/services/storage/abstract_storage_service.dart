import 'package:hafiz_test/model/ayah.model.dart';
import 'package:hafiz_test/model/surah.model.dart';

abstract class IStorageService {
  bool checkAutoPlay();
  Future<bool> setAutoPlay(bool autoPlay);

  Future<bool> setReciter(String identifier);

  /// Get the reciter identifier from shared preferences.
  ///
  /// Returns the reciter identifier as a string. If no identifier is found,
  /// returns 'ar.alafasy' as the default.
  String getReciter();

  Future<bool> saveLastRead(Surah surah, Ayah ayah);
  (Surah, Ayah)? getLastRead();

  bool hasViewedShowcase();
  Future<void> saveUserGuide();

  /// Theme mode persistence
  Future<bool> setThemeMode(String mode);
  String getThemeMode();
}
