import 'package:dio/dio.dart';
import 'package:multi_catalog_system/core/config/networks/base_remote_data_source.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/features/legal_document/data/models/legal_document_model.dart';

abstract class LegalDocumentRemoteDataSource {
  Future<List<LegalDocumentModel>> getAll({String? search});
  Future<LegalDocumentModel> getById(String id);
  Future<LegalDocumentModel> create(LegalDocumentModel entry);
  Future<List<LegalDocumentModel>> createMany(List<LegalDocumentModel> entries);
  Future<List<LegalDocumentModel>> upsertMany(List<LegalDocumentModel> entries);
  Future<LegalDocumentModel> update(LegalDocumentModel entry);
  Future<void> delete(String id);
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
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<LegalDocumentModel> getById(String id) async {
    try {
      final response = await dio.get('/legal-document/$id');
      return LegalDocumentModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<LegalDocumentModel> create(LegalDocumentModel entry) async {
    try {
      final data = entry.toJson()..remove('id');
      final response = await dio.post('/legal-document', data: data);
      return LegalDocumentModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<List<LegalDocumentModel>> createMany(
    List<LegalDocumentModel> entries,
  ) async {
    try {
      final data = entries.map((e) => e.toJson()).toList();
      final response = await dio.post('/legal-document/bulk', data: data);
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => LegalDocumentModel.fromJson(json)).toList();
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<List<LegalDocumentModel>> upsertMany(
    List<LegalDocumentModel> entries,
  ) async {
    try {
      final data = entries.map((e) => e.toJson()).toList();
      final response = await dio.post(
        '/legal-document/bulk/upsert',
        data: data,
      );
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => LegalDocumentModel.fromJson(json)).toList();
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<LegalDocumentModel> update(LegalDocumentModel entry) async {
    try {
      final response = await dio.put(
        '/legal-document/${entry.id}',
        data: entry.toJson(),
      );
      return LegalDocumentModel.fromJson(response.data['data']);
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
      await dio.delete('/legal-document/$id');
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }
}
