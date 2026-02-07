import 'package:dio/dio.dart';
import 'package:multi_catalog_system/core/config/networks/base_remote_data_source.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/features/category_item/data/models/category_item_version_model.dart';

abstract class CategoryItemVersionRemoteDataSource {
  Future<List<CategoryItemVersionModel>> getAll({
    required String itemId,
    String? search,
  });
  Future<CategoryItemVersionModel> getById({required String id});

  Future<CategoryItemVersionModel> createVersion({
    required Map<String, dynamic> data,
  });
  Future<CategoryItemVersionModel> updateVersion({
    required String id,
    required Map<String, dynamic> data,
  });
  Future<void> deleteVersion({required String id});

  Future<void> approveVersion({required String id});
  Future<void> rejectVersion({
    required String id,
    required String rejectReason,
  });

  Future<void> delete({required String id});
}

class CategoryItemVersionRemoteDataSourceImpl extends BaseRemoteDataSource
    implements CategoryItemVersionRemoteDataSource {
  final Dio dio;
  CategoryItemVersionRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CategoryItemVersionModel>> getAll({
    required String itemId,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (search != null) queryParams['search'] = search;
      queryParams['item_id'] = itemId;

      final response = await dio.get(
        '/category-item-version',
        queryParameters: queryParams,
      );

      final List<dynamic> jsonList = response.data['data']['data'];
      return jsonList
          .map((json) => CategoryItemVersionModel.fromJson(json))
          .toList();
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
      return CategoryItemVersionModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<void> deleteVersion({required String id}) async {
    try {
      await dio.post('/category-item-version/$id/delete');
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<void> approveVersion({required String id}) async {
    try {
      await dio.post('/category-item-version/$id/approve');
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<void> rejectVersion({
    required String id,
    required String rejectReason,
  }) async {
    try {
      await dio.post(
        '/category-item-version/$id/reject',
        data: {'reject_reason': rejectReason},
      );
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
}
