import 'package:dio/dio.dart';
import 'package:multi_catalog_system/core/config/networks/base_remote_data_source.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/features/api_key_management/data/models/api_key_model.dart';

abstract class ApiKeyRemoteDataSource {
  Future<List<ApiKeyModel>> getAll({String? search});
  Future<ApiKeyModel> getById(String id);
  Future<ApiKeyModel> create(ApiKeyModel entry);
  Future<List<ApiKeyModel>> createMany(List<ApiKeyModel> entries);
  Future<List<ApiKeyModel>> upsertMany(List<ApiKeyModel> entries);
  Future<ApiKeyModel> update(ApiKeyModel entry);
  Future<void> delete(String id);
}

class ApiKeyRemoteDataSourceImpl extends BaseRemoteDataSource
    implements ApiKeyRemoteDataSource {
  final Dio dio;

  ApiKeyRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ApiKeyModel>> getAll({String? search}) async {
    try {
      final queryParams = <String, dynamic>{};

      if (search != null) queryParams['search'] = search;

      final response = await dio.get('/api-key', queryParameters: queryParams);

      final List<dynamic> jsonList = response.data['data']['data'];
      return jsonList.map((json) => ApiKeyModel.fromJson(json)).toList();
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<ApiKeyModel> getById(String id) async {
    try {
      final response = await dio.get('/api-key/$id');
      return ApiKeyModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<ApiKeyModel> create(ApiKeyModel entry) async {
    try {
      final data = entry.toJson()..remove('id');
      final response = await dio.post('/api-key', data: data);
      return ApiKeyModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<List<ApiKeyModel>> createMany(List<ApiKeyModel> entries) async {
    try {
      final data = entries.map((e) => e.toJson()).toList();
      final response = await dio.post('/api-key/bulk', data: data);
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => ApiKeyModel.fromJson(json)).toList();
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<List<ApiKeyModel>> upsertMany(List<ApiKeyModel> entries) async {
    try {
      final data = entries.map((e) => e.toJson()).toList();
      final response = await dio.post('/api-key/bulk/upsert', data: data);
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => ApiKeyModel.fromJson(json)).toList();
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<ApiKeyModel> update(ApiKeyModel entry) async {
    try {
      final response = await dio.patch(
        '/api-key/${entry.id}',
        data: entry.toJson(),
      );
      return ApiKeyModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await dio.delete('/api-key/$id');
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }
}
