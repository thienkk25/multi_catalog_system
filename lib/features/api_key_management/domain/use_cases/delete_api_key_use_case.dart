import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/api_key_management/domain/repositories/api_key_repository.dart';

class DeleteApiKeyUseCase {
  final ApiKeyRepository repository;

  DeleteApiKeyUseCase({required this.repository});

  Future<Either<Failure, void>> call(String id) async {
    return repository.delete(id);
  }
}
