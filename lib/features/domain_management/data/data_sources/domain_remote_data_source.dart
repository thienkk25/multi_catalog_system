import 'package:dio/dio.dart';
import 'package:multi_catalog_system/core/config/networks/base_remote_data_source.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/features/domain_management/data/models/domain_model.dart';

abstract class DomainRemoteDataSource {
  Future<List<DomainModel>> getAll({String? search});
  Future<DomainModel> getById(String id);
  Future<DomainModel> create(DomainModel entry);
  Future<List<DomainModel>> createMany(List<DomainModel> entries);
  Future<List<DomainModel>> upsertMany(List<DomainModel> entries);
  Future<DomainModel> update(DomainModel entry);
  Future<void> delete(String id);
}

class DomainRemoteDataSourceImpl extends BaseRemoteDataSource
    implements DomainRemoteDataSource {
  final Dio dio;

  DomainRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<DomainModel>> getAll({String? search}) async {
    try {
      final queryParams = <String, dynamic>{};

      if (search != null) queryParams['search'] = search;

      final response = await dio.get('/domain', queryParameters: queryParams);

      final List<dynamic> jsonList = response.data['data']['data'];
      return jsonList.map((json) => DomainModel.fromJson(json)).toList();
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<DomainModel> getById(String id) async {
    try {
      final response = await dio.get('/domain/$id');
      return DomainModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<DomainModel> create(DomainModel entry) async {
    try {
      final data = entry.toJson()..remove('id');
      final response = await dio.post('/domain', data: data);
      return DomainModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<List<DomainModel>> createMany(List<DomainModel> entries) async {
    try {
      final data = entries.map((e) => e.toJson()).toList();
      final response = await dio.post('/domain/bulk', data: data);
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => DomainModel.fromJson(json)).toList();
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<List<DomainModel>> upsertMany(List<DomainModel> entries) async {
    try {
      final data = entries.map((e) => e.toJson()).toList();
      final response = await dio.post('/domain/bulk/upsert', data: data);
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => DomainModel.fromJson(json)).toList();
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<DomainModel> update(DomainModel entry) async {
    try {
      final response = await dio.patch(
        '/domain/${entry.id}',
        data: entry.toJson(),
      );
      return DomainModel.fromJson(response.data['data']);
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
      await dio.delete('/domain/$id');
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }
}
