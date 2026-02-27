import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/domain/entities/category_item/category_item_ref_entry.dart';
import 'package:multi_catalog_system/core/domain/entities/domain/domain_ref_entry.dart';
import 'package:multi_catalog_system/core/domain/entities/page/page_entry.dart';
import 'package:multi_catalog_system/core/domain/entities/page/pagination_entry.dart';
import 'package:multi_catalog_system/core/error/exception_mapper.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/category_item/data/data_sources/category_item_version_remote_data_source.dart';
import 'package:multi_catalog_system/features/category_item/data/models/category_item_version_model.dart';
import 'package:multi_catalog_system/features/category_item/domain/domain.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_version_entry.dart';
import 'package:multi_catalog_system/features/legal_document/data/models/legal_document_model.dart';
import 'package:multi_catalog_system/features/legal_document/domain/entities/legal_document_entry.dart';

class CategoryItemVersionRepositoryImpl
    implements CategoryItemVersionRepository {
  final CategoryItemVersionRemoteDataSource remoteDataSource;

  CategoryItemVersionRepositoryImpl({required this.remoteDataSource});

  CategoryItemVersionEntry _toEntity(CategoryItemVersionModel model) =>
      CategoryItemVersionEntry(
        id: model.id,
        domainId: model.domainId,
        itemId: model.itemId,
        domain: DomainRefEntry(
          id: model.domain.id,
          name: model.domain.name,
          code: model.domain.code,
        ),
        item: CategoryItemRefEntry(
          id: model.item?.id,
          name: model.item?.name,
          code: model.item?.code,
        ),
        oldValue: model.oldValue,
        newValue: model.newValue,
        changeSummary: model.changeSummary,
        changeType: model.changeType,
        status: model.status,
        legalDocuments: model.legalDocuments
            ?.map((e) => _toEntityLegalDocument(e))
            .toList(),
        changeBy: model.changeBy,
        changeByName: model.changeByName,
        approvedBy: model.approvedBy,
        approvedByName: model.approvedByName,
        rejectReason: model.rejectReason,
        appliedAt: model.appliedAt,
        createdAt: model.createdAt,
      );
  LegalDocumentEntry _toEntityLegalDocument(LegalDocumentModel model) =>
      LegalDocumentEntry(
        id: model.id,
        code: model.code,
        title: model.title,
        description: model.description,
        type: model.type,
        status: model.status,
        issuedByName: model.issuedByName,
        issueDate: model.issueDate,
        effectiveDate: model.effectiveDate,
        expiryDate: model.expiryDate,
        fileName: model.fileName,
        fileUrl: model.fileUrl,
        createdAt: model.createdAt,
        updatedAt: model.updatedAt,
      );
  Map<String, dynamic> _createPayload(CategoryItemEntry entry) => {
    'version_data': {
      'domain_id': entry.domainId,
      'group_id': entry.groupId,
      'code': entry.code,
      'name': entry.name,
      'status': entry.status,
      if (entry.description != null) 'description': entry.description,
    },
    'legal_document_ids': entry.legalDocuments?.map((e) => e.id).toList(),
  };

  Map<String, dynamic> _updatePayload(int? type, CategoryItemEntry entry) => {
    if (type != null) 'version_type': type,
    'version_data': {
      'domain_id': entry.domainId,
      'group_id': entry.groupId,
      if (entry.code != null) 'code': entry.code,
      if (entry.name != null) 'name': entry.name,
      if (entry.status != null) 'status': entry.status,
      if (entry.description != null) 'description': entry.description,
    },
    if (entry.legalDocuments != null && entry.legalDocuments!.isNotEmpty)
      'legal_document_ids': entry.legalDocuments?.map((e) => e.id).toList(),
  };
  @override
  Future<Either<Failure, PageEntry<CategoryItemVersionEntry>>> getAll({
    String? itemId,
    String? search,
    int? page,
    int? limit,
    String? sortBy,
    String? sort,
    Map<String, dynamic>? filter,
  }) async {
    try {
      final models = await remoteDataSource.getAll(
        itemId: itemId,
        search: search,
        page: page,
        limit: limit,
        sortBy: sortBy,
        sort: sort,
        filter: filter,
      );
      return Right(
        PageEntry<CategoryItemVersionEntry>(
          entries: models.data.map((m) => _toEntity(m)).toList(),
          pagination: PaginationEntry(
            page: models.pagination.page,
            limit: models.pagination.limit,
            total: models.pagination.total,
            totalPages: models.pagination.totalPages,
            hasMore: models.pagination.hasMore,
          ),
        ),
      );
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryItemVersionEntry>> getById({
    required String id,
  }) async {
    try {
      final model = await remoteDataSource.getById(id: id);
      return Right(_toEntity(model));
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PageEntry<CategoryItemVersionEntry>>>
  getHistoryVersion({required String itemId, int? page, int? limit}) async {
    try {
      final models = await remoteDataSource.getHistoryVersion(
        itemId: itemId,
        page: page,
        limit: limit,
      );
      return Right(
        PageEntry<CategoryItemVersionEntry>(
          entries: models.data.map((m) => _toEntity(m)).toList(),
          pagination: PaginationEntry(
            page: models.pagination.page,
            limit: models.pagination.limit,
            total: models.pagination.total,
            totalPages: models.pagination.totalPages,
            hasMore: models.pagination.hasMore,
          ),
        ),
      );
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryItemVersionEntry>> createVersion({
    required CategoryItemEntry entry,
  }) async {
    try {
      final model = await remoteDataSource.createVersion(
        data: _createPayload(entry),
      );
      return Right(_toEntity(model));
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryItemVersionEntry>> updateVersion({
    required CategoryItemEntry entry,
    required String id,
    int? type,
  }) async {
    try {
      final model = await remoteDataSource.updateVersion(
        id: id,
        data: _updatePayload(type, entry),
      );
      return Right(_toEntity(model));
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryItemVersionEntry>> deleteVersion({
    required String id,
    required String domainId,
  }) async {
    try {
      final model = await remoteDataSource.deleteVersion(
        id: id,
        domainId: domainId,
      );
      return Right(_toEntity(model));
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryItemVersionEntry>> approveVersion({
    required String id,
  }) async {
    try {
      final model = await remoteDataSource.approveVersion(id: id);
      return Right(_toEntity(model));
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryItemVersionEntry>> rejectVersion({
    required String id,
    required String rejectReason,
  }) async {
    try {
      final model = await remoteDataSource.rejectVersion(
        id: id,
        rejectReason: rejectReason,
      );
      return Right(_toEntity(model));
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> delete({required String id}) async {
    try {
      await remoteDataSource.delete(id: id);
      return const Right(unit);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryItemVersionEntry>> rollbackVersion({
    required String id,
  }) async {
    try {
      final model = await remoteDataSource.rollbackVersion(id: id);
      return Right(_toEntity(model));
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
