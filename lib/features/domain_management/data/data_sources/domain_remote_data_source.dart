import 'package:dio/dio.dart';
import 'package:multi_catalog_system/core/config/constants/app_constant.dart';
import 'package:multi_catalog_system/features/domain_management/data/models/domain_model.dart';

abstract class DomainRemoteDataSource {
  Future<List<DomainModel>> getAll();
  Future<DomainModel> getById(String id);
  Future<DomainModel> create(DomainModel entry);
  Future<List<DomainModel>> createMany(List<DomainModel> entries);
  Future<List<DomainModel>> upsertMany(List<DomainModel> entries);
  Future<DomainModel> update(DomainModel entry);
  Future<void> delete(String id);
}

class DomainRemoteDataSourceImpl implements DomainRemoteDataSource {
  final Dio dio;
  DomainRemoteDataSourceImpl({Dio? dio}) : dio = dio ?? Dio();

  @override
  Future<List<DomainModel>> getAll() async {
    try {
      final response = await dio.get('${AppConstant.apiBaseUrl}/domain');
      final List<dynamic> jsonList = response.data['data']['data'];
      return jsonList.map((json) => DomainModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch domains: $e');
    }
  }

  @override
  Future<DomainModel> getById(String id) async {
    try {
      final response = await dio.get('${AppConstant.apiBaseUrl}/domain/$id');
      return DomainModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch domain $id: $e');
    }
  }

  @override
  Future<DomainModel> create(DomainModel entry) async {
    try {
      final response = await dio.post(
        '${AppConstant.apiBaseUrl}/domain',
        data: entry.toJson(),
      );
      return DomainModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create domain: $e');
    }
  }

  @override
  Future<List<DomainModel>> createMany(List<DomainModel> entries) async {
    try {
      final data = entries.map((e) => e.toJson()).toList();
      final response = await dio.post(
        '${AppConstant.apiBaseUrl}/domain/bulk',
        data: data,
      );
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => DomainModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to create domain: $e');
    }
  }

  @override
  Future<List<DomainModel>> upsertMany(List<DomainModel> entries) async {
    try {
      final data = entries.map((e) => e.toJson()).toList();
      final response = await dio.post(
        '${AppConstant.apiBaseUrl}/domain/bulk/upsert',
        data: data,
      );
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => DomainModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to upsert domains: $e');
    }
  }

  @override
  Future<DomainModel> update(DomainModel entry) async {
    try {
      final response = await dio.put(
        '${AppConstant.apiBaseUrl}/domain/${entry.id}',
        data: entry.toJson(),
      );
      return DomainModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update domain ${entry.id}: $e');
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await dio.delete('${AppConstant.apiBaseUrl}/domain/$id');
    } catch (e) {
      throw Exception('Failed to delete domain $id: $e');
    }
  }
}
