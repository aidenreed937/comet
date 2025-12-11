/// Login credentials for authentication
class LoginCredentials {
  const LoginCredentials({required this.email, required this.password});

  final String email;
  final String password;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginCredentials &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          password == other.password;

  @override
  int get hashCode => email.hashCode ^ password.hashCode;

  @override
  String toString() => 'LoginCredentials(email: $email)';
}
