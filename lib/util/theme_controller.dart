import 'package:flutter/material.dart';
import 'package:hafiz_test/locator.dart';
import 'package:hafiz_test/services/storage/abstract_storage_service.dart';

class ThemeController extends ChangeNotifier {
  String _mode;

  ThemeController() : _mode = getIt<IStorageService>().getThemeMode();

  String get mode => _mode;

  Future<void> setMode(String mode) async {
    if (_mode == mode) return;
    _mode = mode;
    await getIt<IStorageService>().setThemeMode(mode);
    notifyListeners();
  }
}
