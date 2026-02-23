import 'package:dio/dio.dart';
import 'package:multi_catalog_system/core/config/networks/base_remote_data_source.dart';
import 'package:multi_catalog_system/core/data/models/auth/user_profile_model.dart';
import 'package:multi_catalog_system/core/data/models/page/page_model.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';

abstract class UserManagementRemoteDataSource {
  Future<PageModel<UserProfileModel>> getAll({
    String? search,
    int? page,
    int? limit,
    String? sortBy,
    String? sort,
    Map<String, dynamic>? filter,
  });
  Future<UserProfileModel> create({required Map<String, dynamic> data});
  Future<UserProfileModel> update({
    required String id,
    required Map<String, dynamic> data,
  });
  Future<UserProfileModel> getById({required String id});
  Future<void> delete({required String id});
  Future<UserProfileModel> activate({required String id});
  Future<UserProfileModel> deactivate({required String id});
  Future<UserProfileModel> grantAccess({required Map<String, dynamic> data});
}

class UserManagementRemoteDataSourceImpl extends BaseRemoteDataSource
    implements UserManagementRemoteDataSource {
  final Dio dio;

  UserManagementRemoteDataSourceImpl({required this.dio});

  @override
  Future<PageModel<UserProfileModel>> getAll({
    String? search,
    int? page,
    int? limit,
    String? sortBy,
    String? sort,
    Map<String, dynamic>? filter,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (search != null) queryParams['search'] = search;
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;
      if (sortBy != null) queryParams['sortBy'] = sortBy;
      if (sort != null) queryParams['sort'] = sort;
      if (filter != null) queryParams['filter'] = filter;

      final response = await dio.get(
        '/admin/users',
        queryParameters: queryParams,
      );
      final data = response.data['data'];
      return PageModel<UserProfileModel>.fromJson(
        data,
        (e) => UserProfileModel.fromJson(e as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<UserProfileModel> getById({required String id}) async {
    try {
      final response = await dio.get('/admin/users/$id');
      return UserProfileModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<UserProfileModel> create({required Map<String, dynamic> data}) async {
    try {
      final response = await dio.post('/admin/users', data: data);
      return UserProfileModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<UserProfileModel> update({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await dio.patch('/admin/users/$id', data: data);
      return UserProfileModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<void> delete({required String id}) async {
    try {
      await dio.delete('/admin/users/$id');
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<UserProfileModel> activate({required String id}) async {
    try {
      final response = await dio.patch('/admin/users/$id/activate');
      return UserProfileModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<UserProfileModel> deactivate({required String id}) async {
    try {
      final response = await dio.patch('/admin/users/$id/deactivate');
      return UserProfileModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<UserProfileModel> grantAccess({
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await dio.post('/admin/users/grant-access', data: data);
      return UserProfileModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }
}
