import 'package:flutter_test/flutter_test.dart';
import 'package:hafiz_test/services/network.services.dart';

void main() {
  group('NetworkServices', () {
    late NetworkServices networkServices;

    setUp(() {
      networkServices = NetworkServices();
    });

    test('should have correct base configuration', () {
      expect(networkServices, isA<NetworkServices>());
    });

    group('get method', () {
      test('should accept URL and query parameters', () {
        expect(
          () => networkServices.get('/test', queryParameters: {'key': 'value'}),
          returnsNormally,
        );
      });
    });
  });
}
