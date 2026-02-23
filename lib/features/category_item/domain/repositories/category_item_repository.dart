import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/domain/entities/page/page_entry.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_entry.dart';

abstract class CategoryItemRepository {
  Future<Either<Failure, PageEntry<CategoryItemEntry>>> getAll({
    String? search,
    int? page,
    int? limit,
    String? sortBy,
    String? sort,
    Map<String, dynamic>? filter,
  });
  Future<Either<Failure, CategoryItemEntry>> getById({required String id});
  Future<Either<Failure, CategoryItemEntry>> create({
    required CategoryItemEntry entry,
  });
  Future<Either<Failure, CategoryItemEntry>> update({
    required CategoryItemEntry entry,
  });
  Future<Either<Failure, void>> delete({required String id});
}
