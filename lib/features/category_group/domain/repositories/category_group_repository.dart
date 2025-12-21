import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/category_group/domain/entities/category_group_entry.dart';

abstract class CategoryGroupRepository {
  Future<Either<Failure, List<CategoryGroupEntry>>> getAll({String? search});
  Future<Either<Failure, CategoryGroupEntry>> getById(String id);
  Future<Either<Failure, CategoryGroupEntry>> create(CategoryGroupEntry entry);
  Future<Either<Failure, List<CategoryGroupEntry>>> createMany(
    List<CategoryGroupEntry> entries,
  );
  Future<Either<Failure, List<CategoryGroupEntry>>> upsertMany(
    List<CategoryGroupEntry> entries,
  );
  Future<Either<Failure, CategoryGroupEntry>> update(CategoryGroupEntry entry);
  Future<Either<Failure, void>> delete(String id);
}
