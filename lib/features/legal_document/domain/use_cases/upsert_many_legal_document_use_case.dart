import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/legal_document/domain/entries/legal_document_entry.dart';
import 'package:multi_catalog_system/features/legal_document/domain/repositories/legal_document_repository.dart';

class UpsertManyLegalDocumentUseCase {
  final LegalDocumentRepository repository;

  UpsertManyLegalDocumentUseCase({required this.repository});

  Future<Either<Failure, List<LegalDocumentEntry>>> call(
    List<LegalDocumentEntry> entries,
  ) async {
    return await repository.upsertMany(entries);
  }
}
