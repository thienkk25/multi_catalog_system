import 'package:dio/dio.dart';
import 'package:multi_catalog_system/features/auth/data/models/user_model.dart';

import 'package:multi_catalog_system/features/auth/data/models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login({
    required String email,
    required String pass,
  });

  Future<UserModel?> getCurrentUser();

  Future<AuthResponseModel> refreshToken({required String refreshToken});

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({Dio? dio}) : dio = dio ?? Dio();

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String pass,
  }) async {
    final response = await dio.post(
      '/auth/login',
      data: {'email': email, 'password': pass},
    );

    return AuthResponseModel.fromJson(response.data);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final response = await dio.get('/auth/me');
    return UserModel.fromJson(response.data);
  }

  @override
  Future<AuthResponseModel> refreshToken({required String refreshToken}) async {
    final response = await dio.post(
      '/auth/refresh',
      data: {'refresh_token': refreshToken},
    );

    return AuthResponseModel.fromJson(response.data);
  }

  @override
  Future<void> logout() async {
    await dio.post('/auth/logout');
  }
}
