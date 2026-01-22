import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/data/models/picked_document_file/picked_document_file.dart';
import 'package:multi_catalog_system/features/import_file/domain/repositories/import_file_repository.dart';

class ImportFileRepositoryImpl implements ImportFileRepository {
  @override
  Future<Either<String, void>> importFile({
    required PickedDocumentFile file,
    required String table,
  }) {
    // TODO: implement importFile
    throw UnimplementedError();
  }
}
