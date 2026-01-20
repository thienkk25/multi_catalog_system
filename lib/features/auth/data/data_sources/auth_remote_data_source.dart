import 'package:dio/dio.dart';
import 'package:multi_catalog_system/core/config/networks/base_remote_data_source.dart';
import 'package:multi_catalog_system/core/data/models/auth/session_model.dart';
import 'package:multi_catalog_system/core/data/models/auth/user_model.dart';
import 'package:multi_catalog_system/core/data/models/role/role_model.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';

abstract class AuthRemoteDataSource {
  Future<SessionModel> login({required String email, required String pass});
  Future<UserModel> getCurrentUser();
  Future<SessionModel> refreshToken({required String refreshToken});
  Future<void> logout();
  Future<RoleModel?> getRole({required String accessToken});
}

class AuthRemoteDataSourceImpl extends BaseRemoteDataSource
    implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  // Override để xử lý RIÊNG auth 401
  @override
  Never handleDioError(DioException e) {
    final status = e.response?.statusCode;
    final data = e.response?.data;

    final message = data is Map<String, dynamic> && data['message'] != null
        ? data['message'].toString()
        : 'Có lỗi xảy ra';

    if (status == 401) {
      throw InvalidCredentialsException(message: message);
    }

    super.handleDioError(e);
  }

  @override
  Future<SessionModel> login({
    required String email,
    required String pass,
  }) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {'email': email, 'password': pass},
      );

      return SessionModel.fromJson(response.data['data']['session']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await dio.get('/user');

      return UserModel.fromJson(response.data['data']['user']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<SessionModel> refreshToken({required String refreshToken}) async {
    try {
      final response = await dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},

        options: Options(headers: {'Authorization': null}),
      );

      return SessionModel.fromJson(response.data['data']['session']);
    } on DioException catch (e) {
      handleDioError(e);
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
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<RoleModel?> getRole({required String accessToken}) async {
    try {
      final response = await dio.get(
        '/user/role',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      final roleJson = response.data['data']['role'];
      if (roleJson == null) return null;

      return RoleModel.fromJson(roleJson);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }
}
