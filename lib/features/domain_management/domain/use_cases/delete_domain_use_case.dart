import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/domain_management/domain/repositories/domain_repository.dart';

class DeleteDomainUseCase {
  final DomainRepository repository;

  DeleteDomainUseCase({required this.repository});

  Future<Either<Failure, void>> call(String id) async {
    return repository.delete(id);
  }
}
