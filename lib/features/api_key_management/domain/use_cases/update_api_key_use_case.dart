import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/api_key_management/domain/entities/api_key_entry.dart';
import 'package:multi_catalog_system/features/api_key_management/domain/repositories/api_key_repository.dart';

class UpdateApiKeyUseCase {
  final ApiKeyRepository repository;

  UpdateApiKeyUseCase({required this.repository});

  Future<Either<Failure, ApiKeyEntry>> call({
    required ApiKeyEntry entry,
  }) async {
    return repository.update(entry: entry);
  }
}
