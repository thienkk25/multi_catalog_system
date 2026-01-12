import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/domain_management/domain/entities/domain_entry.dart';

abstract class DomainRepository {
  Future<Either<Failure, List<DomainEntry>>> getAll({String? search});
  Future<Either<Failure, DomainEntry>> getById({required String id});
  Future<Either<Failure, DomainEntry>> create({required DomainEntry entry});
  Future<Either<Failure, List<DomainEntry>>> createMany({
    required List<DomainEntry> entries,
  });
  Future<Either<Failure, List<DomainEntry>>> upsertMany({
    required List<DomainEntry> entries,
  });
  Future<Either<Failure, DomainEntry>> update({required DomainEntry entry});
  Future<Either<Failure, void>> delete({required String id});
}
