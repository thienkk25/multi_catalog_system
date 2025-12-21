import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/category_group/domain/entities/category_group_entry.dart';
import 'package:multi_catalog_system/features/category_group/domain/repositories/category_group_repository.dart';

class GetByIdCategoryGroupUseCase {
  final CategoryGroupRepository repository;

  GetByIdCategoryGroupUseCase({required this.repository});

  Future<Either<Failure, CategoryGroupEntry>> call(String id) async {
    return await repository.getById(id);
  }
}
