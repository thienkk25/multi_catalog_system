import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/domain_management/domain/entities/domain_entry.dart';
import 'package:multi_catalog_system/features/domain_management/domain/repositories/domain_repository.dart';

class UpsertManyDomainUseCase {
  final DomainRepository repository;

  UpsertManyDomainUseCase({required this.repository});

  Future<Either<Failure, List<DomainEntry>>> call(
    List<DomainEntry> entries,
  ) async {
    return repository.upsertMany(entries);
  }
}
