import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/domain/entities/category_group/category_group_ref_entry.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/catalog_lookup/domain/repositories/catalog_lookup_repository.dart';

class GetCategoryGroupRefUseCase {
  final CatalogLookupRepository repository;
  GetCategoryGroupRefUseCase({required this.repository});

  Future<Either<Failure, List<CategoryGroupRefEntry>>> call({
    required String domainId,
  }) {
    return repository.getCategoryGroupsRef(domainId: domainId);
  }
}
