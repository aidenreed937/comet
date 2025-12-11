import 'package:comet/core/error/failure.dart';
import 'package:comet/core/utils/result.dart';
import 'package:comet/features/auth/domain/entities/login_credentials.dart';
import 'package:comet/features/auth/domain/entities/user.dart';
import 'package:comet/features/auth/domain/repositories/auth_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void setupMockAuthRepositorySuccess(MockAuthRepository mock) {
  final user = User(
    id: '123',
    email: 'test@example.com',
    name: 'Test User',
    createdAt: DateTime.now(),
  );

  when(() => mock.login(any())).thenAnswer((_) async => Success(user));
  when(() => mock.logout()).thenAnswer((_) async => const Success(null));
  when(() => mock.getCurrentUser()).thenAnswer((_) async => Success(user));
  when(() => mock.isLoggedIn()).thenAnswer((_) async => true);
}

void setupMockAuthRepositoryFailure(MockAuthRepository mock) {
  final failure = Failure.authentication();

  when(() => mock.login(any())).thenAnswer((_) async => Err(failure));
  when(() => mock.logout()).thenAnswer((_) async => Err(failure));
  when(
    () => mock.getCurrentUser(),
  ).thenAnswer((_) async => const Success(null));
  when(() => mock.isLoggedIn()).thenAnswer((_) async => false);
}

void registerFallbackValues() {
  registerFallbackValue(
    const LoginCredentials(email: 'test@example.com', password: 'password'),
  );
}
