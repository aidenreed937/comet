import 'package:comet/core/error/failure.dart';
import 'package:comet/core/utils/result.dart';
import 'package:comet/features/auth/domain/entities/login_credentials.dart';
import 'package:comet/features/auth/domain/entities/user.dart';
import 'package:comet/features/auth/presentation/providers/auth_providers.dart';
import 'package:comet/features/auth/presentation/providers/login_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/auth_repository_mock.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(
      const LoginCredentials(email: 'test@example.com', password: 'password'),
    );
  });

  group('LoginNotifier', () {
    late ProviderContainer container;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();

      container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(mockRepository)],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state should be LoginInitial', () {
      final state = container.read(loginProvider);
      expect(state, isA<LoginInitial>());
    });

    test('login with valid credentials should emit LoginSuccess', () async {
      final user = User(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
        createdAt: DateTime.now(),
      );
      when(
        () => mockRepository.login(any()),
      ).thenAnswer((_) async => Success(user));

      await container
          .read(loginProvider.notifier)
          .login(email: 'test@example.com', password: 'password');

      final state = container.read(loginProvider);
      expect(state, isA<LoginSuccess>());
      expect((state as LoginSuccess).user, equals(user));
    });

    test('login with invalid credentials should emit LoginFailure', () async {
      const failure = Failure(message: 'Invalid credentials');
      when(
        () => mockRepository.login(any()),
      ).thenAnswer((_) async => const Err(failure));

      await container
          .read(loginProvider.notifier)
          .login(email: 'test@example.com', password: 'wrong');

      final state = container.read(loginProvider);
      expect(state, isA<LoginFailure>());
      expect((state as LoginFailure).message, equals('Invalid credentials'));
    });

    test('reset should set state to LoginInitial', () async {
      final user = User(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
        createdAt: DateTime.now(),
      );
      when(
        () => mockRepository.login(any()),
      ).thenAnswer((_) async => Success(user));

      await container
          .read(loginProvider.notifier)
          .login(email: 'test@example.com', password: 'password');

      expect(container.read(loginProvider), isA<LoginSuccess>());

      container.read(loginProvider.notifier).reset();

      expect(container.read(loginProvider), isA<LoginInitial>());
    });
  });
}
