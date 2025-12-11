import 'env.dart';

class EnvStaging implements Env {
  @override
  String get appName => 'Comet Staging';

  @override
  String get apiBaseUrl => 'https://api-staging.example.com';

  @override
  bool get enableLogging => true;

  @override
  bool get enableCrashReporting => true;
}
