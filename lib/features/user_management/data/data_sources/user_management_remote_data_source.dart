import 'package:dio/dio.dart';
import 'package:multi_catalog_system/core/config/networks/base_remote_data_source.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/features/user_management/data/models/user_management_model.dart';

abstract class UserManagementRemoteDataSource {
  Future<List<UserManagementModel>> getAll({String? search});
  Future<UserManagementModel> create({required Map<String, dynamic> data});
  Future<UserManagementModel> update({
    required String id,
    required Map<String, dynamic> data,
  });
  Future<UserManagementModel> getById({required String id});
  Future<void> delete({required String id});
  Future<UserManagementModel> activate({required String id});
  Future<UserManagementModel> deactivate({required String id});
}

class UserManagementRemoteDataSourceImpl extends BaseRemoteDataSource
    implements UserManagementRemoteDataSource {
  final Dio dio;

  UserManagementRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<UserManagementModel>> getAll({String? search}) async {
    try {
      final queryParams = <String, dynamic>{};

      if (search != null) queryParams['search'] = search;

      final response = await dio.get(
        '/admin/users',
        queryParameters: queryParams,
      );
      final List<dynamic> jsonList = response.data['data']['data'];
      return jsonList
          .map((json) => UserManagementModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<UserManagementModel> getById({required String id}) async {
    try {
      final response = await dio.get('/admin/users/$id');
      return UserManagementModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<UserManagementModel> create({
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await dio.post('/admin/users', data: data);
      return UserManagementModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<UserManagementModel> update({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await dio.patch('/admin/users/$id', data: data);
      return UserManagementModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<void> delete({required String id}) async {
    try {
      await dio.delete('/admin/users/$id');
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<UserManagementModel> activate({required String id}) async {
    try {
      final response = await dio.patch('/admin/users/$id/activate');
      return UserManagementModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<UserManagementModel> deactivate({required String id}) async {
    try {
      final response = await dio.patch('/admin/users/$id/deactivate');
      return UserManagementModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }
}
