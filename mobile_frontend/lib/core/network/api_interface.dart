import 'package:dio/dio.dart';
import '../enums/app_enums.dart';

export '../enums/app_enums.dart' show ApiAuthType;

abstract class API {

  Future<Response<dynamic>> get(
    String path, {
    ApiAuthType authType = ApiAuthType.none,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  });

  Future<Response<dynamic>> post(
    String path, {
    ApiAuthType authType = ApiAuthType.none,
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  });

  Future<Response<dynamic>> put(
    String path, {
    ApiAuthType authType = ApiAuthType.none,
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  });

  Future<Response<dynamic>> delete(
    String path, {
    ApiAuthType authType = ApiAuthType.none,
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  });
}
