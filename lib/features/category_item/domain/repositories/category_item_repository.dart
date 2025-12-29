import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_entry.dart';

abstract class CategoryItemRepository {
  Future<Either<Failure, List<CategoryItemEntry>>> getAll({String? search});
  Future<Either<Failure, CategoryItemEntry>> getById(String id);
  Future<Either<Failure, CategoryItemEntry>> create(CategoryItemEntry entry);
  Future<Either<Failure, List<CategoryItemEntry>>> createMany(
    List<CategoryItemEntry> entries,
  );
  Future<Either<Failure, List<CategoryItemEntry>>> upsertMany(
    List<CategoryItemEntry> entries,
  );
  Future<Either<Failure, CategoryItemEntry>> update(CategoryItemEntry entry);
  Future<Either<Failure, void>> delete(String id);
}
