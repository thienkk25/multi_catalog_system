import 'package:dio/dio.dart';
import 'package:multi_catalog_system/core/config/networks/base_remote_data_source.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/features/legal_document/data/models/legal_document_model.dart';

abstract class LegalDocumentRemoteDataSource {
  Future<List<LegalDocumentModel>> getAll({String? search});
  Future<List<LegalDocumentModel>> getAllHasFile({String? search});
  Future<LegalDocumentModel> getById({required String id});
  Future<LegalDocumentModel> create({required FormData data});
  Future<List<LegalDocumentModel>> createMany({
    required List<Map<String, dynamic>> data,
  });
  Future<List<LegalDocumentModel>> upsertMany({
    required List<Map<String, dynamic>> data,
  });
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
  Future<List<LegalDocumentModel>> getAll({String? search}) async {
    try {
      final queryParams = <String, dynamic>{};

      if (search != null) queryParams['search'] = search;

      final response = await dio.get(
        '/legal-document',
        queryParameters: queryParams,
      );

      final List<dynamic> jsonList = response.data['data']['data'];
      return jsonList.map((json) => LegalDocumentModel.fromJson(json)).toList();
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<List<LegalDocumentModel>> getAllHasFile({String? search}) async {
    try {
      final queryParams = <String, dynamic>{};

      if (search != null) queryParams['search'] = search;

      final response = await dio.get(
        '/legal-document/documents/with-file',
        queryParameters: queryParams,
      );

      final List<dynamic> jsonList = response.data['data']['data'];
      return jsonList.map((json) => LegalDocumentModel.fromJson(json)).toList();
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
  Future<List<LegalDocumentModel>> createMany({
    required List<Map<String, dynamic>> data,
  }) async {
    try {
      final response = await dio.post('/legal-document/bulk', data: data);
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => LegalDocumentModel.fromJson(json)).toList();
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<List<LegalDocumentModel>> upsertMany({
    required List<Map<String, dynamic>> data,
  }) async {
    try {
      final response = await dio.post(
        '/legal-document/bulk/upsert',
        data: data,
      );
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => LegalDocumentModel.fromJson(json)).toList();
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
