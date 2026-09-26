import 'api_exception.dart';

/*  
    Centralized utility to validate API envelope responses (ok == true)
    and safely extract the payload (data) or throw an ApiException
    carrying the server's exact error message and code
 */
abstract final class ApiResponseParser {
  static dynamic parseData(dynamic rawData) {
    if (rawData is Map<String, dynamic>) {
      final isOk = rawData['ok'] as bool? ?? true;
      if (!isOk) {
        final error = rawData['error'] as Map<String, dynamic>?;
        throw ApiException(
          message: error?['message']?.toString() ?? 'İşlem başarısız oldu',
          errorCode: error?['code']?.toString() ?? 'BUSINESS_ERROR',
        );
      }
      return rawData['data'] ?? rawData;
    }
    throw const FormatException('Beklenmeyen sunucu yanıt biçimi');
  }
}
