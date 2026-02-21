import 'package:dio/dio.dart';
import 'package:multi_catalog_system/core/config/networks/base_remote_data_source.dart';
import 'package:multi_catalog_system/core/data/models/domain/domain_ref_model.dart';
import 'package:multi_catalog_system/core/data/models/page/page_model.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/features/domain_management/data/models/domain_model.dart';

abstract class DomainRemoteDataSource {
  Future<PageModel<DomainModel>> getAll({
    String? search,
    int? page,
    int? limit,
    Map<String, dynamic>? filter,
  });
  Future<DomainModel> getById({required String id});
  Future<DomainModel> create({required Map<String, dynamic> data});
  Future<DomainModel> update({
    required String id,
    required Map<String, dynamic> data,
  });
  Future<void> delete({required String id});

  Future<PageModel<DomainRefModel>> lookup({int? page, int? limit});
}

class DomainRemoteDataSourceImpl extends BaseRemoteDataSource
    implements DomainRemoteDataSource {
  final Dio dio;

  DomainRemoteDataSourceImpl({required this.dio});

  @override
  Future<PageModel<DomainModel>> getAll({
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

      final response = await dio.get('/domain', queryParameters: queryParams);

      final data = response.data['data'];

      return PageModel<DomainModel>.fromJson(
        data,
        (e) => DomainModel.fromJson(e as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<DomainModel> getById({required String id}) async {
    try {
      final response = await dio.get('/domain/$id');
      return DomainModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<DomainModel> create({required Map<String, dynamic> data}) async {
    try {
      final response = await dio.post('/domain', data: data);
      return DomainModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<DomainModel> update({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await dio.patch('/domain/$id', data: data);
      return DomainModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<void> delete({required String id}) async {
    try {
      await dio.delete('/domain/$id');
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<PageModel<DomainRefModel>> lookup({int? page, int? limit}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (page != null) queryParams['page'] = page;

      if (limit != null) queryParams['limit'] = limit;
      final response = await dio.get(
        '/domain/lookup',
        queryParameters: queryParams,
      );
      return PageModel<DomainRefModel>.fromJson(
        response.data['data'],
        (e) => DomainRefModel.fromJson(e as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }
}
