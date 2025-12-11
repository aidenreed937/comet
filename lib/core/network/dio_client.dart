import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../error/error_mapper.dart';
import '../utils/result.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

class DioClient {
  DioClient({Dio? dio}) : _dio = dio ?? _createDio();

  final Dio _dio;

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.env.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([AuthInterceptor(), LoggingInterceptor()]);

    return dio;
  }

  Future<Result<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic data)? parser,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      final data = parser != null ? parser(response.data) : response.data as T;
      return Success(data);
    } catch (e, stackTrace) {
      return Err(ErrorMapper.mapException(e, stackTrace));
    }
  }

  Future<Result<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic data)? parser,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      final result =
          parser != null ? parser(response.data) : response.data as T;
      return Success(result);
    } catch (e, stackTrace) {
      return Err(ErrorMapper.mapException(e, stackTrace));
    }
  }

  Future<Result<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic data)? parser,
  }) async {
    try {
      final response = await _dio.put<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      final result =
          parser != null ? parser(response.data) : response.data as T;
      return Success(result);
    } catch (e, stackTrace) {
      return Err(ErrorMapper.mapException(e, stackTrace));
    }
  }

  Future<Result<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic data)? parser,
  }) async {
    try {
      final response = await _dio.delete<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      final result =
          parser != null ? parser(response.data) : response.data as T;
      return Success(result);
    } catch (e, stackTrace) {
      return Err(ErrorMapper.mapException(e, stackTrace));
    }
  }
}
