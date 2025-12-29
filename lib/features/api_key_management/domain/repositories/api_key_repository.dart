import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/api_key_management/domain/entries/api_key_entry.dart';

abstract class ApiKeyRepository {
  Future<Either<Failure, List<ApiKeyEntry>>> getAll({String? search});
  Future<Either<Failure, ApiKeyEntry>> getById(String id);
  Future<Either<Failure, ApiKeyEntry>> create(ApiKeyEntry entry);
  Future<Either<Failure, List<ApiKeyEntry>>> createMany(
    List<ApiKeyEntry> entries,
  );
  Future<Either<Failure, List<ApiKeyEntry>>> upsertMany(
    List<ApiKeyEntry> entries,
  );
  Future<Either<Failure, ApiKeyEntry>> update(ApiKeyEntry entry);
  Future<Either<Failure, void>> delete(String id);
}
