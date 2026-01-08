import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/legal_document/data/models/picked_document_file.dart';
import 'package:multi_catalog_system/features/legal_document/domain/entries/legal_document_entry.dart';

abstract class LegalDocumentRepository {
  Future<Either<Failure, List<LegalDocumentEntry>>> getAll({String? search});
  Future<Either<Failure, LegalDocumentEntry>> getById(String id);
  Future<Either<Failure, LegalDocumentEntry>> create({
    required LegalDocumentEntry entry,
    PickedDocumentFile? file,
  });
  Future<Either<Failure, List<LegalDocumentEntry>>> createMany(
    List<LegalDocumentEntry> entries,
  );
  Future<Either<Failure, List<LegalDocumentEntry>>> upsertMany(
    List<LegalDocumentEntry> entries,
  );
  Future<Either<Failure, LegalDocumentEntry>> update({
    required LegalDocumentEntry entry,
    PickedDocumentFile? file,
  });
  Future<Either<Failure, void>> delete(String id);
}
