import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_entry.dart';

abstract class CategoryItemRepository {
  Future<Either<Failure, List<CategoryItemEntry>>> getAll({String? search});
  Future<Either<Failure, CategoryItemEntry>> getById({required String id});
  Future<Either<Failure, CategoryItemEntry>> create({
    required CategoryItemEntry entry,
  });
  Future<Either<Failure, List<CategoryItemEntry>>> createMany({
    required List<CategoryItemEntry> entries,
  });
  Future<Either<Failure, List<CategoryItemEntry>>> upsertMany({
    required List<CategoryItemEntry> entries,
  });
  Future<Either<Failure, CategoryItemEntry>> update({
    required CategoryItemEntry entry,
  });
  Future<Either<Failure, void>> delete({required String id});
}
