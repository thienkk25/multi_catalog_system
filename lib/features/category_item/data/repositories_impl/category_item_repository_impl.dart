import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/domain/entities/domain/domain_ref_entry.dart';
import 'package:multi_catalog_system/core/domain/entities/page/page_entry.dart';
import 'package:multi_catalog_system/core/domain/entities/page/pagination_entry.dart';
import 'package:multi_catalog_system/core/error/exception_mapper.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/category_item/data/data_sources/category_item_remote_data_source.dart';
import 'package:multi_catalog_system/features/category_item/data/models/category_item_model.dart';
import 'package:multi_catalog_system/features/category_item/domain/domain.dart';
import 'package:multi_catalog_system/features/legal_document/data/models/legal_document_model.dart';
import 'package:multi_catalog_system/features/legal_document/domain/entities/legal_document_entry.dart';

class CategoryItemRepositoryImpl implements CategoryItemRepository {
  final CategoryItemRemoteDataSource remoteDataSource;

  CategoryItemRepositoryImpl({required this.remoteDataSource});

  CategoryItemEntry _toEntityCategoryItem(CategoryItemModel model) =>
      CategoryItemEntry(
        id: model.id,
        code: model.code,
        name: model.name,
        description: model.description,
        status: model.status,
        domainId: model.domainId,
        groupId: model.groupId,
        group: CategoryGroupRefEntry(
          id: model.group.id,
          name: model.group.name,
          code: model.group.code,
        ),
        domain: DomainRefEntry(
          id: model.domain.id,
          name: model.domain.name,
          code: model.domain.code,
        ),
        legalDocuments: model.legalDocuments
            ?.map((e) => _toEntityLegalDocument(e))
            .toList(),
        createdByName: model.createdByName,
        updatedByName: model.updatedByName,
        createdAt: model.createdAt,
        updatedAt: model.updatedAt,
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
    'category_item': {
      'group_id': entry.groupId,
      'code': entry.code,
      'name': entry.name,
      'status': entry.status,
      if (entry.description != null) 'description': entry.description,
    },
    'legal_document_ids': entry.legalDocuments?.map((e) => e.id).toList(),
  };

  Map<String, dynamic> _updatePayload(CategoryItemEntry entry) => {
    'category_item': {
      if (entry.groupId != null) 'group_id': entry.groupId,
      if (entry.code != null) 'code': entry.code,
      if (entry.name != null) 'name': entry.name,
      if (entry.status != null) 'status': entry.status,
      if (entry.description != null) 'description': entry.description,
    },
    if (entry.legalDocuments != null && entry.legalDocuments!.isNotEmpty)
      'legal_document_ids': entry.legalDocuments?.map((e) => e.id).toList(),
  };

  @override
  Future<Either<Failure, CategoryItemEntry>> create({
    required CategoryItemEntry entry,
  }) async {
    try {
      final model = await remoteDataSource.create(data: _createPayload(entry));
      return Right(_toEntityCategoryItem(model));
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryItemEntry>> getById({
    required String id,
  }) async {
    try {
      final model = await remoteDataSource.getById(id: id);
      return Right(_toEntityCategoryItem(model));
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PageEntry<CategoryItemEntry>>> getAll({
    String? search,
    int? page,
    int? limit,
    String? sortBy,
    String? sort,
    Map<String, dynamic>? filter,
  }) async {
    try {
      final models = await remoteDataSource.getAll(
        search: search,
        page: page,
        limit: limit,
        sortBy: sortBy,
        sort: sort,
        filter: filter,
      );
      return Right(
        PageEntry<CategoryItemEntry>(
          entries: models.data.map((m) => _toEntityCategoryItem(m)).toList(),
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
  Future<Either<Failure, CategoryItemEntry>> update({
    required CategoryItemEntry entry,
  }) async {
    try {
      final model = await remoteDataSource.update(
        id: entry.id!,
        data: _updatePayload(entry),
      );
      return Right(_toEntityCategoryItem(model));
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
}
