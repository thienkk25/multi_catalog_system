import 'package:multi_catalog_system/features/domain_management/domain/entities/domain_entry.dart';
import 'package:multi_catalog_system/features/domain_management/domain/repositories/domain_repository.dart';

class GetByIdDomainUseCase {
  final DomainRepository repository;

  GetByIdDomainUseCase({required this.repository});

  Future<DomainEntry> call(String id) async {
    return await repository.getById(id);
  }
}
