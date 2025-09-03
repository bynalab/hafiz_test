import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hafiz_test/services/storage/shared_prefs_storage_service.dart';
import 'package:hafiz_test/model/surah.model.dart';
import 'package:hafiz_test/model/ayah.model.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('SharedPrefsStorageService', () {
    late SharedPrefsStorageService storageService;
    late MockSharedPreferences mockPrefs;

    setUp(() {
      mockPrefs = MockSharedPreferences();
      storageService = SharedPrefsStorageService(mockPrefs);
    });

    group('AutoPlay', () {
      test('checkAutoPlay should return stored value when exists', () {
        // Arrange
        when(() => mockPrefs.getBool('autoplay')).thenReturn(false);

        // Act
        final result = storageService.checkAutoPlay();

        // Assert
        expect(result, isFalse);
        verify(() => mockPrefs.getBool('autoplay')).called(1);
      });

      test('checkAutoPlay should return true as default when not stored', () {
        // Arrange
        when(() => mockPrefs.getBool('autoplay')).thenReturn(null);

        // Act
        final result = storageService.checkAutoPlay();

        // Assert
        expect(result, isTrue);
      });

      test('setAutoPlay should save value successfully', () async {
        // Arrange
        when(() => mockPrefs.setBool('autoplay', any()))
            .thenAnswer((_) async => true);

        // Act
        final result = await storageService.setAutoPlay(false);

        // Assert
        expect(result, isTrue);
        verify(() => mockPrefs.setBool('autoplay', false)).called(1);
      });
    });

    group('Reciter', () {
      test('getReciter should return stored reciter', () {
        // Arrange
        const storedReciter = 'ar.husary';
        when(() => mockPrefs.getString('reciter')).thenReturn(storedReciter);

        // Act
        final result = storageService.getReciter();

        // Assert
        expect(result, equals(storedReciter));
      });

      test('getReciter should return default when not stored', () {
        // Arrange
        when(() => mockPrefs.getString('reciter')).thenReturn(null);

        // Act
        final result = storageService.getReciter();

        // Assert
        expect(result, equals('ar.alafasy'));
      });

      test('setReciter should save reciter successfully', () async {
        // Arrange
        const newReciter = 'ar.husary';
        when(() => mockPrefs.setString('reciter', newReciter))
            .thenAnswer((_) async => true);

        // Act
        final result = await storageService.setReciter(newReciter);

        // Assert
        expect(result, isTrue);
        verify(() => mockPrefs.setString('reciter', newReciter)).called(1);
      });
    });

    group('Last Read', () {
      test('saveLastRead should save surah and ayah as JSON', () async {
        // Arrange
        final surah = Surah(number: 1, name: 'Al-Fatihah');
        final ayah = Ayah(number: 1, text: 'In the name of Allah');
        when(() => mockPrefs.setString('last_read', any()))
            .thenAnswer((_) async => true);

        // Act
        final result = await storageService.saveLastRead(surah, ayah);

        // Assert
        expect(result, isTrue);
        verify(() => mockPrefs.setString('last_read', any())).called(1);
      });

      test('getLastRead should return null when no data stored', () {
        // Arrange
        when(() => mockPrefs.getString('last_read')).thenReturn(null);

        // Act
        final result = storageService.getLastRead();

        // Assert
        expect(result, isNull);
      });

      test('getLastRead should return parsed data when stored', () {
        // Arrange
        final testData = {
          'surah': {
            'number': 1,
            'name': 'Al-Fatihah',
            'englishName': 'The Opener',
            'englishNameTranslation': '',
            'revelationType': '',
            'numberOfAyahs': 7,
            'ayahs': []
          },
          'ayah': {
            'number': 1,
            'text': 'In the name of Allah',
            'audio': '',
            'audioSecondary': [],
            'numberInSurah': 1,
            'juz': 1,
            'manzil': 1,
            'page': 1,
            'ruku': 1,
            'hizbQuarter': 1,
            'surah': {'number': 1, 'name': 'Al-Fatihah'}
          }
        };

        when(() => mockPrefs.getString('last_read'))
            .thenReturn(jsonEncode(testData));

        // Act
        final result = storageService.getLastRead();

        // Assert
        expect(result, isNotNull);
        expect(result!.$1.number, equals(1));
        expect(result.$2.number, equals(1));
      });

      test('getLastRead should return null on JSON parsing error', () {
        // Arrange
        when(() => mockPrefs.getString('last_read')).thenReturn('invalid json');

        // Act
        final result = storageService.getLastRead();

        // Assert
        expect(result, isNull);
      });
    });

    group('User Guide', () {
      test('hasViewedShowcase should return stored value', () {
        // Arrange
        when(() => mockPrefs.getBool('has_view_showcase')).thenReturn(true);

        // Act
        final result = storageService.hasViewedShowcase();

        // Assert
        expect(result, isTrue);
      });

      test('hasViewedShowcase should return false as default', () {
        // Arrange
        when(() => mockPrefs.getBool('has_view_showcase')).thenReturn(null);

        // Act
        final result = storageService.hasViewedShowcase();

        // Assert
        expect(result, isFalse);
      });

      test('saveUserGuide should save showcase flag', () async {
        // Arrange
        when(() => mockPrefs.setBool('has_view_showcase', true))
            .thenAnswer((_) async => true);

        // Act
        await storageService.saveUserGuide();

        // Assert
        verify(() => mockPrefs.setBool('has_view_showcase', true)).called(1);
      });
    });
  });
}
