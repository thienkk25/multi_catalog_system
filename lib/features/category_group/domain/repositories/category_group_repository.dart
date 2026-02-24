import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/domain/entities/category_group/category_group_ref_entry.dart';
import 'package:multi_catalog_system/core/domain/entities/page/page_entry.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/category_group/domain/entities/category_group_entry.dart';

abstract class CategoryGroupRepository {
  Future<Either<Failure, PageEntry<CategoryGroupEntry>>> getAll({
    String? search,
    int? page,
    int? limit,
    String? sortBy,
    String? sort,
    Map<String, dynamic>? filter,
  });
  Future<Either<Failure, CategoryGroupEntry>> getById({required String id});
  Future<Either<Failure, CategoryGroupEntry>> create({
    required CategoryGroupEntry entry,
  });
  Future<Either<Failure, CategoryGroupEntry>> update({
    required CategoryGroupEntry entry,
  });
  Future<Either<Failure, void>> delete({required String id});

  Future<Either<Failure, PageEntry<CategoryGroupRefEntry>>> lookup({
    required List<String> domainIds,
    int? page,
    int? limit,
  });
}
