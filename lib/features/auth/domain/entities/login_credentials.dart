/// Login credentials for authentication
class LoginCredentials {
  final String email;
  final String password;

  const LoginCredentials({required this.email, required this.password});

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
