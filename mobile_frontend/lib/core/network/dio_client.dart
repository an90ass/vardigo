import 'package:dio/dio.dart';
import '../enums/app_enums.dart';
import '../storage/token_storage.dart';
import 'api_exception.dart';
import 'api_interface.dart';
import 'api_url.dart';
import 'refresh_token_interceptor.dart';

class DioClient implements API {
  static const int _maxRetries = 3;

  final Dio dio;

  DioClient({Dio? customDio, String? baseUrl})
      : dio = customDio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl ?? ApiUrl.baseUrl,
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
                sendTimeout: const Duration(seconds: 15),
                headers: const {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            ) {
    dio.interceptors.clear();
    dio.interceptors.addAll(_buildInterceptors());
  }

  List<Interceptor> _buildInterceptors() {
    return [
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final authType =
              options.extra['authType'] as ApiAuthType? ?? ApiAuthType.none;

          // Directly fetch token from TokenStorage (Single Source of Truth)
          if (authType == ApiAuthType.bearerToken) {
            final token = await TokenStorage.getToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }

          handler.next(options);
        },
        onResponse: (response, handler) => handler.next(response),
        onError: (error, handler) async {
          final requestOptions = error.requestOptions;
          final retries = (requestOptions.extra['retries'] as int? ?? 0);

          // Retry up to 3 times for timeout or network connection failures
          if (retries < _maxRetries && _isNetworkOrTimeoutError(error)) {
            requestOptions.extra['retries'] = retries + 1;
            try {
              await Future.delayed(const Duration(milliseconds: 500));
              final response = await dio.fetch(requestOptions);
              return handler.resolve(response);
            } on DioException catch (retryError) {
              return handler.next(retryError);
            } catch (_) {
              return handler.next(error);
            }
          }

          return handler.next(error);
        },
      ),
      RefreshTokenInterceptor(dio: dio),
    ];
  }

  bool _isNetworkOrTimeoutError(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.connectionError;
  }

  Options _mergeOptions(ApiAuthType authType, Map<String, dynamic>? headers) {
    return Options(
      headers: headers,
      extra: {'authType': authType},
      validateStatus: (status) => status != null && status >= 200 && status < 300,
    );
  }

  @override
  Future<Response<dynamic>> get(
    String path, {
    ApiAuthType authType = ApiAuthType.none,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: _mergeOptions(authType, headers),
      );
      return response;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<Response<dynamic>> post(
    String path, {
    ApiAuthType authType = ApiAuthType.none,
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(authType, headers),
      );
      return response;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<Response<dynamic>> put(
    String path, {
    ApiAuthType authType = ApiAuthType.none,
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(authType, headers),
      );
      return response;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<Response<dynamic>> delete(
    String path, {
    ApiAuthType authType = ApiAuthType.none,
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(authType, headers),
      );
      return response;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
