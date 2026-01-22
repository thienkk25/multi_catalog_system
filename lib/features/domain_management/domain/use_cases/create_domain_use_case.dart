import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/domain_management/domain/entities/domain_entry.dart';
import 'package:multi_catalog_system/features/domain_management/domain/repositories/domain_repository.dart';

class CreateDomainUseCase {
  final DomainRepository repository;

  CreateDomainUseCase({required this.repository});

  Future<Either<Failure, DomainEntry>> call({required DomainEntry entry}) {
    return repository.create(entry: entry);
  }
}
