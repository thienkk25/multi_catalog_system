import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/domain/entities/page/page_entry.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/api_key_management/domain/entities/api_key_entry.dart';
import 'package:multi_catalog_system/features/api_key_management/domain/repositories/api_key_repository.dart';

class GetAllApiKeyUseCase {
  final ApiKeyRepository repository;

  GetAllApiKeyUseCase({required this.repository});

  Future<Either<Failure, PageEntry<ApiKeyEntry>>> call({
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
