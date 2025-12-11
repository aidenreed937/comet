import '../error/failure.dart';

sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Err<T>;

  T? get valueOrNull => switch (this) {
    Success(value: final v) => v,
    Err() => null,
  };

  Failure? get failureOrNull => switch (this) {
    Success() => null,
    Err(failure: final f) => f,
  };

  R when<R>({
    required R Function(T value) success,
    required R Function(Failure failure) failure,
  }) => switch (this) {
    Success(value: final v) => success(v),
    Err(failure: final f) => failure(f),
  };

  Result<R> map<R>(R Function(T value) transform) => switch (this) {
    Success(value: final v) => Success(transform(v)),
    Err(failure: final f) => Err(f),
  };

  Future<Result<R>> mapAsync<R>(Future<R> Function(T value) transform) async =>
      switch (this) {
        Success(value: final v) => Success(await transform(v)),
        Err(failure: final f) => Err(f),
      };

  Result<R> flatMap<R>(Result<R> Function(T value) transform) => switch (this) {
    Success(value: final v) => transform(v),
    Err(failure: final f) => Err(f),
  };

  T getOrElse(T Function() orElse) => switch (this) {
    Success(value: final v) => v,
    Err() => orElse(),
  };

  T getOrThrow() => switch (this) {
    Success(value: final v) => v,
    Err(failure: final f) => throw Exception('Result is failure: ${f.message}'),
  };
}

final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Success<T> && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Success($value)';
}

final class Err<T> extends Result<T> {
  const Err(this.failure);

  final Failure failure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Err<T> && failure == other.failure;

  @override
  int get hashCode => failure.hashCode;

  @override
  String toString() => 'Err($failure)';
}
