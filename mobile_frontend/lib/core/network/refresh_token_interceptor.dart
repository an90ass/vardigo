import 'package:dio/dio.dart';
import '../enums/app_enums.dart';

// This Interceptor hook for managing 401 Unauthorized responses and session expiry.

class RefreshTokenInterceptor extends Interceptor {
  final Dio dio;

  RefreshTokenInterceptor({required this.dio});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;
    final req = err.requestOptions;

    final authType = req.extra['authType'] as ApiAuthType? ?? ApiAuthType.none;

    // Intercept 401 Unauthorized on authenticated requests
    if (statusCode == 401 && authType == ApiAuthType.bearerToken) {
      // Hook ready for future token refresh or session invalidation notification
      return handler.next(err);
    }

    return handler.next(err);
  }
}
