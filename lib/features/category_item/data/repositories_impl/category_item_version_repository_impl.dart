import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/domain/entities/page/page_entry.dart';
import 'package:multi_catalog_system/core/domain/entities/page/pagination_entry.dart';
import 'package:multi_catalog_system/core/error/exception_mapper.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/category_item/data/data_sources/category_item_version_remote_data_source.dart';
import 'package:multi_catalog_system/features/category_item/data/models/category_item_version_model.dart';
import 'package:multi_catalog_system/features/category_item/domain/domain.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_version_entry.dart';

class CategoryItemVersionRepositoryImpl
    implements CategoryItemVersionRepository {
  final CategoryItemVersionRemoteDataSource remoteDataSource;

  CategoryItemVersionRepositoryImpl({required this.remoteDataSource});

  CategoryItemVersionEntry _toEntity(CategoryItemVersionModel model) =>
      CategoryItemVersionEntry(
        id: model.id,
        domainId: model.domainId,
        itemId: model.itemId,
        oldValue: model.oldValue,
        newValue: model.newValue,
        changeSummary: model.changeSummary,
        changeType: model.changeType,
        status: model.status,
        changeBy: model.changeBy,
        approvedBy: model.approvedBy,
        rejectReason: model.rejectReason,
        appliedAt: model.appliedAt,
        createdAt: model.createdAt,
      );

  Map<String, dynamic> _createPayload(CategoryItemEntry entry) => {
    'version_data': {
      'domain_id': entry.domain?.id,
      'group_id': entry.group?.id,
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
      if (entry.domain?.id != null) 'domain_id': entry.domain?.id,
      if (entry.group?.id != null) 'group_id': entry.group?.id,
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
    Map<String, dynamic>? filter,
  }) async {
    try {
      final models = await remoteDataSource.getAll(
        itemId: itemId,
        search: search,
        page: page,
        limit: limit,
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
  }) async {
    try {
      final model = await remoteDataSource.deleteVersion(id: id);
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
