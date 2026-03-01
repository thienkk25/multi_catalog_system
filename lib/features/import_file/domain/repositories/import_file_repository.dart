import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/data/models/picked_document_file/picked_document_file.dart';
import 'package:multi_catalog_system/core/error/failures.dart';

abstract class ImportFileRepository {
  Future<Either<Failure, Map<String, dynamic>>> importSingleFile({
    required PickedDocumentFile file,
    required int type,
  });
  Future<Either<Failure, Map<String, dynamic>>> importCatalogFile({
    required PickedDocumentFile file,
  });
}
