import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/domain/entities/category_group/category_group_ref_entry.dart';
import 'package:multi_catalog_system/core/domain/entities/domain/domain_ref_entry.dart';
import 'package:multi_catalog_system/core/error/failures.dart';

abstract class CatalogLookupRepository {
  Future<Either<Failure, List<DomainRefEntry>>> getDomainsRef();
  Future<Either<Failure, List<CategoryGroupRefEntry>>> getCategoryGroupsRef({
    required String domainId,
  });
  Future<Either<Failure, List<DomainRefEntry>>> searchCatalog({
    required String keyword,
    required String domainId,
    int? limit,
    int? offset,
  });
}
