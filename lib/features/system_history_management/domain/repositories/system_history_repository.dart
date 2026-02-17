import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/domain/entities/page/page_entry.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/system_history_management/domain/entities/system_history_entry.dart';

abstract class SystemHistoryRepository {
  Future<Either<Failure, PageEntry<SystemHistoryEntry>>> getAll({
    String? search,
    int? page,
    int? limit,
    Map<String, dynamic>? filter,
  });
  Future<Either<Failure, SystemHistoryEntry>> getById({required String id});
}
