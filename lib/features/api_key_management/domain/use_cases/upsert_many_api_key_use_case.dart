import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/api_key_management/domain/entities/api_key_entry.dart';
import 'package:multi_catalog_system/features/api_key_management/domain/repositories/api_key_repository.dart';

class UpsertManyApiKeyUseCase {
  final ApiKeyRepository repository;

  UpsertManyApiKeyUseCase({required this.repository});

  Future<Either<Failure, List<ApiKeyEntry>>> call({
    required List<ApiKeyEntry> entries,
  }) async {
    return repository.upsertMany(entries: entries);
  }
}
