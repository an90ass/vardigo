import 'package:flutter_test/flutter_test.dart';
import 'package:vardigo/core/network/api_exception.dart';
import 'package:vardigo/core/network/api_response_parser.dart';

void main() {
  group('ApiResponseParser', () {
    test('should extract data when ok is true and data field exists', () {
      final jsonResponse = {
        'ok': true,
        'data': {
          'totalPerfect': 26,
          'totalSimilar': 16,
          'candidates': [],
        }
      };

      final data = ApiResponseParser.parseData(jsonResponse);
      expect(data, isA<Map<String, dynamic>>());
      expect((data as Map<String, dynamic>)['totalPerfect'], 26);
    });

    test('should throw ApiException when ok is false with error message', () {
      final jsonResponse = {
        'ok': false,
        'error': {
          'message': 'Yetkisiz erişim',
          'code': 'UNAUTHORIZED',
        }
      };

      expect(
        () => ApiResponseParser.parseData(jsonResponse),
        throwsA(isA<ApiException>().having(
          (e) => e.message,
          'message',
          'Yetkisiz erişim',
        )),
      );
    });

    test('should return raw map if ok is not explicitly false and no data key', () {
      final rawMap = {'custom': 'value'};
      final data = ApiResponseParser.parseData(rawMap);
      expect(data, equals(rawMap));
    });

    test('should throw FormatException if raw data is not a map', () {
      final rawList = ['item1', 'item2'];
      expect(
        () => ApiResponseParser.parseData(rawList),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
