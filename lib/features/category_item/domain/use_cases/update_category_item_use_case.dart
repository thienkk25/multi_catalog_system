import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_entry.dart';
import 'package:multi_catalog_system/features/category_item/domain/repositories/category_item_repository.dart';

class UpdateCategoryItemUseCase {
  final CategoryItemRepository repository;

  UpdateCategoryItemUseCase({required this.repository});

  Future<Either<Failure, CategoryItemEntry>> call({
    required CategoryItemEntry entry,
  }) {
    return repository.update(entry: entry);
  }
}
