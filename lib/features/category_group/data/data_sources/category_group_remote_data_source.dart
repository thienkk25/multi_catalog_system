import 'package:dio/dio.dart';
import 'package:multi_catalog_system/core/config/networks/base_remote_data_source.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/features/category_group/data/models/category_group_model.dart';

abstract class CategoryGroupRemoteDataSource {
  Future<List<CategoryGroupModel>> getAll({String? search});
  Future<CategoryGroupModel> getById(String id);
  Future<CategoryGroupModel> create(CategoryGroupModel entry);
  Future<List<CategoryGroupModel>> createMany(List<CategoryGroupModel> entries);
  Future<List<CategoryGroupModel>> upsertMany(List<CategoryGroupModel> entries);
  Future<CategoryGroupModel> update(CategoryGroupModel entry);
  Future<void> delete(String id);
}

class CategoryGroupRemoteDataSourceImpl extends BaseRemoteDataSource
    implements CategoryGroupRemoteDataSource {
  final Dio dio;

  CategoryGroupRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CategoryGroupModel>> getAll({String? search}) async {
    try {
      final queryParams = <String, dynamic>{};

      if (search != null) queryParams['search'] = search;

      final response = await dio.get('/domain', queryParameters: queryParams);

      final List<dynamic> jsonList = response.data['data']['data'];
      return jsonList.map((json) => CategoryGroupModel.fromJson(json)).toList();
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<CategoryGroupModel> getById(String id) async {
    try {
      final response = await dio.get('/domain/$id');
      return CategoryGroupModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<CategoryGroupModel> create(CategoryGroupModel entry) async {
    try {
      final data = entry.toJson()..remove('id');
      final response = await dio.post('/domain', data: data);
      return CategoryGroupModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<List<CategoryGroupModel>> createMany(
    List<CategoryGroupModel> entries,
  ) async {
    try {
      final data = entries.map((e) => e.toJson()).toList();
      final response = await dio.post('/domain/bulk', data: data);
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => CategoryGroupModel.fromJson(json)).toList();
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<List<CategoryGroupModel>> upsertMany(
    List<CategoryGroupModel> entries,
  ) async {
    try {
      final data = entries.map((e) => e.toJson()).toList();
      final response = await dio.post('/domain/bulk/upsert', data: data);
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => CategoryGroupModel.fromJson(json)).toList();
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<CategoryGroupModel> update(CategoryGroupModel entry) async {
    try {
      final response = await dio.put(
        '/domain/${entry.id}',
        data: entry.toJson(),
      );
      return CategoryGroupModel.fromJson(response.data['data']);
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
      await dio.delete('/domain/$id');
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }
}
