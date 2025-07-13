import 'dart:math';

class SurahPicker {
  final List<int> _surahs = List.generate(114, (i) => i + 1);
  final Random _random = Random.secure();
  int _index = 0;

  SurahPicker() {
    _shuffle();
  }

  void _shuffle() {
    _surahs.shuffle(_random);
    _index = 0;
  }

  int getNextSurah() {
    if (_index >= _surahs.length) _shuffle();
    return _surahs[_index++];
  }
}
