import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/domain/entities/page/page_entry.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/category_group/domain/entities/category_group_entry.dart';
import 'package:multi_catalog_system/features/category_group/domain/repositories/category_group_repository.dart';

class GetAllCategoryGroupUseCase {
  final CategoryGroupRepository repository;

  GetAllCategoryGroupUseCase({required this.repository});

  Future<Either<Failure, PageEntry<CategoryGroupEntry>>> call({
    String? search,
    int? page,
    int? limit,
    Map<String, dynamic>? filter,
  }) {
    return repository.getAll(
      search: search,
      page: page,
      limit: limit,
      filter: filter,
    );
  }
}
