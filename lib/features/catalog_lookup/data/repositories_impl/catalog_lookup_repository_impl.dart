import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/data/models/category_group/category_group_ref_model.dart';
import 'package:multi_catalog_system/core/domain/entities/category_group/category_group_ref_entry.dart';
import 'package:multi_catalog_system/core/domain/entities/domain/domain_ref_entry.dart';
import 'package:multi_catalog_system/core/error/exception_mapper.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/catalog_lookup/data/data_sources/catalog_lookup_remote_data_source.dart';
import 'package:multi_catalog_system/core/data/models/domain/domain_ref_model.dart';
import 'package:multi_catalog_system/features/catalog_lookup/domain/repositories/catalog_lookup_repository.dart';

class CatalogLookupRepositoryImpl implements CatalogLookupRepository {
  final CatalogLookupRemoteDataSource remoteDataSource;

  CatalogLookupRepositoryImpl({required this.remoteDataSource});

  CategoryGroupRefEntry _toCategoryGroupEntity(CategoryGroupRefModel model) {
    return CategoryGroupRefEntry(
      id: model.id,
      name: model.name,
      code: model.code,
    );
  }

  DomainRefEntry _toDomainEntity(DomainRefModel model) {
    return DomainRefEntry(id: model.id, name: model.name, code: model.code);
  }

  @override
  Future<Either<Failure, List<CategoryGroupRefEntry>>> getCategoryGroupsRef({
    required String domainId,
  }) async {
    try {
      final model = await remoteDataSource.getCategoryGroupsRef(
        domainId: domainId,
      );
      return Right(model.map((e) => _toCategoryGroupEntity(e)).toList());
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DomainRefEntry>>> getDomainsRef() async {
    try {
      final model = await remoteDataSource.getDomainsRef();
      return Right(model.map((e) => _toDomainEntity(e)).toList());
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
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
