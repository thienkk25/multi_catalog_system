import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/data/models/picked_document_file/picked_document_file.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/import_export_file/domain/repositories/import_file_repository.dart';

class ImportCatalogFileUseCase {
  final ImportFileRepository repository;

  ImportCatalogFileUseCase({required this.repository});

  Future<Either<Failure, Map<String, dynamic>>> call({
    required PickedDocumentFile file,
  }) {
    return repository.importCatalogFile(file: file);
  }
}
