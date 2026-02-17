import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/domain/entities/page/page_entry.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/core/data/models/picked_document_file/picked_document_file.dart';
import 'package:multi_catalog_system/features/legal_document/domain/entities/legal_document_entry.dart';

abstract class LegalDocumentRepository {
  Future<Either<Failure, PageEntry<LegalDocumentEntry>>> getAll({
    String? search,
    int? page,
    int? limit,
    Map<String, dynamic>? filter,
  });
  Future<Either<Failure, List<LegalDocumentEntry>>> getAllHasFile({
    String? search,
  });
  Future<Either<Failure, LegalDocumentEntry>> getById({required String id});
  Future<Either<Failure, LegalDocumentEntry>> create({
    required LegalDocumentEntry entry,
    PickedDocumentFile? file,
  });
  Future<Either<Failure, LegalDocumentEntry>> update({
    required LegalDocumentEntry entry,
    PickedDocumentFile? file,
  });
  Future<Either<Failure, void>> delete({required String id});
}
