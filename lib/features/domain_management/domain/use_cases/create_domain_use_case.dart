import 'package:multi_catalog_system/features/domain_management/domain/entities/domain_entry.dart';
import 'package:multi_catalog_system/features/domain_management/domain/repositories/domain_repository.dart';

class CreateDomainUseCase {
  final DomainRepository repository;

  CreateDomainUseCase({required this.repository});

  Future<DomainEntry> call(DomainEntry entry) async {
    return await repository.create(entry);
  }
}
