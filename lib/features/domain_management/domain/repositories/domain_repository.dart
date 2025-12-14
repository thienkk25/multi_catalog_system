import 'package:multi_catalog_system/features/domain_management/domain/entities/domain_entry.dart';

abstract class DomainRepository {
  Future<List<DomainEntry>> getAll();
  Future<DomainEntry> getById(String id);
  Future<DomainEntry> create(DomainEntry entry);
  Future<List<DomainEntry>> createMany(List<DomainEntry> entries);
  Future<List<DomainEntry>> upsertMany(List<DomainEntry> entries);
  Future<DomainEntry> update(DomainEntry entry);
  Future<void> delete(String id);
}
