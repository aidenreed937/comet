enum FailureType {
  network,
  server,
  cache,
  validation,
  authentication,
  authorization,
  notFound,
  unknown,
}

class Failure {
  const Failure({
    required this.message,
    this.type = FailureType.unknown,
    this.code,
    this.stackTrace,
  });

  factory Failure.network({String? message}) => Failure(
    message: message ?? 'Network error occurred',
    type: FailureType.network,
  );

  factory Failure.server({String? message, String? code}) => Failure(
    message: message ?? 'Server error occurred',
    type: FailureType.server,
    code: code,
  );

  factory Failure.cache({String? message}) => Failure(
    message: message ?? 'Cache error occurred',
    type: FailureType.cache,
  );

  factory Failure.validation({required String message}) =>
      Failure(message: message, type: FailureType.validation);

  factory Failure.authentication({String? message}) => Failure(
    message: message ?? 'Authentication failed',
    type: FailureType.authentication,
  );

  factory Failure.authorization({String? message}) => Failure(
    message: message ?? 'Access denied',
    type: FailureType.authorization,
  );

  factory Failure.notFound({String? message}) => Failure(
    message: message ?? 'Resource not found',
    type: FailureType.notFound,
  );

  factory Failure.unknown({String? message, StackTrace? stackTrace}) => Failure(
    message: message ?? 'An unknown error occurred',
    stackTrace: stackTrace,
  );

  final String message;
  final FailureType type;
  final String? code;
  final StackTrace? stackTrace;

  @override
  String toString() => 'Failure(type: $type, message: $message, code: $code)';
}
