import 'package:dio/dio.dart';
import 'package:multi_catalog_system/core/config/networks/base_remote_data_source.dart';
import 'package:multi_catalog_system/core/data/models/page/page_model.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/features/api_key_management/data/models/api_key_model.dart';

abstract class ApiKeyRemoteDataSource {
  Future<PageModel<ApiKeyModel>> getAll({
    String? search,
    int? page,
    int? limit,
    String? sortBy,
    String? sort,
    Map<String, dynamic>? filter,
  });
  Future<ApiKeyModel> getById({required String id});
  Future<ApiKeyModel> create({required Map<String, dynamic> data});
  Future<ApiKeyModel> revoke({required String id});
  Future<void> delete({required String id});
}

class ApiKeyRemoteDataSourceImpl extends BaseRemoteDataSource
    implements ApiKeyRemoteDataSource {
  final Dio dio;

  ApiKeyRemoteDataSourceImpl({required this.dio});

  @override
  Future<PageModel<ApiKeyModel>> getAll({
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

      final response = await dio.get('/api-key', queryParameters: queryParams);

      final data = response.data['data'];

      return PageModel<ApiKeyModel>.fromJson(
        data,
        (e) => ApiKeyModel.fromJson(e as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<ApiKeyModel> getById({required String id}) async {
    try {
      final response = await dio.get('/api-key/$id');
      return ApiKeyModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<ApiKeyModel> create({required Map<String, dynamic> data}) async {
    try {
      final response = await dio.post('/api-key', data: data);
      return ApiKeyModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<ApiKeyModel> revoke({required String id}) async {
    try {
      final response = await dio.patch('/api-key/$id');
      return ApiKeyModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<void> delete({required String id}) async {
    try {
      await dio.delete('/api-key/$id');
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }
}
