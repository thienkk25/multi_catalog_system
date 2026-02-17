import 'package:dio/dio.dart';
import 'package:multi_catalog_system/core/config/networks/base_remote_data_source.dart';
import 'package:multi_catalog_system/core/data/models/page/page_model.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/features/category_item/data/models/category_item_model.dart';

abstract class CategoryItemRemoteDataSource {
  Future<PageModel<CategoryItemModel>> getAll({
    String? search,
    int? page,
    int? limit,
    Map<String, dynamic>? filter,
  });
  Future<CategoryItemModel> getById({required String id});
  Future<CategoryItemModel> create({required Map<String, dynamic> data});
  Future<CategoryItemModel> update({
    required String id,
    required Map<String, dynamic> data,
  });
  Future<void> delete({required String id});
}

class CategoryItemRemoteDataSourceImpl extends BaseRemoteDataSource
    implements CategoryItemRemoteDataSource {
  final Dio dio;

  CategoryItemRemoteDataSourceImpl({required this.dio});

  @override
  Future<PageModel<CategoryItemModel>> getAll({
    String? search,
    int? page,
    int? limit,
    Map<String, dynamic>? filter,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (search != null) queryParams['search'] = search;
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;
      if (filter != null) queryParams['filter'] = filter;

      final response = await dio.get(
        '/category-item',
        queryParameters: queryParams,
      );

      final data = response.data['data'];
      return PageModel<CategoryItemModel>.fromJson(
        data,
        (e) => CategoryItemModel.fromJson(e as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<CategoryItemModel> getById({required String id}) async {
    try {
      final response = await dio.get('/category-item/$id');
      return CategoryItemModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<CategoryItemModel> create({required Map<String, dynamic> data}) async {
    try {
      final response = await dio.post('/category-item', data: data);
      return CategoryItemModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<CategoryItemModel> update({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await dio.patch('/category-item/$id', data: data);
      return CategoryItemModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<void> delete({required String id}) async {
    try {
      await dio.delete('/category-item/$id');
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }
}
