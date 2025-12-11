import '../../../../core/utils/result.dart';
import '../entities/login_credentials.dart';
import '../entities/user.dart';

/// Repository interface for authentication operations
abstract class AuthRepository {
  /// Login with email and password
  Future<Result<User>> login(LoginCredentials credentials);

  /// Logout current user
  Future<Result<void>> logout();

  /// Get current authenticated user
  Future<Result<User?>> getCurrentUser();

  /// Check if user is logged in
  Future<bool> isLoggedIn();
}
