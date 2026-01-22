import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/data/models/picked_document_file/picked_document_file.dart';

abstract class ImportFileRepository {
  Future<Either<String, void>> importFile({
    required List<PickedDocumentFile> files,
    required String table,
  });
}
