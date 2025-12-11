import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/login_credentials.dart';
import 'auth_providers.dart';
import 'login_state.dart';

class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginInitial();

  Future<void> login({required String email, required String password}) async {
    state = const LoginLoading();

    final credentials = LoginCredentials(email: email, password: password);

    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.login(credentials);

    state = result.when(
      success: LoginSuccess.new,
      failure: (failure) => LoginFailure(failure.message),
    );
  }

  void reset() {
    state = const LoginInitial();
  }
}
