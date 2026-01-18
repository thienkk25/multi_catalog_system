import 'package:dio/dio.dart';
import 'package:multi_catalog_system/core/config/networks/base_remote_data_source.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/core/data/models/category_group/category_group_ref_model.dart';
import 'package:multi_catalog_system/core/data/models/domain/domain_ref_model.dart';

abstract class CatalogLookupRemoteDataSource {
  Future<List<DomainRefModel>> getDomainsRef();
  Future<List<CategoryGroupRefModel>> getCategoryGroupsRef({
    required String domainId,
  });
  Future<List<DomainRefModel>> searchCatalog({
    required String keyword,
    required String domainId,
    int? limit,
    int? offset,
  });
}

class CatalogLookupRemoteDataSourceImpl extends BaseRemoteDataSource
    implements CatalogLookupRemoteDataSource {
  final Dio dio;

  CatalogLookupRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CategoryGroupRefModel>> getCategoryGroupsRef({
    required String domainId,
  }) async {
    try {
      final response = await dio.get(
        '/catalog-lookup/category-groups/$domainId',
      );

      final List<dynamic> jsonList = response.data['data'];

      return jsonList
          .map((json) => CategoryGroupRefModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<List<DomainRefModel>> getDomainsRef() async {
    try {
      final response = await dio.get('/catalog-lookup/domains');

      final List<dynamic> jsonList = response.data['data'];

      return jsonList.map((json) => DomainRefModel.fromJson(json)).toList();
    } on DioException catch (e) {
      handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<List<DomainRefModel>> searchCatalog({
    required String keyword,
    required String domainId,
    int? limit,
    int? offset,
  }) {
    // TODO: implement searchCatalog
    throw UnimplementedError();
  }
}
