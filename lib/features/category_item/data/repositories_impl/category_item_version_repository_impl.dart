import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/exception_mapper.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/category_item/data/data_sources/category_item_version_remote_data_source.dart';
import 'package:multi_catalog_system/features/category_item/data/models/category_item_version_model.dart';
import 'package:multi_catalog_system/features/category_item/domain/domain.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_version_entry.dart';
import 'package:multi_catalog_system/features/category_item/domain/repositories/category_item_version_repository.dart';

class CategoryItemVersionRepositoryImpl
    implements CategoryItemVersionRepository {
  final CategoryItemVersionRemoteDataSource remoteDataSource;

  CategoryItemVersionRepositoryImpl({required this.remoteDataSource});

  CategoryItemVersionEntry _toEntity(CategoryItemVersionModel model) =>
      CategoryItemVersionEntry(
        id: model.id,
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
    'category_item': {
      'group_id': entry.groupId,
      'code': entry.code,
      'name': entry.name,
      if (entry.description != null) 'description': entry.description,
    },
    'legal_document_ids': entry.legalDocuments?.map((e) => e.id).toList(),
  };

  Map<String, dynamic> _updatePayload(CategoryItemEntry entry) => {
    'category_item': {
      if (entry.groupId != null) 'group_id': entry.groupId,
      if (entry.code != null) 'code': entry.code,
      if (entry.name != null) 'name': entry.name,
      if (entry.description != null) 'description': entry.description,
    },
    if (entry.legalDocuments != null && entry.legalDocuments!.isNotEmpty)
      'legal_document_ids': entry.legalDocuments?.map((e) => e.id).toList(),
  };
  @override
  Future<Either<Failure, List<CategoryItemVersionEntry>>> getAll({
    String? search,
  }) async {
    try {
      final models = await remoteDataSource.getAll(search: search);
      return Right(models.map((m) => _toEntity(m)).toList());
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
  }) async {
    try {
      final model = await remoteDataSource.updateVersion(
        id: entry.id!,
        data: _updatePayload(entry),
      );
      return Right(_toEntity(model));
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteVersion({required String id}) async {
    try {
      await remoteDataSource.deleteVersion(id: id);
      return const Right(unit);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> approveVersion({required String id}) async {
    try {
      await remoteDataSource.approveVersion(id: id);
      return const Right(unit);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> rejectVersion({
    required String id,
    required String rejectReason,
  }) async {
    try {
      await remoteDataSource.rejectVersion(id: id, rejectReason: rejectReason);
      return const Right(unit);
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
