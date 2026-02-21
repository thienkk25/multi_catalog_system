import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/domain/entities/domain/domain_ref_entry.dart';
import 'package:multi_catalog_system/core/domain/entities/page/page_entry.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/domain_management/domain/entities/domain_entry.dart';

abstract class DomainRepository {
  Future<Either<Failure, PageEntry<DomainEntry>>> getAll({
    String? search,
    int? page,
    int? limit,
    Map<String, dynamic>? filter,
  });
  Future<Either<Failure, DomainEntry>> getById({required String id});
  Future<Either<Failure, DomainEntry>> create({required DomainEntry entry});
  Future<Either<Failure, DomainEntry>> update({required DomainEntry entry});
  Future<Either<Failure, void>> delete({required String id});

  Future<Either<Failure, PageEntry<DomainRefEntry>>> lookup({
    int? page,
    int? limit,
  });
}
