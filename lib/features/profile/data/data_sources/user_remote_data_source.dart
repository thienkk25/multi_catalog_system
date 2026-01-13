import 'package:dio/dio.dart';
import 'package:multi_catalog_system/core/config/networks/base_remote_data_source.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/features/profile/data/models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getMe();
  Future<UserModel> getUser();
  Future<UserModel> changePassword({required Map<String, dynamic> data});
  Future<UserModel> updatePhone({required Map<String, dynamic> data});
  Future<UserModel> updateFullName({required Map<String, dynamic> data});
}

class UserRemoteDataSourceImpl extends BaseRemoteDataSource
    implements UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSourceImpl({required this.dio});

  Map<String, dynamic> _fromResponse(Response response) {
    if (response.data is! Map<String, dynamic>) {
      throw UnexpectedException('Invalid response format');
    }
    if (!response.data.containsKey('data') ||
        response.data['data'] is! Map<String, dynamic>) {
      throw UnexpectedException('Missing or invalid data field in response');
    }
    final data = response.data['data'] as Map<String, dynamic>;
    return {
      'id': data['user']['id'],
      'full_name': data['user']['user_metadata']['full_name'] ?? '',
      'phone': data['user']['user_metadata']['phone'] ?? '',
      'email': data['user']['email'],
      'created_at': data['user']['created_at'],
      'updated_at': data['user']['updated_at'],
    };
  }

  @override
  Future<UserModel> changePassword({required Map<String, dynamic> data}) async {
    try {
      final response = await dio.post('/user/change-password', data: data);
      return UserModel.fromJson(_fromResponse(response));
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<UserModel> getMe() async {
    try {
      final response = await dio.get('/user/me');
      return UserModel.fromJson(_fromResponse(response));
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<UserModel> getUser() async {
    try {
      final response = await dio.get('/user/');
      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<UserModel> updateFullName({required Map<String, dynamic> data}) async {
    try {
      final response = await dio.patch('/user/update-fullname', data: data);
      return UserModel.fromJson(_fromResponse(response));
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<UserModel> updatePhone({required Map<String, dynamic> data}) async {
    try {
      final response = await dio.patch('/user/update-phone', data: data);
      return UserModel.fromJson(_fromResponse(response));
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }
}
