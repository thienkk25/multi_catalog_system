import 'package:multi_catalog_system/features/domain_management/domain/entities/domain_entry.dart';
import 'package:multi_catalog_system/features/domain_management/domain/repositories/domain_repository.dart';

class CreateManyDomainUseCase {
  final DomainRepository repository;

  CreateManyDomainUseCase({required this.repository});

  Future<List<DomainEntry>> call(List<DomainEntry> entries) async {
    return await repository.createMany(entries);
  }
}
