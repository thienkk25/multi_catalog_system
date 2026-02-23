import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/domain/entities/page/page_entry.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/legal_document/domain/entities/legal_document_entry.dart';
import 'package:multi_catalog_system/features/legal_document/domain/repositories/legal_document_repository.dart';

class GetAllLegalDocumentUseCase {
  final LegalDocumentRepository repository;

  GetAllLegalDocumentUseCase({required this.repository});

  Future<Either<Failure, PageEntry<LegalDocumentEntry>>> call({
    String? search,
    int? page,
    int? limit,
    String? sortBy,
    String? sort,
    Map<String, dynamic>? filter,
  }) {
    return repository.getAll(
      search: search,
      page: page,
      limit: limit,
      sortBy: sortBy,
      sort: sort,
      filter: filter,
    );
  }
}
