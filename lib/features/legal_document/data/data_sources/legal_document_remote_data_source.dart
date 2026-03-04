import 'package:dio/dio.dart';
import 'package:multi_catalog_system/core/config/networks/base_remote_data_source.dart';
import 'package:multi_catalog_system/core/data/models/page/page_model.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/features/legal_document/data/models/legal_document_model.dart';

abstract class LegalDocumentRemoteDataSource {
  Future<PageModel<LegalDocumentModel>> getAll({
    String? search,
    int? page,
    int? limit,
    String? sortBy,
    String? sort,
    Map<String, dynamic>? filter,
  });
  Future<PageModel<LegalDocumentModel>> getAllHasFile({
    String? search,
    int? page,
    int? limit,
    String? sortBy,
    String? sort,
  });
  Future<LegalDocumentModel> getById({required String id});
  Future<LegalDocumentModel> create({required FormData data});
  Future<LegalDocumentModel> update({
    required String id,
    required FormData data,
  });
  Future<void> delete({required String id});
}

class LegalDocumentRemoteDataSourceImpl extends BaseRemoteDataSource
    implements LegalDocumentRemoteDataSource {
  final Dio dio;

  LegalDocumentRemoteDataSourceImpl({required this.dio});

  @override
  Future<PageModel<LegalDocumentModel>> getAll({
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

      final response = await dio.get(
        '/legal-document',
        queryParameters: queryParams,
      );

      final data = response.data['data'];
      return PageModel<LegalDocumentModel>.fromJson(
        data,
        (e) => LegalDocumentModel.fromJson(e as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<PageModel<LegalDocumentModel>> getAllHasFile({
    String? search,
    int? page,
    int? limit,
    String? sortBy,
    String? sort,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (search != null) queryParams['search'] = search;
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;
      if (sortBy != null) queryParams['sortBy'] = sortBy;
      if (sort != null) queryParams['sort'] = sort;

      final response = await dio.get(
        '/legal-document/documents/with-file',
        queryParameters: queryParams,
      );

      final data = response.data['data'];
      return PageModel<LegalDocumentModel>.fromJson(
        data,
        (e) => LegalDocumentModel.fromJson(e as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<LegalDocumentModel> getById({required String id}) async {
    try {
      final response = await dio.get('/legal-document/$id');
      return LegalDocumentModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<LegalDocumentModel> create({required FormData data}) async {
    try {
      final response = await dio.post(
        '/legal-document',
        data: data,
        options: Options(contentType: Headers.multipartFormDataContentType),
      );

      return LegalDocumentModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<LegalDocumentModel> update({
    required String id,
    required FormData data,
  }) async {
    try {
      final response = await dio.patch(
        '/legal-document/$id',
        data: data,
        options: Options(contentType: Headers.multipartFormDataContentType),
      );
      return LegalDocumentModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<void> delete({required String id}) async {
    try {
      await dio.delete('/legal-document/$id');
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }
}
