import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

abstract class Logger {
  static void info(String message, {String tag = 'INFO'}) {
    if (kDebugMode) {
      developer.log(message, name: tag);
    }
  }

  static void warning(String message, {String tag = 'WARNING'}) {
    if (kDebugMode) {
      developer.log(message, name: tag, level: 900); // 900 ~ WARNING
    }
  }

  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String tag = 'ERROR',
  }) {
    developer.log(
      message,
      name: tag,
      error: error,
      stackTrace: stackTrace,
      level: 1000,
    );
  }

  static void debug(String message, {String tag = 'DEBUG'}) {
    if (kDebugMode) {
      developer.log(message, name: tag, level: 500);
    }
  }
}
