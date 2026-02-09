import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_entry.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_version_entry.dart';

abstract class CategoryItemVersionRepository {
  Future<Either<Failure, List<CategoryItemVersionEntry>>> getAll({
    String? itemId,
    String? search,
  });
  Future<Either<Failure, CategoryItemVersionEntry>> getById({
    required String id,
  });
  Future<Either<Failure, CategoryItemVersionEntry>> createVersion({
    required CategoryItemEntry entry,
  });
  Future<Either<Failure, CategoryItemVersionEntry>> updateVersion({
    required CategoryItemEntry entry,
    int? type,
  });
  Future<Either<Failure, void>> deleteVersion({required String id});

  Future<Either<Failure, void>> approveVersion({required String id});
  Future<Either<Failure, void>> rejectVersion({
    required String id,
    required String rejectReason,
  });

  Future<Either<Failure, void>> delete({required String id});
}
