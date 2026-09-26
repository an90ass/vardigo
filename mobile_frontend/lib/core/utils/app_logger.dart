import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class _FlutterLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    for (final line in event.lines) {
      debugPrint(line);
    }
  }
}

abstract final class AppLogger {
  static final Logger _logger = Logger(
    filter: ProductionFilter(),
    printer: PrettyPrinter(

      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: false,
      printEmojis: false,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    output: _FlutterLogOutput(),
  );

  // Debug level logs
  static void d(dynamic message) => _logger.d(message);

  // Info level logs
  static void i(dynamic message) => _logger.i(message);

  // Warning level logs
  static void w(dynamic message) => _logger.w(message);

  // Error level logs with optional error object and stack trace
  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
}
