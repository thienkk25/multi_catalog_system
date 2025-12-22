import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/category_group/domain/entities/category_group_entry.dart';
import 'package:multi_catalog_system/features/category_group/domain/repositories/category_group_repository.dart';

class UpsertManyCategoryGroupUseCase {
  final CategoryGroupRepository repository;

  UpsertManyCategoryGroupUseCase({required this.repository});

  Future<Either<Failure, List<CategoryGroupEntry>>> call(
    List<CategoryGroupEntry> entries,
  ) async {
    return await repository.upsertMany(entries);
  }
}
