import 'package:dio/dio.dart';

import '../models/login_request_dto.dart';
import '../models/login_response_dto.dart';

/// Remote data source for authentication API
abstract class AuthRemoteDataSource {
  Future<LoginResponseDto> login(LoginRequestDto request);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<LoginResponseDto> login(LoginRequestDto request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: request.toJson(),
    );

    if (response.data == null) {
      throw Exception('Login response is null');
    }

    return LoginResponseDto.fromJson(response.data!);
  }

  @override
  Future<void> logout() async {
    await _dio.post<void>('/auth/logout');
  }
}
