import 'package:dio/dio.dart';
import 'package:multi_catalog_system/core/config/networks/base_remote_data_source.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/features/category_item/data/models/category_item_model.dart';

abstract class CategoryItemRemoteDataSource {
  Future<List<CategoryItemModel>> getAll({String? search});
  Future<CategoryItemModel> getById(String id);
  Future<CategoryItemModel> create(CategoryItemModel entry);
  Future<List<CategoryItemModel>> createMany(List<CategoryItemModel> entries);
  Future<List<CategoryItemModel>> upsertMany(List<CategoryItemModel> entries);
  Future<CategoryItemModel> update(CategoryItemModel entry);
  Future<void> delete(String id);
}

class CategoryItemRemoteDataSourceImpl extends BaseRemoteDataSource
    implements CategoryItemRemoteDataSource {
  final Dio dio;

  CategoryItemRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CategoryItemModel>> getAll({String? search}) async {
    try {
      final queryParams = <String, dynamic>{};

      if (search != null) queryParams['search'] = search;

      final response = await dio.get(
        '/category-item',
        queryParameters: queryParams,
      );

      final List<dynamic> jsonList = response.data['data']['data'];
      return jsonList.map((json) => CategoryItemModel.fromJson(json)).toList();
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<CategoryItemModel> getById(String id) async {
    try {
      final response = await dio.get('/category-item/$id');
      return CategoryItemModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<CategoryItemModel> create(CategoryItemModel entry) async {
    try {
      final data = entry.toJson()
        ..remove('id')
        ..remove('group');
      final response = await dio.post('/category-item', data: data);
      return CategoryItemModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<List<CategoryItemModel>> createMany(
    List<CategoryItemModel> entries,
  ) async {
    try {
      final data = entries.map((e) => e.toJson()).toList();
      final response = await dio.post('/category-item/bulk', data: data);
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => CategoryItemModel.fromJson(json)).toList();
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<List<CategoryItemModel>> upsertMany(
    List<CategoryItemModel> entries,
  ) async {
    try {
      final data = entries.map((e) => e.toJson()).toList();
      final response = await dio.post('/category-item/bulk/upsert', data: data);
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => CategoryItemModel.fromJson(json)).toList();
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<CategoryItemModel> update(CategoryItemModel entry) async {
    try {
      final response = await dio.patch(
        '/category-item/${entry.id}',
        data: entry.toJson(),
      );
      return CategoryItemModel.fromJson(response.data['data']);
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
      await dio.delete('/category-item/$id');
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }
}
