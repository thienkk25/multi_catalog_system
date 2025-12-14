import 'package:multi_catalog_system/features/domain_management/domain/entities/domain_entry.dart';
import 'package:multi_catalog_system/features/domain_management/domain/repositories/domain_repository.dart';

class UpdateDomainUseCase {
  final DomainRepository repository;
  UpdateDomainUseCase(this.repository);

  Future<DomainEntry> call(DomainEntry entry) async {
    return repository.update(entry);
  }
}
