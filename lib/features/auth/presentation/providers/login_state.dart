import '../../domain/entities/user.dart';

/// Login state sealed class
sealed class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  final User user;

  const LoginSuccess(this.user);
}

class LoginFailure extends LoginState {
  final String message;

  const LoginFailure(this.message);
}
