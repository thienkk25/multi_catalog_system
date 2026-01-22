import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_entry.dart';
import 'package:multi_catalog_system/features/category_item/domain/repositories/category_item_repository.dart';

class GetAllCategoryItemUseCase {
  final CategoryItemRepository repository;

  GetAllCategoryItemUseCase({required this.repository});

  Future<Either<Failure, List<CategoryItemEntry>>> call({String? search}) {
    return repository.getAll(search: search);
  }
}
