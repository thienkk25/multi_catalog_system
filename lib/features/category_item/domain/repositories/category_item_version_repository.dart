import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/domain/entities/page/page_entry.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_entry.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_version_entry.dart';

abstract class CategoryItemVersionRepository {
  Future<Either<Failure, PageEntry<CategoryItemVersionEntry>>> getAll({
    String? itemId,
    String? search,
    int? page,
    int? limit,
    String? sortBy,
    String? sort,
    Map<String, dynamic>? filter,
  });
  Future<Either<Failure, CategoryItemVersionEntry>> getById({
    required String id,
  });
  Future<Either<Failure, CategoryItemVersionEntry>> createVersion({
    required CategoryItemEntry entry,
  });
  Future<Either<Failure, CategoryItemVersionEntry>> updateVersion({
    required CategoryItemEntry entry,
    required String id,
    int? type,
  });
  Future<Either<Failure, CategoryItemVersionEntry>> deleteVersion({
    required String id,
  });

  Future<Either<Failure, CategoryItemVersionEntry>> approveVersion({
    required String id,
  });
  Future<Either<Failure, CategoryItemVersionEntry>> rejectVersion({
    required String id,
    required String rejectReason,
  });

  Future<Either<Failure, void>> delete({required String id});

  Future<Either<Failure, CategoryItemVersionEntry>> rollbackVersion({
    required String id,
  });
}
