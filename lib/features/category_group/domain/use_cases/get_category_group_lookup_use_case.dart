import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/domain/entities/category_group/category_group_ref_entry.dart';
import 'package:multi_catalog_system/core/domain/entities/page/page_entry.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/category_group/domain/repositories/category_group_repository.dart';

class GetCategoryGroupLookupUseCase {
  final CategoryGroupRepository repository;

  GetCategoryGroupLookupUseCase({required this.repository});

  Future<Either<Failure, PageEntry<CategoryGroupRefEntry>>> call({
    required List<String> domainIds,
    int? page,
    int? limit,
  }) {
    return repository.lookup(domainIds: domainIds, page: page, limit: limit);
  }
}
