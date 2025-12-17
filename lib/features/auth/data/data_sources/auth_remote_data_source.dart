import 'package:dio/dio.dart';
import 'package:multi_catalog_system/core/config/constants/app_constant.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
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

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String pass,
  }) async {
    final response = await dio.post(
      '${AppConstant.apiBaseUrl}/auth/login',
      data: {'email': email, 'password': pass},
    );
    if (response.data is! Map<String, dynamic>) {
      throw ServerException();
    }
    final data = response.data as Map<String, dynamic>;
    final session = data['data']?['session'];

    if (session == null) {
      throw ServerException();
    }

    final json = {
      'access_token': session['access_token'],
      'refresh_token': session['refresh_token'],
      'user': {
        'id': session['user']['id'],
        'email': session['user']['email'],
        'full_name': session['user']['user_metadata']['full_name'] ?? '',
        'phone': session['user']['user_metadata']['phone'] ?? '',
        'status': session['user']['user_metadata']['status'] ?? '',
        'created_at': session['user']['created_at'],
        'updated_at': session['user']['updated_at'] ?? '',
      },
    };

    return AuthResponseModel.fromJson(json);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final response = await dio.get('${AppConstant.apiBaseUrl}/auth/me');
    return UserModel.fromJson(response.data);
  }

  @override
  Future<AuthResponseModel> refreshToken({required String refreshToken}) async {
    final response = await dio.post(
      '${AppConstant.apiBaseUrl}/auth/refresh',
      data: {'refresh_token': refreshToken},
    );

    return AuthResponseModel.fromJson(response.data);
  }

  @override
  Future<void> logout() async {
    await dio.post('${AppConstant.apiBaseUrl}/auth/logout');
  }
}
