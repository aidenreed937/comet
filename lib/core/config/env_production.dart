import 'env.dart';

class EnvProduction implements Env {
  @override
  String get appName => 'Comet';

  @override
  String get apiBaseUrl => 'https://api.example.com';

  @override
  bool get enableLogging => false;

  @override
  bool get enableCrashReporting => true;
}
