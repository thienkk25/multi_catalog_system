import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/domain/entities/domain/domain_ref_entry.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/catalog_lookup/domain/repositories/catalog_lookup_repository.dart';

class SearchCatalogUseCase {
  final CatalogLookupRepository repository;

  SearchCatalogUseCase({required this.repository});

  Future<Either<Failure, List<DomainRefEntry>>> call({
    required String keyword,
    required String domainId,
    int? limit,
    int? offset,
  }) {
    return repository.searchCatalog(
      keyword: keyword,
      domainId: domainId,
      limit: limit,
      offset: offset,
    );
  }
}
