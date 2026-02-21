import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/domain/entities/domain/domain_ref_entry.dart';
import 'package:multi_catalog_system/core/domain/entities/page/page_entry.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/domain_management/domain/repositories/domain_repository.dart';

class GetDomainLookupUseCase {
  final DomainRepository repository;

  GetDomainLookupUseCase({required this.repository});

  Future<Either<Failure, PageEntry<DomainRefEntry>>> call({
    int? page,
    int? limit,
  }) {
    return repository.lookup(page: page, limit: limit);
  }
}
