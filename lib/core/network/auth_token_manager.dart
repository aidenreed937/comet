import 'dart:async';

import '../storage/secure_storage.dart';

/// Manages authentication tokens (access token and refresh token)
class AuthTokenManager {
  AuthTokenManager(this._secureStorage);

  final SecureStorage _secureStorage;

  /// Stream controller for auth state changes
  final _authStateController = StreamController<bool>.broadcast();

  /// Stream of authentication state changes
  Stream<bool> get authStateChanges => _authStateController.stream;

  /// Get the current access token
  Future<String?> getAccessToken() async {
    return _secureStorage.read(SecureStorageKeys.accessToken);
  }

  /// Get the current refresh token
  Future<String?> getRefreshToken() async {
    return _secureStorage.read(SecureStorageKeys.refreshToken);
  }

  /// Check if user is authenticated (has valid access token)
  Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Save tokens after successful login
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _secureStorage.write(SecureStorageKeys.accessToken, accessToken);
    if (refreshToken != null) {
      await _secureStorage.write(SecureStorageKeys.refreshToken, refreshToken);
    }
    _authStateController.add(true);
  }

  /// Update access token (e.g., after refresh)
  Future<void> updateAccessToken(String accessToken) async {
    await _secureStorage.write(SecureStorageKeys.accessToken, accessToken);
  }

  /// Clear all tokens (logout)
  Future<void> clearTokens() async {
    await _secureStorage.delete(SecureStorageKeys.accessToken);
    await _secureStorage.delete(SecureStorageKeys.refreshToken);
    await _secureStorage.delete(SecureStorageKeys.userId);
    _authStateController.add(false);
  }

  /// Save user ID
  Future<void> saveUserId(String userId) async {
    await _secureStorage.write(SecureStorageKeys.userId, userId);
  }

  /// Get user ID
  Future<String?> getUserId() async {
    return _secureStorage.read(SecureStorageKeys.userId);
  }

  /// Dispose resources
  void dispose() {
    _authStateController.close();
  }
}

/// Token refresh callback type
typedef TokenRefreshCallback = Future<String?> Function(String refreshToken);

/// Callback type for handling authentication failure
typedef AuthFailureCallback = void Function();
