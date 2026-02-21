import 'package:dio/dio.dart';
import 'package:multi_catalog_system/core/config/networks/base_remote_data_source.dart';
import 'package:multi_catalog_system/core/data/models/category_group/category_group_ref_model.dart';
import 'package:multi_catalog_system/core/data/models/page/page_model.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/features/category_group/data/models/category_group_model.dart';

abstract class CategoryGroupRemoteDataSource {
  Future<PageModel<CategoryGroupModel>> getAll({
    String? search,
    int? page,
    int? limit,
    Map<String, dynamic>? filter,
  });
  Future<CategoryGroupModel> getById({required String id});
  Future<CategoryGroupModel> create({required Map<String, dynamic> data});
  Future<CategoryGroupModel> update({
    required String id,
    required Map<String, dynamic> data,
  });
  Future<void> delete({required String id});

  Future<PageModel<CategoryGroupRefModel>> lookup({
    required String domainId,
    int? page,
    int? limit,
  });
}

class CategoryGroupRemoteDataSourceImpl extends BaseRemoteDataSource
    implements CategoryGroupRemoteDataSource {
  final Dio dio;

  CategoryGroupRemoteDataSourceImpl({required this.dio});

  @override
  Future<PageModel<CategoryGroupModel>> getAll({
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
        '/category-group',
        queryParameters: queryParams,
      );

      final data = response.data['data'];

      return PageModel<CategoryGroupModel>.fromJson(
        data,
        (e) => CategoryGroupModel.fromJson(e as Map<String, dynamic>),
      );
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

  @override
  Future<PageModel<CategoryGroupRefModel>> lookup({
    required String domainId,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{'domain_id': domainId};
      if (page != null) queryParams['page'] = page;

      if (limit != null) queryParams['limit'] = limit;
      final response = await dio.get(
        '/category-group/lookup',
        queryParameters: queryParams,
      );
      return PageModel<CategoryGroupRefModel>.fromJson(
        response.data['data'],
        (e) => CategoryGroupRefModel.fromJson(e as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }
}
