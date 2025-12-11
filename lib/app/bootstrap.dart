import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../core/config/app_config.dart';
import '../core/error/error_reporter.dart';
import '../core/utils/logger.dart';
import 'app.dart';

Future<void> bootstrap({required String environment}) async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize configuration
      AppConfig.initialize(environment);

      // Set preferred orientations
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      // Initialize Hive
      await Hive.initFlutter();

      // Set up Flutter error handling
      FlutterError.onError = (details) {
        Logger.e(
          'Flutter error: ${details.exception}',
          stackTrace: details.stack,
        );
        if (AppConfig.env.enableCrashReporting) {
          const DefaultErrorReporter().reportError(
            details.exception,
            details.stack,
          );
        }
      };

      Logger.i('App initialized with environment: $environment');

      runApp(const ProviderScope(child: App()));
    },
    (error, stackTrace) {
      Logger.e('Unhandled error: $error', stackTrace: stackTrace);
      if (AppConfig.env.enableCrashReporting) {
        const DefaultErrorReporter().reportError(error, stackTrace);
      }
    },
  );
}
