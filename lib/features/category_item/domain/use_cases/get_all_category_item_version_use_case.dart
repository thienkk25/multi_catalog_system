import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/domain/entities/page/page_entry.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_version_entry.dart';
import 'package:multi_catalog_system/features/category_item/domain/repositories/category_item_version_repository.dart';

class GetAllCategoryItemVersionUseCase {
  final CategoryItemVersionRepository repository;

  GetAllCategoryItemVersionUseCase({required this.repository});

  Future<Either<Failure, PageEntry<CategoryItemVersionEntry>>> call({
    String? itemId,
    String? search,
    int? page,
    int? limit,
    String? sortBy,
    String? sort,
    Map<String, dynamic>? filter,
  }) {
    return repository.getAll(
      itemId: itemId,
      search: search,
      page: page,
      limit: limit,
      sortBy: sortBy,
      sort: sort,
      filter: filter,
    );
  }
}
