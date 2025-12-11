import 'dart:io';

import 'package:dio/dio.dart';

import 'failure.dart';

class ErrorMapper {
  const ErrorMapper._();

  static Failure mapException(Object exception, [StackTrace? stackTrace]) {
    if (exception is DioException) {
      return _mapDioException(exception);
    }

    if (exception is SocketException) {
      return Failure.network(message: 'No internet connection');
    }

    if (exception is FormatException) {
      return Failure.server(message: 'Invalid data format');
    }

    return Failure.unknown(
      message: exception.toString(),
      stackTrace: stackTrace,
    );
  }

  static Failure _mapDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Failure.network(message: 'Connection timeout');
      case DioExceptionType.connectionError:
        return Failure.network(message: 'Connection error');
      case DioExceptionType.badResponse:
        return _mapStatusCode(exception.response?.statusCode);
      case DioExceptionType.cancel:
        return Failure.network(message: 'Request cancelled');
      case DioExceptionType.badCertificate:
        return Failure.network(message: 'Invalid certificate');
      case DioExceptionType.unknown:
        return Failure.unknown(message: exception.message);
    }
  }

  static Failure _mapStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return Failure.validation(message: 'Bad request');
      case 401:
        return Failure.authentication();
      case 403:
        return Failure.authorization();
      case 404:
        return Failure.notFound();
      case 500:
      case 502:
      case 503:
        return Failure.server(message: 'Server error', code: '$statusCode');
      default:
        return Failure.server(message: 'Unexpected error', code: '$statusCode');
    }
  }
}
