import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/data/models/picked_document_file/picked_document_file.dart';
import 'package:multi_catalog_system/features/import_file/domain/repositories/import_file_repository.dart';

class ImportFileUseCase {
  final ImportFileRepository repository;
  ImportFileUseCase({required this.repository});
  Future<Either<String, void>> call({
    required List<PickedDocumentFile> files,
    required String table,
  }) {
    return repository.importFile(files: files, table: table);
  }
}
