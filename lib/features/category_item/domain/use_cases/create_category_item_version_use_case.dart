import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_entry.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_version_entry.dart';
import 'package:multi_catalog_system/features/category_item/domain/repositories/category_item_version_repository.dart';

class CreateCategoryItemVersionUseCase {
  final CategoryItemVersionRepository repository;

  CreateCategoryItemVersionUseCase({required this.repository});

  Future<Either<Failure, CategoryItemVersionEntry>> call({
    required CategoryItemEntry entry,
  }) {
    return repository.createVersion(entry: entry);
  }
}
