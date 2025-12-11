import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

import '../config/app_config.dart';

class Logger {
  Logger._();

  static void d(String message, {String? tag}) {
    if (AppConfig.env.enableLogging) {
      _log('DEBUG', message, tag: tag);
    }
  }

  static void i(String message, {String? tag}) {
    if (AppConfig.env.enableLogging) {
      _log('INFO', message, tag: tag);
    }
  }

  static void w(String message, {String? tag}) {
    if (AppConfig.env.enableLogging) {
      _log('WARN', message, tag: tag);
    }
  }

  static void e(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (AppConfig.env.enableLogging) {
      _log('ERROR', message, tag: tag);
      if (error != null) {
        _log('ERROR', 'Error: $error', tag: tag);
      }
      if (stackTrace != null) {
        _log('ERROR', 'StackTrace: $stackTrace', tag: tag);
      }
    }
  }

  static void _log(String level, String message, {String? tag}) {
    final formattedTag = tag != null ? '[$tag]' : '';
    final logMessage = '[$level]$formattedTag $message';

    if (kDebugMode) {
      developer.log(logMessage);
    }
  }
}
