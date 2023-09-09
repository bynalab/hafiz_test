import 'package:hafiz_test/model/ayah.model.dart';

class Surah {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;
  final int numberOfAyahs;
  final List<Ayah> ayahs;

  Surah({
    this.number = 0,
    this.name = '',
    this.englishName = '',
    this.englishNameTranslation = '',
    this.revelationType = '',
    this.numberOfAyahs = 1,
    this.ayahs = const [],
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    final ayahsJson = (json['ayahs'] ?? []) as List;
    final ayahs = ayahsJson.map((ayahJson) => Ayah.fromJson(ayahJson)).toList();

    return Surah(
      number: json['number'] ?? 0,
      name: json['name'] ?? '',
      englishName: json['englishName'] ?? '',
      englishNameTranslation: json['englishNameTranslation'] ?? '',
      revelationType: json['revelationType'] ?? '',
      numberOfAyahs: json['numberOfAyahs'] ?? 0,
      ayahs: ayahs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name': name,
      'englishName': englishName,
      'englishNameTranslation': englishNameTranslation,
      'revelationType': revelationType,
      'numberOfAyahs': numberOfAyahs,
      'ayahs': ayahs.map((ayah) => ayah.toJson()).toList(),
    };
  }

  static Surah fromJsonMap(Map<String, dynamic> map) {
    return Surah.fromJson(map);
  }

  static List<Surah> fromJsonList(List<Map<String, dynamic>> jsonList) {
    return jsonList.map((json) => Surah.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<Surah> surahs) {
    return surahs.map((surah) => surah.toJson()).toList();
  }
}
