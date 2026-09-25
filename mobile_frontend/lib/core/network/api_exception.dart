import 'package:dio/dio.dart';
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;
  final dynamic details;

  const ApiException({
    required this.message,
    this.statusCode,
    this.errorCode,
    this.details,
  });

  factory ApiException.fromDioError(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return _handleTimeout();

      case DioExceptionType.badResponse:
        return _handleBadResponse(dioException.response);

      case DioExceptionType.cancel:
        return _handleCancel();

      case DioExceptionType.connectionError:
        return _handleConnectionError();

      case DioExceptionType.badCertificate:
        return _handleBadCertificate();

      default:
        return _handleUnknownError();
    }
  }



  static ApiException _handleTimeout() {
    return const ApiException(
      message: 'Bağlantı zaman aşımına uğradı. Lütfen internetinizi kontrol edin.',
      statusCode: 408,
      errorCode: 'TIMEOUT',
    );
  }

  static ApiException _handleBadResponse(Response<dynamic>? response) {
    final statusCode = response?.statusCode;

    String? serverMessage;
    String? serverCode;
    dynamic errorDetails;

    if (response?.data is Map<String, dynamic>) {
      final data = response!.data as Map<String, dynamic>;
      final error = data['error'];
      if (error is Map<String, dynamic>) {
        serverMessage = error['message'];
        serverCode = error['code'];
        errorDetails = error['details'];
      } else if (data['detail'] is String) {
        serverMessage = data['detail'];
      }
    }

    return ApiException(
      message: serverMessage ?? _defaultMessageForStatus(statusCode),
      statusCode: statusCode,
      errorCode: serverCode ?? _defaultCodeForStatus(statusCode),
      details: errorDetails,
    );
  }

  static ApiException _handleCancel() {
    return const ApiException(
      message: 'İstek kullanıcı tarafından iptal edildi.',
      errorCode: 'REQUEST_CANCELLED',
    );
  }

  static ApiException _handleConnectionError() {
    return const ApiException(
      message: 'Sunucuya bağlanılamadı. Lütfen sunucunun (http://127.0.0.1:8000) çalıştığından emin olun.',
      errorCode: 'CONNECTION_ERROR',
    );
  }

  static ApiException _handleBadCertificate() {
    return const ApiException(
      message: 'Güvenlik sertifikası doğrulanamadı.',
      errorCode: 'BAD_CERTIFICATE',
    );
  }

  static ApiException _handleUnknownError() {
    return const ApiException(
      message: 'Beklenmeyen bir ağ hatası oluştu. Lütfen tekrar deneyin.',
      errorCode: 'UNKNOWN_NETWORK_ERROR',
    );
  }


  bool get isBadRequest => statusCode == 400;

  /// HTTP 401 Unauthorized (Invalid or expired token)
  bool get isUnauthorized => statusCode == 401;

  /// HTTP 403 Forbidden (Insufficient role privileges)
  bool get isForbidden => statusCode == 403;

  /// HTTP 404 Not Found (Candidate or offer not found)
  bool get isNotFound => statusCode == 404;

  /// HTTP 409 Conflict (e.g. Active offer already exists, or offer expired/already answered)
  bool get isConflict => statusCode == 409;

  /// HTTP 500+ Internal Server Error
  bool get isServerError => statusCode != null && statusCode! >= 500;

  /// Network connectivity failure
  bool get isConnectionError => errorCode == 'CONNECTION_ERROR' || errorCode == 'TIMEOUT';

  // ==========================================
  // Private Status Fallbacks
  // ==========================================

  static String _defaultMessageForStatus(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Geçersiz istek. Lütfen gönderilen bilgileri kontrol edin.';
      case 401:
        return 'Oturum süreniz dolmuş veya yetkisiz erişim. Lütfen tekrar giriş yapın.';
      case 403:
        return 'Bu işlemi gerçekleştirmek için yetkiniz bulunmamaktadır.';
      case 404:
        return 'İstenen kaynak sunucuda bulunamadı.';
      case 409:
        return 'İş kuralı çakışması: Bu teklif zaten açık veya süresi dolmuş.';
      case 500:
      case 502:
      case 503:
        return 'Sunucu kaynaklı bir hata oluştu. Lütfen daha sonra tekrar deneyin.';
      default:
        return 'Sunucu hatası ($statusCode). Lütfen tekrar deneyin.';
    }
  }

  static String _defaultCodeForStatus(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'BAD_REQUEST';
      case 401:
        return 'UNAUTHORIZED';
      case 403:
        return 'FORBIDDEN';
      case 404:
        return 'NOT_FOUND';
      case 409:
        return 'OFFER_STATE_CONFLICT';
      case 500:
        return 'INTERNAL_SERVER_ERROR';
      default:
        return 'HTTP_ERROR_$statusCode';
    }
  }

  @override
  String toString() => 'ApiException(status: $statusCode, code: $errorCode, message: $message)';
}
