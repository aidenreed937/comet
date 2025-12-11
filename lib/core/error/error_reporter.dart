import '../utils/logger.dart';
import 'failure.dart';

abstract class ErrorReporter {
  Future<void> reportError(Object error, StackTrace? stackTrace);
  Future<void> reportFailure(Failure failure);
}

class DefaultErrorReporter implements ErrorReporter {
  const DefaultErrorReporter();

  @override
  Future<void> reportError(Object error, StackTrace? stackTrace) async {
    Logger.e('Error reported: $error', stackTrace: stackTrace);
  }

  @override
  Future<void> reportFailure(Failure failure) async {
    Logger.e('Failure reported: ${failure.message}');
  }
}
