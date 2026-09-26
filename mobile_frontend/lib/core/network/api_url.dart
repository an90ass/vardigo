import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract final class ApiUrl {

  static String get baseUrl {
    if (kIsWeb) {
      return dotenv.env['BASE_URL_WEB'] ?? 'http://127.0.0.1:8000/api';
    }
    if (Platform.isAndroid) {
      return dotenv.env['BASE_URL_ANDROID'] ?? 'http://10.0.2.2:8000/api';
    }
    return dotenv.env['BASE_URL_DEFAULT'] ?? 'http://127.0.0.1:8000/api';
  }
}
