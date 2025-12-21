import 'package:dio/dio.dart';
import 'package:multi_catalog_system/core/config/networks/base_remote_data_source.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/features/auth/data/models/user_model.dart';
import 'package:multi_catalog_system/features/auth/data/models/auth_response_model.dart';
import 'package:multi_catalog_system/features/auth/data/models/user_role_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login({
    required String email,
    required String pass,
  });

  Future<UserModel> getCurrentUser();

  Future<AuthResponseModel> refreshToken({required String refreshToken});

  Future<void> logout();

  Future<UserRoleModel> getRole(String accessToken);
}

class AuthRemoteDataSourceImpl extends BaseRemoteDataSource
    implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  /// Override handleDioError để bắt riêng Auth 401
  @override
  Never handleDioError(DioException e) {
    if (e.response?.statusCode == 401) {
      throw const InvalidCredentialsException();
    }
    return super.handleDioError(e);
  }

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String pass,
  }) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {'email': email, 'password': pass},
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const ParseException();
      }

      if (data['success'] == false) {
        throw InvalidCredentialsException();
      }

      final session = data['data']?['session'];
      if (session == null) {
        throw const ParseException();
      }

      final json = {
        'access_token': session['access_token'],
        'refresh_token': session['refresh_token'],
        'user': {
          'id': session['user']['id'],
          'email': session['user']['email'],
          'full_name': session['user']['user_metadata']?['full_name'] ?? '',
          'phone': session['user']['user_metadata']?['phone'] ?? '',
          'status': session['user']['user_metadata']?['status'] ?? '',
          'created_at': session['user']['created_at'],
          'updated_at': session['user']['updated_at'],
        },
      };

      return AuthResponseModel.fromJson(json);
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await dio.get('/user');

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const ParseException();
      }

      if (data['success'] == false) {
        throw const ParseException();
      }

      final userJson = data['data'];
      if (userJson == null) {
        throw const ParseException();
      }

      return UserModel.fromJson(userJson);
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<AuthResponseModel> refreshToken({required String refreshToken}) async {
    try {
      final response = await dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
        options: Options(headers: {'Authorization': null}),
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const ParseException();
      }

      return AuthResponseModel.fromJson(data);
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dio.post('/auth/logout');
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<UserRoleModel> getRole(String accessToken) async {
    try {
      final response = await dio.get(
        '/user/role',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.data is! Map<String, dynamic>) {
        throw const ParseException();
      }

      if (response.data['success'] == false) {
        throw const ParseException();
      }

      return UserRoleModel.fromJson(response.data['data']['role']);
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }
}
