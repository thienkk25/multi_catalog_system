import 'package:dio/dio.dart';
import 'package:multi_catalog_system/core/config/networks/base_remote_data_source.dart';
import 'package:multi_catalog_system/core/data/models/page/page_model.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/features/category_item/data/models/category_item_version_model.dart';

abstract class CategoryItemVersionRemoteDataSource {
  Future<PageModel<CategoryItemVersionModel>> getAll({
    String? itemId,
    String? search,
    int? page,
    int? limit,
    String? sortBy,
    String? sort,
    Map<String, dynamic>? filter,
  });
  Future<CategoryItemVersionModel> getById({required String id});
  Future<PageModel<CategoryItemVersionModel>> getHistoryVersion({
    required String itemId,
    int? page,
    int? limit,
  });

  Future<CategoryItemVersionModel> createVersion({
    required Map<String, dynamic> data,
  });
  Future<CategoryItemVersionModel> updateVersion({
    required String id,
    required Map<String, dynamic> data,
  });
  Future<CategoryItemVersionModel> deleteVersion({
    required String id,
    required String domainId,
  });

  Future<CategoryItemVersionModel> approveVersion({required String id});
  Future<CategoryItemVersionModel> rejectVersion({
    required String id,
    required String rejectReason,
  });

  Future<void> delete({required String id});
  Future<CategoryItemVersionModel> rollbackVersion({required String id});
}

class CategoryItemVersionRemoteDataSourceImpl extends BaseRemoteDataSource
    implements CategoryItemVersionRemoteDataSource {
  final Dio dio;
  CategoryItemVersionRemoteDataSourceImpl({required this.dio});

  @override
  Future<PageModel<CategoryItemVersionModel>> getAll({
    String? itemId,
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
      if (itemId != null) queryParams['item_id'] = itemId;
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;
      if (sortBy != null) queryParams['sortBy'] = sortBy;
      if (sort != null) queryParams['sort'] = sort;
      if (filter != null) queryParams['filter'] = filter;

      final response = await dio.get(
        '/category-item-version',
        queryParameters: queryParams,
      );

      final data = response.data['data'];
      return PageModel<CategoryItemVersionModel>.fromJson(
        data,
        (e) => CategoryItemVersionModel.fromJson(e as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<CategoryItemVersionModel> getById({required String id}) async {
    try {
      final response = await dio.get('/category-item-version/$id');
      return CategoryItemVersionModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<PageModel<CategoryItemVersionModel>> getHistoryVersion({
    required String itemId,
    int? page,
    int? limit,
  }) async {
    try {
      final response = await dio.get(
        '/category-item-version/$itemId/history',
        queryParameters: {'page': page, 'limit': limit},
      );
      final data = response.data['data'];
      return PageModel<CategoryItemVersionModel>.fromJson(
        data,
        (e) => CategoryItemVersionModel.fromJson(e as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<CategoryItemVersionModel> createVersion({
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await dio.post('/category-item-version', data: data);
      return CategoryItemVersionModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<CategoryItemVersionModel> updateVersion({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await dio.post(
        '/category-item-version/$id/update',
        data: data,
      );
      if (response.data['data'] == null) {
        throw UnexpectedException('No data');
      }
      return CategoryItemVersionModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<CategoryItemVersionModel> deleteVersion({
    required String id,
    required String domainId,
  }) async {
    try {
      final response = await dio.post(
        '/category-item-version/$id/delete',
        data: {'domain_id': domainId},
      );
      if (response.data['data'] == null) {
        throw UnexpectedException('No data');
      }
      return CategoryItemVersionModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<CategoryItemVersionModel> approveVersion({required String id}) async {
    try {
      final response = await dio.post('/category-item-version/$id/approve');
      if (response.data['data'] == null) {
        throw UnexpectedException('No data');
      }
      return CategoryItemVersionModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<CategoryItemVersionModel> rejectVersion({
    required String id,
    required String rejectReason,
  }) async {
    try {
      final response = await dio.post(
        '/category-item-version/$id/reject',
        data: {'reject_reason': rejectReason},
      );
      if (response.data['data'] == null) {
        throw UnexpectedException('No data');
      }
      return CategoryItemVersionModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<void> delete({required String id}) async {
    try {
      await dio.delete('/category-item-version/$id');
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<CategoryItemVersionModel> rollbackVersion({required String id}) async {
    try {
      final response = await dio.post('/category-item-version/$id/rollback');
      if (response.data['data'] == null) {
        throw UnexpectedException('No data');
      }
      return CategoryItemVersionModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }
}
