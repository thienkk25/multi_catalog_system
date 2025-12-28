import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/legal_document/domain/entries/legal_document_entry.dart';
import 'package:multi_catalog_system/features/legal_document/domain/repositories/legal_document_repository.dart';

class GetAllLegalDocumentUseCase {
  final LegalDocumentRepository repository;

  GetAllLegalDocumentUseCase({required this.repository});

  Future<Either<Failure, List<LegalDocumentEntry>>> call({
    String? search,
  }) async {
    return repository.getAll(search: search);
  }
}
