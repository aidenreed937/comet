import 'package:comet/core/error/failure.dart';
import 'package:comet/core/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result', () {
    group('Success', () {
      test('isSuccess should return true', () {
        const result = Success<int>(42);
        expect(result.isSuccess, isTrue);
        expect(result.isFailure, isFalse);
      });

      test('valueOrNull should return value', () {
        const result = Success<int>(42);
        expect(result.valueOrNull, equals(42));
      });

      test('failureOrNull should return null', () {
        const result = Success<int>(42);
        expect(result.failureOrNull, isNull);
      });

      test('when should call success callback', () {
        const result = Success<int>(42);
        final value = result.when(success: (v) => v * 2, failure: (f) => -1);
        expect(value, equals(84));
      });

      test('map should transform value', () {
        const result = Success<int>(42);
        final mapped = result.map((v) => v.toString());
        expect(mapped, isA<Success<String>>());
        expect((mapped as Success<String>).value, equals('42'));
      });

      test('getOrElse should return value', () {
        const result = Success<int>(42);
        expect(result.getOrElse(() => 0), equals(42));
      });

      test('getOrThrow should return value', () {
        const result = Success<int>(42);
        expect(result.getOrThrow(), equals(42));
      });
    });

    group('Err', () {
      final failure = Failure.network(message: 'Network error');

      test('isSuccess should return false', () {
        final result = Err<int>(failure);
        expect(result.isSuccess, isFalse);
        expect(result.isFailure, isTrue);
      });

      test('valueOrNull should return null', () {
        final result = Err<int>(failure);
        expect(result.valueOrNull, isNull);
      });

      test('failureOrNull should return failure', () {
        final result = Err<int>(failure);
        expect(result.failureOrNull, equals(failure));
      });

      test('when should call failure callback', () {
        final result = Err<int>(failure);
        final value = result.when(success: (v) => v * 2, failure: (f) => -1);
        expect(value, equals(-1));
      });

      test('map should preserve failure', () {
        final result = Err<int>(failure);
        final mapped = result.map((v) => v.toString());
        expect(mapped, isA<Err<String>>());
        expect((mapped as Err<String>).failure, equals(failure));
      });

      test('getOrElse should return default value', () {
        final result = Err<int>(failure);
        expect(result.getOrElse(() => 0), equals(0));
      });

      test('getOrThrow should throw exception', () {
        final result = Err<int>(failure);
        expect(result.getOrThrow, throwsException);
      });
    });

    group('flatMap', () {
      test('Success flatMap should chain results', () {
        const result = Success<int>(42);
        final chained = result.flatMap((v) => Success(v.toString()));
        expect(chained, isA<Success<String>>());
        expect((chained as Success<String>).value, equals('42'));
      });

      test('Err flatMap should preserve failure', () {
        final failure = Failure.network();
        final result = Err<int>(failure);
        final chained = result.flatMap((v) => Success(v.toString()));
        expect(chained, isA<Err<String>>());
      });
    });
  });
}
