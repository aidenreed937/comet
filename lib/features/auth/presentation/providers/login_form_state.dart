import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Login form UI state
class LoginFormState {
  const LoginFormState({
    this.email = '',
    this.password = '',
    this.obscurePassword = true,
  });

  final String email;
  final String password;
  final bool obscurePassword;

  LoginFormState copyWith({
    String? email,
    String? password,
    bool? obscurePassword,
  }) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }
}

/// Login form state notifier
class LoginFormNotifier extends Notifier<LoginFormState> {
  @override
  LoginFormState build() => const LoginFormState();

  void setEmail(String value) {
    state = state.copyWith(email: value);
  }

  void setPassword(String value) {
    state = state.copyWith(password: value);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  void reset() {
    state = const LoginFormState();
  }
}

/// Login form state provider
final loginFormProvider = NotifierProvider<LoginFormNotifier, LoginFormState>(
  LoginFormNotifier.new,
);
