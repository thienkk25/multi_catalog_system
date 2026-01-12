import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/api_key_management/domain/entries/api_key_entry.dart';
import 'package:multi_catalog_system/features/api_key_management/domain/repositories/api_key_repository.dart';

class CreateApiKeyUseCase {
  final ApiKeyRepository repository;

  CreateApiKeyUseCase({required this.repository});

  Future<Either<Failure, ApiKeyEntry>> call({
    required ApiKeyEntry entry,
  }) async {
    return repository.create(entry: entry);
  }
}
