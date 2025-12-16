import 'package:multi_catalog_system/features/domain_management/domain/entities/domain_entry.dart';
import 'package:multi_catalog_system/features/domain_management/domain/repositories/domain_repository.dart';

class GetAllDomainUseCase {
  final DomainRepository repository;

  GetAllDomainUseCase({required this.repository});

  Future<List<DomainEntry>> call() async {
    return await repository.getAll();
  }
}
