import 'dart:convert';

import 'package:dio/dio.dart';

import 'cache_manager.dart';
import 'cache_strategy.dart';

/// Extra key for cache options in request options
const String cacheOptionsKey = 'cache_options';

/// Interceptor for caching network responses
class CacheInterceptor extends Interceptor {
  CacheInterceptor({
    required this.cacheManager,
    this.defaultOptions = CacheOptions.defaults,
  });

  /// Cache manager instance
  final CacheManager cacheManager;

  /// Default cache options
  final CacheOptions defaultOptions;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Only cache GET requests
    if (options.method.toUpperCase() != 'GET') {
      return handler.next(options);
    }

    final cacheOptions = _getCacheOptions(options);

    // Skip caching if network only or force refresh
    if (cacheOptions.strategy == CacheStrategy.networkOnly ||
        cacheOptions.forceRefresh) {
      return handler.next(options);
    }

    final cacheKey = cacheManager.generateKey(
      options.uri.toString(),
      queryParameters: options.queryParameters,
    );

    final cachedEntry = await cacheManager.get(cacheKey);

    switch (cacheOptions.strategy) {
      case CacheStrategy.cacheOnly:
        if (cachedEntry != null) {
          return handler.resolve(_createResponse(options, cachedEntry));
        }
        return handler.reject(
          DioException(
            requestOptions: options,
            message: 'No cached data available',
          ),
        );

      case CacheStrategy.cacheFirst:
        if (cachedEntry != null && cachedEntry.isValid) {
          return handler.resolve(_createResponse(options, cachedEntry));
        }
        break;

      case CacheStrategy.staleWhileRevalidate:
        if (cachedEntry != null) {
          // Return cached response immediately
          handler.resolve(_createResponse(options, cachedEntry));
          // Continue to network to update cache (fire and forget)
          _refreshCache(options, cacheKey, cacheOptions).ignore();
          return;
        }
        break;

      case CacheStrategy.networkFirst:
      case CacheStrategy.networkOnly:
        // Continue to network
        break;
    }

    // Store cache key for use in onResponse
    options.extra[cacheOptionsKey] = cacheOptions;
    options.extra['cache_key'] = cacheKey;

    handler.next(options);
  }

  @override
  Future<void> onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async {
    // Only cache successful GET responses
    if (response.requestOptions.method.toUpperCase() != 'GET') {
      return handler.next(response);
    }

    final cacheOptions = response.requestOptions.extra[cacheOptionsKey];
    final cacheKey = response.requestOptions.extra['cache_key'];

    if (cacheOptions == null ||
        cacheKey == null ||
        cacheOptions is! CacheOptions) {
      return handler.next(response);
    }

    // Check if response should be cached
    final shouldCache =
        cacheOptions.shouldCache?.call(response.statusCode ?? 0) ??
        (response.statusCode != null &&
            response.statusCode! >= 200 &&
            response.statusCode! < 300);

    if (shouldCache) {
      final data = response.data;
      final dataString = data is String ? data : jsonEncode(data);

      await cacheManager.put(
        cacheKey as String,
        dataString,
        maxAge: cacheOptions.maxAge,
        eTag: response.headers.value('etag'),
        lastModified: response.headers.value('last-modified'),
      );
    }

    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Try to return cached data on network error
    final cacheOptions = _getCacheOptions(err.requestOptions);

    if (cacheOptions.strategy == CacheStrategy.networkFirst) {
      final cacheKey = cacheManager.generateKey(
        err.requestOptions.uri.toString(),
        queryParameters: err.requestOptions.queryParameters,
      );

      final cachedEntry = await cacheManager.get(cacheKey);
      if (cachedEntry != null) {
        return handler.resolve(
          _createResponse(err.requestOptions, cachedEntry),
        );
      }
    }

    handler.next(err);
  }

  /// Get cache options from request options
  CacheOptions _getCacheOptions(RequestOptions options) {
    final extra = options.extra[cacheOptionsKey];
    if (extra is CacheOptions) {
      return extra;
    }
    return defaultOptions;
  }

  /// Create a response from cached entry
  Response<dynamic> _createResponse(RequestOptions options, CacheEntry entry) {
    dynamic data;
    try {
      data = jsonDecode(entry.data);
    } catch (e) {
      data = entry.data;
    }

    return Response(
      requestOptions: options,
      data: data,
      statusCode: 200,
      statusMessage: 'OK (from cache)',
      headers: Headers.fromMap({
        'x-cache': ['HIT'],
        'x-cache-age': [
          DateTime.now().difference(entry.createdAt).inSeconds.toString(),
        ],
      }),
    );
  }

  /// Refresh cache in background
  Future<void> _refreshCache(
    RequestOptions options,
    String cacheKey,
    CacheOptions cacheOptions,
  ) async {
    try {
      final dio = Dio(
        BaseOptions(
          baseUrl: options.baseUrl,
          connectTimeout: options.connectTimeout,
          receiveTimeout: options.receiveTimeout,
        ),
      );

      final response = await dio.fetch<dynamic>(
        options.copyWith(extra: {...options.extra, cacheOptionsKey: null}),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data;
        final dataString = data is String ? data : jsonEncode(data);

        await cacheManager.put(
          cacheKey,
          dataString,
          maxAge: cacheOptions.maxAge,
          eTag: response.headers.value('etag'),
          lastModified: response.headers.value('last-modified'),
        );
      }
    } catch (e) {
      // Ignore errors during background refresh
    }
  }
}

/// Extension to add cache options to request options
extension CacheRequestOptionsExtension on RequestOptions {
  /// Set cache options for this request
  RequestOptions withCacheOptions(CacheOptions options) {
    extra[cacheOptionsKey] = options;
    return this;
  }
}
