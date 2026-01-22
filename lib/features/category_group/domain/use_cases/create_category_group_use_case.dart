import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/category_group/domain/entities/category_group_entry.dart';
import 'package:multi_catalog_system/features/category_group/domain/repositories/category_group_repository.dart';

class CreateCategoryGroupUseCase {
  final CategoryGroupRepository repository;

  CreateCategoryGroupUseCase({required this.repository});

  Future<Either<Failure, CategoryGroupEntry>> call({
    required CategoryGroupEntry entry,
  }) {
    return repository.create(entry: entry);
  }
}
