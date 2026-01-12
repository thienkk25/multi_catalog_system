import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/category_group/domain/entities/category_group_entry.dart';

abstract class CategoryGroupRepository {
  Future<Either<Failure, List<CategoryGroupEntry>>> getAll({String? search});
  Future<Either<Failure, CategoryGroupEntry>> getById({required String id});
  Future<Either<Failure, CategoryGroupEntry>> create({
    required CategoryGroupEntry entry,
  });
  Future<Either<Failure, List<CategoryGroupEntry>>> createMany({
    required List<CategoryGroupEntry> entries,
  });
  Future<Either<Failure, List<CategoryGroupEntry>>> upsertMany({
    required List<CategoryGroupEntry> entries,
  });
  Future<Either<Failure, CategoryGroupEntry>> update({
    required CategoryGroupEntry entry,
  });
  Future<Either<Failure, void>> delete({required String id});
}
