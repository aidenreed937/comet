import 'dart:io';

import 'package:comet/core/error/error_mapper.dart';
import 'package:comet/core/error/failure.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ErrorMapper', () {
    group('mapException', () {
      test('maps SocketException to network failure', () {
        const exception = SocketException('No internet');
        final failure = ErrorMapper.mapException(exception);

        expect(failure.type, equals(FailureType.network));
        expect(failure.message, equals('No internet connection'));
      });

      test('maps FormatException to server failure', () {
        const exception = FormatException('Invalid JSON');
        final failure = ErrorMapper.mapException(exception);

        expect(failure.type, equals(FailureType.server));
        expect(failure.message, equals('Invalid data format'));
      });

      test('maps unknown exception to unknown failure', () {
        final exception = Exception('Unknown error');
        final failure = ErrorMapper.mapException(exception);

        expect(failure.type, equals(FailureType.unknown));
      });
    });

    group('DioException mapping', () {
      test('maps connectionTimeout to network failure', () {
        final exception = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(),
        );
        final failure = ErrorMapper.mapException(exception);

        expect(failure.type, equals(FailureType.network));
        expect(failure.message, equals('Connection timeout'));
      });

      test('maps sendTimeout to network failure', () {
        final exception = DioException(
          type: DioExceptionType.sendTimeout,
          requestOptions: RequestOptions(),
        );
        final failure = ErrorMapper.mapException(exception);

        expect(failure.type, equals(FailureType.network));
        expect(failure.message, equals('Connection timeout'));
      });

      test('maps receiveTimeout to network failure', () {
        final exception = DioException(
          type: DioExceptionType.receiveTimeout,
          requestOptions: RequestOptions(),
        );
        final failure = ErrorMapper.mapException(exception);

        expect(failure.type, equals(FailureType.network));
        expect(failure.message, equals('Connection timeout'));
      });

      test('maps connectionError to network failure', () {
        final exception = DioException(
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions(),
        );
        final failure = ErrorMapper.mapException(exception);

        expect(failure.type, equals(FailureType.network));
        expect(failure.message, equals('Connection error'));
      });

      test('maps cancel to network failure', () {
        final exception = DioException(
          type: DioExceptionType.cancel,
          requestOptions: RequestOptions(),
        );
        final failure = ErrorMapper.mapException(exception);

        expect(failure.type, equals(FailureType.network));
        expect(failure.message, equals('Request cancelled'));
      });

      test('maps badCertificate to network failure', () {
        final exception = DioException(
          type: DioExceptionType.badCertificate,
          requestOptions: RequestOptions(),
        );
        final failure = ErrorMapper.mapException(exception);

        expect(failure.type, equals(FailureType.network));
        expect(failure.message, equals('Invalid certificate'));
      });
    });

    group('HTTP status code mapping', () {
      test('maps 400 to validation failure', () {
        final exception = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(),
          response: Response(statusCode: 400, requestOptions: RequestOptions()),
        );
        final failure = ErrorMapper.mapException(exception);

        expect(failure.type, equals(FailureType.validation));
        expect(failure.message, equals('Bad request'));
      });

      test('maps 401 to authentication failure', () {
        final exception = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(),
          response: Response(statusCode: 401, requestOptions: RequestOptions()),
        );
        final failure = ErrorMapper.mapException(exception);

        expect(failure.type, equals(FailureType.authentication));
      });

      test('maps 403 to authorization failure', () {
        final exception = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(),
          response: Response(statusCode: 403, requestOptions: RequestOptions()),
        );
        final failure = ErrorMapper.mapException(exception);

        expect(failure.type, equals(FailureType.authorization));
      });

      test('maps 404 to notFound failure', () {
        final exception = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(),
          response: Response(statusCode: 404, requestOptions: RequestOptions()),
        );
        final failure = ErrorMapper.mapException(exception);

        expect(failure.type, equals(FailureType.notFound));
      });

      test('maps 500 to server failure', () {
        final exception = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(),
          response: Response(statusCode: 500, requestOptions: RequestOptions()),
        );
        final failure = ErrorMapper.mapException(exception);

        expect(failure.type, equals(FailureType.server));
        expect(failure.code, equals('500'));
      });

      test('maps 502 to server failure', () {
        final exception = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(),
          response: Response(statusCode: 502, requestOptions: RequestOptions()),
        );
        final failure = ErrorMapper.mapException(exception);

        expect(failure.type, equals(FailureType.server));
        expect(failure.code, equals('502'));
      });

      test('maps 503 to server failure', () {
        final exception = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(),
          response: Response(statusCode: 503, requestOptions: RequestOptions()),
        );
        final failure = ErrorMapper.mapException(exception);

        expect(failure.type, equals(FailureType.server));
        expect(failure.code, equals('503'));
      });

      test('maps unknown status code to server failure', () {
        final exception = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(),
          response: Response(statusCode: 418, requestOptions: RequestOptions()),
        );
        final failure = ErrorMapper.mapException(exception);

        expect(failure.type, equals(FailureType.server));
        expect(failure.message, equals('Unexpected error'));
      });
    });
  });
}
