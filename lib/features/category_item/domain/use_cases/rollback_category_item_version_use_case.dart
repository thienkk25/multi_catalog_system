import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_version_entry.dart';
import 'package:multi_catalog_system/features/category_item/domain/repositories/category_item_version_repository.dart';

class RollbackCategoryItemVersionUseCase {
  final CategoryItemVersionRepository repository;

  RollbackCategoryItemVersionUseCase({required this.repository});

  Future<Either<Failure, CategoryItemVersionEntry>> call({required String id}) {
    return repository.rollbackVersion(id: id);
  }
}
