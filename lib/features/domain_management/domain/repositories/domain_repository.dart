import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/domain_management/domain/entities/domain_entry.dart';
import 'package:multi_catalog_system/features/domain_management/domain/entities/domain_page_entry.dart';

abstract class DomainRepository {
  Future<Either<Failure, DomainPageEntry>> getAll({
    String? search,
    int? page,
    int? limit,
  });
  Future<Either<Failure, DomainEntry>> getById({required String id});
  Future<Either<Failure, DomainEntry>> create({required DomainEntry entry});
  Future<Either<Failure, DomainEntry>> update({required DomainEntry entry});
  Future<Either<Failure, void>> delete({required String id});
}
