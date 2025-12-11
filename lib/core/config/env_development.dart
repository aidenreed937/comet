import 'env.dart';

class EnvDevelopment implements Env {
  @override
  String get appName => 'Comet Dev';

  @override
  String get apiBaseUrl => 'https://api-dev.example.com';

  @override
  bool get enableLogging => true;

  @override
  bool get enableCrashReporting => false;
}
