import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_version_entry.dart';
import 'package:multi_catalog_system/features/category_item/domain/repositories/category_item_version_repository.dart';

class GetAllCategoryItemVersionUseCase {
  final CategoryItemVersionRepository repository;

  GetAllCategoryItemVersionUseCase({required this.repository});

  Future<Either<Failure, List<CategoryItemVersionEntry>>> call({
    String? itemId,
    String? search,
  }) {
    return repository.getAll(itemId: itemId, search: search);
  }
}
