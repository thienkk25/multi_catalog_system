import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/domain/entities/pagination/pagination_entry.dart';
import 'package:multi_catalog_system/core/error/exception_mapper.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/domain_management/data/data_sources/domain_remote_data_source.dart';
import 'package:multi_catalog_system/features/domain_management/data/models/domain_model.dart';
import 'package:multi_catalog_system/features/domain_management/domain/domain.dart';

class DomainRepositoryImpl implements DomainRepository {
  final DomainRemoteDataSource remoteDataSource;

  DomainRepositoryImpl({required this.remoteDataSource});

  DomainEntry _toEntity(DomainModel model) => DomainEntry(
    id: model.id,
    code: model.code,
    name: model.name,
    description: model.description,
    createdAt: model.createdAt,
    updatedAt: model.updatedAt,
  );

  Map<String, dynamic> _createPayload(DomainEntry entry) => {
    'code': entry.code,
    'name': entry.name,
    if (entry.description != null) 'description': entry.description,
  };

  Map<String, dynamic> _updatePayload(DomainEntry entry) => {
    if (entry.code != null) 'code': entry.code,
    if (entry.name != null) 'name': entry.name,
    if (entry.description != null) 'description': entry.description,
  };

  @override
  Future<Either<Failure, DomainEntry>> create({
    required DomainEntry entry,
  }) async {
    try {
      final model = await remoteDataSource.create(data: _createPayload(entry));
      return Right(_toEntity(model));
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DomainEntry>>> createMany({
    required List<DomainEntry> entries,
  }) async {
    try {
      final models = await remoteDataSource.createMany(
        data: entries.map((e) => _createPayload(e)).toList(),
      );
      return Right(models.map((m) => _toEntity(m)).toList());
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DomainEntry>> getById({required String id}) async {
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
  Future<Either<Failure, DomainPageEntry>> getAll({
    String? search,
    int? page,
    int? limit,
  }) async {
    try {
      final models = await remoteDataSource.getAll(
        search: search,
        page: page,
        limit: limit,
      );
      return Right(
        DomainPageEntry(
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
  Future<Either<Failure, DomainEntry>> update({
    required DomainEntry entry,
  }) async {
    try {
      final model = await remoteDataSource.update(
        data: _updatePayload(entry),
        id: entry.id!,
      );
      return Right(_toEntity(model));
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DomainEntry>>> upsertMany({
    required List<DomainEntry> entries,
  }) async {
    try {
      final models = await remoteDataSource.upsertMany(
        data: entries.map((e) => _updatePayload(e)).toList(),
      );
      return Right(models.map((m) => _toEntity(m)).toList());
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
