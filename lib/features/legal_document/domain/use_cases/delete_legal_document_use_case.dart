import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/legal_document/domain/repositories/legal_document_repository.dart';

class DeleteLegalDocumentUseCase {
  final LegalDocumentRepository repository;

  DeleteLegalDocumentUseCase({required this.repository});

  Future<Either<Failure, void>> call({required String id}) async {
    return repository.delete(id: id);
  }
}
