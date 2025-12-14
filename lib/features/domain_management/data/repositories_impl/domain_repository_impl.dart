import 'package:multi_catalog_system/features/domain_management/data/data_sources/domain_remote_data_source.dart';
import 'package:multi_catalog_system/features/domain_management/data/models/domain_model.dart';
import 'package:multi_catalog_system/features/domain_management/domain/domain.dart';

class DomainRepositoryImpl implements DomainRepository {
  final DomainRemoteDataSource remoteDataSource;

  DomainRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DomainEntry> create(DomainEntry entry) async {
    final returnedModel = await remoteDataSource.create(
      DomainModel.fromEntity(entry),
    );
    return returnedModel.toEntity();
  }

  @override
  Future<List<DomainEntry>> createMany(List<DomainEntry> entries) {
    return remoteDataSource
        .createMany(entries.map((e) => DomainModel.fromEntity(e)).toList())
        .then((models) => models.map((model) => model.toEntity()).toList());
  }

  @override
  Future<void> delete(String id) {
    return remoteDataSource.delete(id);
  }

  @override
  Future<List<DomainEntry>> getAll() {
    return remoteDataSource.getAll().then(
      (models) => models.map((model) => model.toEntity()).toList(),
    );
  }

  @override
  Future<DomainEntry> getById(String id) {
    return remoteDataSource.getById(id).then((model) => model.toEntity());
  }

  @override
  Future<DomainEntry> update(DomainEntry entry) {
    return remoteDataSource
        .update(DomainModel.fromEntity(entry))
        .then((model) => model.toEntity());
  }

  @override
  Future<List<DomainEntry>> upsertMany(List<DomainEntry> entries) {
    return remoteDataSource
        .upsertMany(entries.map((e) => DomainModel.fromEntity(e)).toList())
        .then((models) => models.map((model) => model.toEntity()).toList());
  }
}
