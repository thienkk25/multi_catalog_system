import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/domain/entities/domain/domain_ref_entry.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/catalog_lookup/domain/repositories/catalog_lookup_repository.dart';

class GetDomainRefUseCase {
  final CatalogLookupRepository repository;
  GetDomainRefUseCase({required this.repository});

  Future<Either<Failure, List<DomainRefEntry>>> call() {
    return repository.getDomainsRef();
  }
}
