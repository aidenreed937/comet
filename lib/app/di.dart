import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/error/error_reporter.dart';
import '../core/network/auth_token_manager.dart';
import '../core/network/dio_client.dart';
import '../core/storage/key_value_storage.dart';
import '../core/storage/secure_storage.dart';

/// Core service providers for dependency injection.
/// Feature-specific providers should remain in their respective feature modules.

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

final keyValueStorageProvider = Provider<KeyValueStorage>((ref) {
  throw UnimplementedError(
    'keyValueStorageProvider must be overridden with SharedPreferencesStorage',
  );
});

final secureStorageProvider = Provider<SecureStorage>((ref) {
  return FlutterSecureStorageImpl();
});

final errorReporterProvider = Provider<ErrorReporter>((ref) {
  return const DefaultErrorReporter();
});

/// Provider for AuthTokenManager
final authTokenManagerProvider = Provider<AuthTokenManager>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthTokenManager(secureStorage);
});

/// Provider for checking authentication state
final isAuthenticatedProvider = FutureProvider<bool>((ref) async {
  final tokenManager = ref.watch(authTokenManagerProvider);
  return tokenManager.isAuthenticated();
});

/// Stream provider for auth state changes
final authStateChangesProvider = StreamProvider<bool>((ref) {
  final tokenManager = ref.watch(authTokenManagerProvider);
  return tokenManager.authStateChanges;
});
