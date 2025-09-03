import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hafiz_test/services/ayah.services.dart';
import 'package:hafiz_test/services/network.services.dart';
import 'package:hafiz_test/services/storage/abstract_storage_service.dart';
import 'package:hafiz_test/model/ayah.model.dart';

class MockNetworkServices extends Mock implements NetworkServices {}

class MockIStorageService extends Mock implements IStorageService {}

void main() {
  group('AyahServices', () {
    late AyahServices ayahServices;
    late MockNetworkServices mockNetworkServices;
    late MockIStorageService mockStorageServices;

    setUp(() {
      mockNetworkServices = MockNetworkServices();
      mockStorageServices = MockIStorageService();
      ayahServices = AyahServices(
        networkServices: mockNetworkServices,
        storageServices: mockStorageServices,
      );
    });

    group('getSurahAyahs', () {
      test('should return list of ayahs on successful response', () async {
        // Arrange
        const surahNumber = 1;
        const reciter = 'ar.alafasy';
        final mockResponse = Response(
          data: {
            'data': {
              'ayahs': [
                {
                  'number': 1,
                  'text': 'First ayah',
                  'audio': '',
                  'audioSecondary': [],
                  'numberInSurah': 1,
                  'juz': 1,
                  'manzil': 1,
                  'page': 1,
                  'ruku': 1,
                  'hizbQuarter': 1,
                  'surah': {'number': 1, 'name': 'Test'}
                },
                {
                  'number': 2,
                  'text': 'Second ayah',
                  'audio': '',
                  'audioSecondary': [],
                  'numberInSurah': 2,
                  'juz': 1,
                  'manzil': 1,
                  'page': 1,
                  'ruku': 1,
                  'hizbQuarter': 1,
                  'surah': {'number': 1, 'name': 'Test'}
                },
              ]
            }
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        when(() => mockStorageServices.getReciter()).thenReturn(reciter);
        when(() => mockNetworkServices.get('surah/$surahNumber/$reciter'))
            .thenAnswer((_) async => mockResponse);

        // Act
        final result = await ayahServices.getSurahAyahs(surahNumber);

        // Assert
        expect(result, isA<List<Ayah>>());
        expect(result.length, equals(2));
        verify(() => mockStorageServices.getReciter()).called(1);
        verify(() => mockNetworkServices.get('surah/$surahNumber/$reciter'))
            .called(1);
      });

      test('should return empty list on null response data', () async {
        // Arrange
        const surahNumber = 1;
        const reciter = 'ar.alafasy';
        final mockResponse = Response(
          data: null,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        when(() => mockStorageServices.getReciter()).thenReturn(reciter);
        when(() => mockNetworkServices.get('surah/$surahNumber/$reciter'))
            .thenAnswer((_) async => mockResponse);

        // Act
        final result = await ayahServices.getSurahAyahs(surahNumber);

        // Assert
        expect(result, isEmpty);
      });

      test('should return empty list on network error', () async {
        // Arrange
        const surahNumber = 1;
        const reciter = 'ar.alafasy';

        when(() => mockStorageServices.getReciter()).thenReturn(reciter);
        when(() => mockNetworkServices.get('surah/$surahNumber/$reciter'))
            .thenThrow(DioException(requestOptions: RequestOptions(path: '')));

        // Act
        final result = await ayahServices.getSurahAyahs(surahNumber);

        // Assert
        expect(result, isEmpty);
      });
    });

    group('getRandomAyahFromJuz', () {
      test('should return random ayah from juz', () async {
        // Arrange
        const juzNumber = 1;
        final mockResponse = Response(
          data: {
            'data': {
              'ayahs': [
                {
                  'number': 1,
                  'text': 'Ayah text',
                  'audio': '',
                  'audioSecondary': [],
                  'numberInSurah': 1,
                  'juz': 1,
                  'manzil': 1,
                  'page': 1,
                  'ruku': 1,
                  'hizbQuarter': 1,
                  'surah': {'number': 2, 'name': 'Test'}
                }
              ]
            }
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        when(() => mockNetworkServices.get('juz/$juzNumber/quran-uthmani'))
            .thenAnswer((_) async => mockResponse);

        // Act
        final result = await ayahServices.getRandomAyahFromJuz(juzNumber);

        // Assert
        expect(result, isA<Ayah>());
        verify(() => mockNetworkServices.get('juz/$juzNumber/quran-uthmani'))
            .called(1);
      });

      test('should return empty ayah on error', () async {
        // Arrange
        const juzNumber = 1;

        when(() => mockNetworkServices.get('juz/$juzNumber/quran-uthmani'))
            .thenThrow(DioException(requestOptions: RequestOptions(path: '')));

        // Act
        final result = await ayahServices.getRandomAyahFromJuz(juzNumber);

        // Assert
        expect(result, isA<Ayah>());
      });
    });

    group('getRandomAyahForSurah', () {
      test('should return random ayah from provided list', () {
        // Arrange
        final ayahs = [
          Ayah(number: 1, text: 'First'),
          Ayah(number: 2, text: 'Second'),
          Ayah(number: 3, text: 'Third'),
        ];

        // Act
        final result = ayahServices.getRandomAyahForSurah(ayahs);

        // Assert
        expect(result, isA<Ayah>());
        expect(ayahs.any((ayah) => ayah.number == result.number), isTrue);
      });

      test('should return empty ayah when list is empty', () {
        // Arrange
        final ayahs = <Ayah>[];

        // Act
        final result = ayahServices.getRandomAyahForSurah(ayahs);

        // Assert
        expect(result, isA<Ayah>());
      });

      test('should return first ayah when list has one item', () {
        // Arrange
        final ayahs = [Ayah(number: 1, text: 'Only ayah')];

        // Act
        final result = ayahServices.getRandomAyahForSurah(ayahs);

        // Assert
        expect(result.number, equals(1));
        expect(result.text, equals('Only ayah'));
      });
    });
  });
}
