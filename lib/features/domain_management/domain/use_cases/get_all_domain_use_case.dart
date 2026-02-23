import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/domain/entities/page/page_entry.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/domain_management/domain/entities/domain_entry.dart';
import 'package:multi_catalog_system/features/domain_management/domain/repositories/domain_repository.dart';

class GetAllDomainUseCase {
  final DomainRepository repository;

  GetAllDomainUseCase({required this.repository});

  Future<Either<Failure, PageEntry<DomainEntry>>> call({
    String? search,
    int? page,
    int? limit,
    String? sortBy,
    String? sort,
    Map<String, dynamic>? filter,
  }) {
    return repository.getAll(
      search: search,
      page: page,
      limit: limit,
      sortBy: sortBy,
      sort: sort,
      filter: filter,
    );
  }
}
