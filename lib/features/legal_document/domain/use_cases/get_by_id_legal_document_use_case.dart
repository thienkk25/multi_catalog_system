import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/legal_document/domain/entities/legal_document_entry.dart';
import 'package:multi_catalog_system/features/legal_document/domain/repositories/legal_document_repository.dart';

class GetByIdLegalDocumentUseCase {
  final LegalDocumentRepository repository;

  GetByIdLegalDocumentUseCase({required this.repository});

  Future<Either<Failure, LegalDocumentEntry>> call({required String id}) async {
    return repository.getById(id: id);
  }
}
