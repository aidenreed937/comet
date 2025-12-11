import 'package:dio/dio.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/auth_token_manager.dart';
import '../../../../core/storage/key_value_storage.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/login_credentials.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/login_request_dto.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required KeyValueStorage storage,
    required AuthTokenManager tokenManager,
  }) : _remoteDataSource = remoteDataSource,
       _storage = storage,
       _tokenManager = tokenManager;

  final AuthRemoteDataSource _remoteDataSource;
  final KeyValueStorage _storage;
  final AuthTokenManager _tokenManager;

  static const _userKey = 'auth_user';

  @override
  Future<Result<User>> login(LoginCredentials credentials) async {
    try {
      final request = LoginRequestDto(
        email: credentials.email,
        password: credentials.password,
      );

      final response = await _remoteDataSource.login(request);

      // Save tokens
      await _tokenManager.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );

      // Save user data
      final user = response.user.toEntity();
      await _storage.setString(_userKey, response.user.toJson().toString());

      return Success(user);
    } on DioException catch (e) {
      return Err(ErrorMapper.mapException(e));
    } catch (e) {
      return Err(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _remoteDataSource.logout();
      await _tokenManager.clearTokens();
      await _storage.remove(_userKey);
      return const Success(null);
    } on DioException catch (e) {
      return Err(ErrorMapper.mapException(e));
    } catch (e) {
      return Err(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<User?>> getCurrentUser() async {
    try {
      final userStr = await _storage.getString(_userKey);
      if (userStr == null) {
        return const Success(null);
      }
      // Note: In production, parse JSON properly
      return const Success(null);
    } catch (e) {
      return Err(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final accessToken = await _tokenManager.getAccessToken();
    return accessToken != null;
  }
}
