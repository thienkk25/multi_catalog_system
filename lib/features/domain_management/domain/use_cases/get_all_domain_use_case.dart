import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/domain_management/domain/entities/domain_entry.dart';
import 'package:multi_catalog_system/features/domain_management/domain/repositories/domain_repository.dart';

class GetAllDomainUseCase {
  final DomainRepository repository;

  GetAllDomainUseCase({required this.repository});

  Future<Either<Failure, List<DomainEntry>>> call({String? search}) async {
    return await repository.getAll(search: search);
  }
}
