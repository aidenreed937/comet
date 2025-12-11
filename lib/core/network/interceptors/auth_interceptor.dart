import 'dart:async';

import 'package:dio/dio.dart';

import '../auth_token_manager.dart';

/// Interceptor for handling authentication tokens and 401 errors
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    this.tokenManager,
    this.onTokenRefresh,
    this.onAuthFailure,
    this.excludedPaths = const [
      '/auth/login',
      '/auth/register',
      '/auth/refresh',
    ],
  });

  /// Token manager for accessing and updating tokens
  /// If null, the interceptor will not add auth headers
  final AuthTokenManager? tokenManager;

  /// Callback to refresh the access token using refresh token
  /// Should return the new access token or null if refresh failed
  final TokenRefreshCallback? onTokenRefresh;

  /// Callback when authentication fails (e.g., redirect to login)
  final AuthFailureCallback? onAuthFailure;

  /// Paths that don't require authentication
  final List<String> excludedPaths;

  /// Flag to prevent multiple refresh attempts
  bool _isRefreshing = false;

  /// Completer to queue requests while refreshing
  Completer<String?>? _refreshCompleter;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip if no token manager configured
    if (tokenManager == null) {
      return handler.next(options);
    }

    // Skip auth for excluded paths
    if (_isExcludedPath(options.path)) {
      return handler.next(options);
    }

    // Add access token to request header
    final token = await tokenManager!.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Skip if no token manager configured
    if (tokenManager == null) {
      return handler.next(err);
    }

    // Only handle 401 Unauthorized errors
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // Skip retry for excluded paths
    if (_isExcludedPath(err.requestOptions.path)) {
      return handler.next(err);
    }

    // If no refresh callback, just fail
    if (onTokenRefresh == null) {
      _handleAuthFailure();
      return handler.next(err);
    }

    // Try to refresh the token
    final newToken = await _refreshToken();
    if (newToken == null) {
      _handleAuthFailure();
      return handler.next(err);
    }

    // Retry the original request with new token
    try {
      final response = await _retryRequest(err.requestOptions, newToken);
      return handler.resolve(response);
    } catch (e) {
      return handler.next(err);
    }
  }

  /// Refresh the access token
  Future<String?> _refreshToken() async {
    // If already refreshing, wait for the result
    if (_isRefreshing) {
      return _refreshCompleter?.future;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<String?>();

    try {
      final refreshToken = await tokenManager!.getRefreshToken();
      if (refreshToken == null) {
        _refreshCompleter!.complete(null);
        return null;
      }

      final newToken = await onTokenRefresh!(refreshToken);
      if (newToken != null) {
        await tokenManager!.updateAccessToken(newToken);
      }

      _refreshCompleter!.complete(newToken);
      return newToken;
    } catch (e) {
      _refreshCompleter!.complete(null);
      return null;
    } finally {
      _isRefreshing = false;
      _refreshCompleter = null;
    }
  }

  /// Retry the failed request with new token
  Future<Response<dynamic>> _retryRequest(
    RequestOptions options,
    String token,
  ) async {
    options.headers['Authorization'] = 'Bearer $token';

    final dio = Dio(
      BaseOptions(
        baseUrl: options.baseUrl,
        connectTimeout: options.connectTimeout,
        receiveTimeout: options.receiveTimeout,
      ),
    );

    return dio.fetch(options);
  }

  /// Handle authentication failure
  void _handleAuthFailure() {
    tokenManager?.clearTokens();
    onAuthFailure?.call();
  }

  /// Check if path is excluded from authentication
  bool _isExcludedPath(String path) {
    return excludedPaths.any((excluded) => path.contains(excluded));
  }
}
