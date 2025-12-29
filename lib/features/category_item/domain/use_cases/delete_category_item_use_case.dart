import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/category_item/domain/repositories/category_item_repository.dart';

class DeleteCategoryItemUseCase {
  final CategoryItemRepository repository;

  DeleteCategoryItemUseCase({required this.repository});

  Future<Either<Failure, void>> call(String id) async {
    return repository.delete(id);
  }
}
