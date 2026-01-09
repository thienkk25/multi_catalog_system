import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:multi_catalog_system/core/config/networks/base_remote_data_source.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/features/legal_document/data/models/legal_document_model.dart';
import 'package:multi_catalog_system/features/legal_document/data/models/picked_document_file.dart';

abstract class LegalDocumentRemoteDataSource {
  Future<List<LegalDocumentModel>> getAll({String? search});
  Future<LegalDocumentModel> getById(String id);
  Future<LegalDocumentModel> create({
    required LegalDocumentModel entry,
    PickedDocumentFile? file,
  });
  Future<List<LegalDocumentModel>> createMany(List<LegalDocumentModel> entries);
  Future<List<LegalDocumentModel>> upsertMany(List<LegalDocumentModel> entries);
  Future<LegalDocumentModel> update({
    required LegalDocumentModel entry,
    PickedDocumentFile? file,
  });
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
  Future<LegalDocumentModel> create({
    required LegalDocumentModel entry,
    PickedDocumentFile? file,
  }) async {
    try {
      final formData = FormData();

      entry.toJson()
        ..remove('id')
        ..removeWhere((key, value) => value == null || value == '')
        ..forEach((key, value) {
          formData.fields.add(MapEntry(key, value.toString()));
        });

      if (file != null) {
        final multipartFile = kIsWeb
            ? MultipartFile.fromBytes(file.bytes!, filename: file.name)
            : await MultipartFile.fromFile(
                file.file!.path,
                filename: file.name,
              );

        formData.files.add(MapEntry('file', multipartFile));
      }

      final response = await dio.post(
        '/legal-document',
        data: formData,
        options: Options(contentType: Headers.multipartFormDataContentType),
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
  Future<LegalDocumentModel> update({
    required LegalDocumentModel entry,
    PickedDocumentFile? file,
  }) async {
    try {
      final formData = FormData();

      entry.toJson()
        ..removeWhere((key, value) => value == null || value == '')
        ..forEach((key, value) {
          formData.fields.add(MapEntry(key, value.toString()));
        });

      if (file != null) {
        final multipartFile = kIsWeb
            ? MultipartFile.fromBytes(file.bytes!, filename: file.name)
            : await MultipartFile.fromFile(
                file.file!.path,
                filename: file.name,
              );

        formData.files.add(MapEntry('file', multipartFile));
      }

      final response = await dio.patch(
        '/legal-document/${entry.id}',
        data: formData,
        options: Options(contentType: Headers.multipartFormDataContentType),
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
