/// Authentication field validators (pure Dart, no Flutter dependency)
class AuthValidators {
  AuthValidators._();

  static const int minPasswordLength = 6;

  static final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  /// Validates email format
  /// Returns null if valid, otherwise returns error type
  static EmailValidationError? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return EmailValidationError.required;
    }
    if (!_emailRegex.hasMatch(value)) {
      return EmailValidationError.invalidFormat;
    }
    return null;
  }

  /// Validates password
  /// Returns null if valid, otherwise returns error type
  static PasswordValidationError? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return PasswordValidationError.required;
    }
    if (value.length < minPasswordLength) {
      return PasswordValidationError.tooShort;
    }
    return null;
  }
}

/// Email validation error types
enum EmailValidationError { required, invalidFormat }

/// Password validation error types
enum PasswordValidationError { required, tooShort }
