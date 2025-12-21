import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/category_group/domain/repositories/category_group_repository.dart';

class DeleteCategoryGroupUseCase {
  final CategoryGroupRepository repository;

  DeleteCategoryGroupUseCase({required this.repository});

  Future<Either<Failure, void>> call(String id) async {
    return repository.delete(id);
  }
}
