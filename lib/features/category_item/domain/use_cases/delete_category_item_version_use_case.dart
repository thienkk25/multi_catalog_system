import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_version_entry.dart';
import 'package:multi_catalog_system/features/category_item/domain/repositories/category_item_version_repository.dart';

class DeleteCategoryItemVersionUseCase {
  final CategoryItemVersionRepository repository;

  DeleteCategoryItemVersionUseCase({required this.repository});

  Future<Either<Failure, CategoryItemVersionEntry>> call({
    required String id,
    required String domainId,
  }) {
    return repository.deleteVersion(id: id, domainId: domainId);
  }
}
