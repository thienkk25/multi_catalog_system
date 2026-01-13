import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/system_history_management/domain/entities/system_history_entry.dart';

abstract class SystemHistoryRepository {
  Future<Either<Failure, List<SystemHistoryEntry>>> getAll({String? search});
  Future<Either<Failure, SystemHistoryEntry>> getById({required String id});
}
