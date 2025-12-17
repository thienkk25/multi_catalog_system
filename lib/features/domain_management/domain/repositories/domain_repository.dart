import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/domain_management/domain/entities/domain_entry.dart';

abstract class DomainRepository {
  Future<Either<Failure, List<DomainEntry>>> getAll();
  Future<Either<Failure, DomainEntry>> getById(String id);
  Future<Either<Failure, DomainEntry>> create(DomainEntry entry);
  Future<Either<Failure, List<DomainEntry>>> createMany(
    List<DomainEntry> entries,
  );
  Future<Either<Failure, List<DomainEntry>>> upsertMany(
    List<DomainEntry> entries,
  );
  Future<Either<Failure, DomainEntry>> update(DomainEntry entry);
  Future<Either<Failure, void>> delete(String id);
}
