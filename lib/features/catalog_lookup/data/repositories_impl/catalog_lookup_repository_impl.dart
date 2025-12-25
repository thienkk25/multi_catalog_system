import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/catalog_lookup/data/data_sources/catalog_lookup_remote_data_source.dart';
import 'package:multi_catalog_system/features/catalog_lookup/data/models/category_group_ref_model.dart';
import 'package:multi_catalog_system/features/catalog_lookup/data/models/domain_ref_model.dart';
import 'package:multi_catalog_system/features/catalog_lookup/domain/entities/category_group_ref_entry.dart';
import 'package:multi_catalog_system/features/catalog_lookup/domain/entities/domain_ref_entry.dart';
import 'package:multi_catalog_system/features/catalog_lookup/domain/repositories/catalog_lookup_repository.dart';

class CatalogLookupRepositoryImpl implements CatalogLookupRepository {
  final CatalogLookupRemoteDataSource remoteDataSource;

  CatalogLookupRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, List<CategoryGroupRefEntry>>> getCategoryGroupsRef({
    required String domainId,
  }) async {
    try {
      final model = await remoteDataSource.getCategoryGroupsRef(
        domainId: domainId,
      );
      return Right(model.map((e) => e.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<DomainRefEntry>>> getDomainsRef() async {
    try {
      final model = await remoteDataSource.getDomainsRef();
      return Right(model.map((e) => e.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<DomainRefEntry>>> searchCatalog({
    required String keyword,
    required String domainId,
    int? limit,
    int? offset,
  }) {
    // TODO: implement searchCatalog
    throw UnimplementedError();
  }
}
