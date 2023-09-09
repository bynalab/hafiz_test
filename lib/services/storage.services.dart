import 'package:shared_preferences/shared_preferences.dart';

class StorageServices {
  Future<bool> checkAutoPlay() async {
    SharedPreferences settings = await SharedPreferences.getInstance();

    return settings.getBool('autoplay') ?? true;
  }

  Future<bool> setAutoPlay(bool autoPlay) async {
    SharedPreferences settings = await SharedPreferences.getInstance();
    return settings.setBool('autoplay', autoPlay);
  }
}
