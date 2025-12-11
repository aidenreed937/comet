import 'env.dart';
import 'env_development.dart';
import 'env_production.dart';
import 'env_staging.dart';

class AppConfig {
  AppConfig._();

  static late Env _env;

  static Env get env => _env;

  static void initialize(String environment) {
    switch (environment) {
      case 'development':
        _env = EnvDevelopment();
      case 'staging':
        _env = EnvStaging();
      case 'production':
        _env = EnvProduction();
      default:
        _env = EnvDevelopment();
    }
  }

  static String get appEnv =>
      const String.fromEnvironment('APP_ENV', defaultValue: 'development');
}
