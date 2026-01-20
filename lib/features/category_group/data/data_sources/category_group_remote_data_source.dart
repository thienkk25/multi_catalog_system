import 'package:dio/dio.dart';
import 'package:multi_catalog_system/core/config/networks/base_remote_data_source.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/features/category_group/data/models/category_group_model.dart';

abstract class CategoryGroupRemoteDataSource {
  Future<List<CategoryGroupModel>> getAll({String? search});
  Future<CategoryGroupModel> getById({required String id});
  Future<CategoryGroupModel> create({required Map<String, dynamic> data});
  Future<List<CategoryGroupModel>> createMany({
    required List<Map<String, dynamic>> data,
  });
  Future<List<CategoryGroupModel>> upsertMany({
    required List<Map<String, dynamic>> data,
  });
  Future<CategoryGroupModel> update({
    required String id,
    required Map<String, dynamic> data,
  });
  Future<void> delete({required String id});
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

      final response = await dio.get(
        '/category-group',
        queryParameters: queryParams,
      );

      final List<dynamic> jsonList = response.data['data']['data'];
      return jsonList.map((json) => CategoryGroupModel.fromJson(json)).toList();
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<CategoryGroupModel> getById({required String id}) async {
    try {
      final response = await dio.get('/category-group/$id');
      return CategoryGroupModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<CategoryGroupModel> create({
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await dio.post('/category-group', data: data);
      return CategoryGroupModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<List<CategoryGroupModel>> createMany({
    required List<Map<String, dynamic>> data,
  }) async {
    try {
      final response = await dio.post('/category-group/bulk', data: data);
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => CategoryGroupModel.fromJson(json)).toList();
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<List<CategoryGroupModel>> upsertMany({
    required List<Map<String, dynamic>> data,
  }) async {
    try {
      final response = await dio.post(
        '/category-group/bulk/upsert',
        data: data,
      );
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => CategoryGroupModel.fromJson(json)).toList();
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<CategoryGroupModel> update({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await dio.patch('/category-group/$id', data: data);
      return CategoryGroupModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<void> delete({required String id}) async {
    try {
      await dio.delete('/category-group/$id');
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }
}
