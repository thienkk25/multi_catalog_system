import 'package:multi_catalog_system/features/domain_management/domain/repositories/domain_repository.dart';

class DeleteDomainUseCase {
  final DomainRepository repository;
  DeleteDomainUseCase(this.repository);

  Future<void> call(String id) async {
    return repository.delete(id);
  }
}
