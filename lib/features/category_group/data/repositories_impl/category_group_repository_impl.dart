import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/category_group/data/data_sources/category_group_remote_data_source.dart';
import 'package:multi_catalog_system/features/category_group/data/models/category_group_model.dart';
import 'package:multi_catalog_system/features/category_group/domain/entities/category_group_entry.dart';
import 'package:multi_catalog_system/features/category_group/domain/repositories/category_group_repository.dart';

class CategoryGroupRepositoryImpl implements CategoryGroupRepository {
  final CategoryGroupRemoteDataSource remoteDataSource;

  CategoryGroupRepositoryImpl({required this.remoteDataSource});

  CategoryGroupEntry _toEntity(CategoryGroupModel model) => CategoryGroupEntry(
    id: model.id,
    domainId: model.domainId,
    code: model.code,
    name: model.name,
    description: model.description,
    createdAt: model.createdAt,
    updatedAt: model.updatedAt,
  );

  Map<String, dynamic> _createPayload(CategoryGroupEntry entry) => {
    'domain_id': entry.domainId,
    'code': entry.code,
    'name': entry.name,
    if (entry.description != null) 'description': entry.description,
  };

  Map<String, dynamic> _updatePayload(CategoryGroupEntry entry) => {
    if (entry.domainId != null) 'domain_id': entry.domainId,
    if (entry.code != null) 'code': entry.code,
    if (entry.name != null) 'name': entry.name,
    if (entry.description != null) 'description': entry.description,
  };

  @override
  Future<Either<Failure, CategoryGroupEntry>> create({
    required CategoryGroupEntry entry,
  }) async {
    try {
      final model = await remoteDataSource.create(data: _createPayload(entry));
      return Right(_toEntity(model));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<CategoryGroupEntry>>> createMany({
    required List<CategoryGroupEntry> entries,
  }) async {
    try {
      final models = await remoteDataSource.createMany(
        data: entries.map((e) => _createPayload(e)).toList(),
      );
      return Right(models.map((m) => _toEntity(m)).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CategoryGroupEntry>> getById({
    required String id,
  }) async {
    try {
      final model = await remoteDataSource.getById(id: id);
      return Right(_toEntity(model));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<CategoryGroupEntry>>> getAll({
    String? search,
  }) async {
    try {
      final models = await remoteDataSource.getAll(search: search);
      return Right(models.map((m) => _toEntity(m)).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CategoryGroupEntry>> update({
    required CategoryGroupEntry entry,
  }) async {
    try {
      final model = await remoteDataSource.update(
        id: entry.id!,
        data: _updatePayload(entry),
      );
      return Right(_toEntity(model));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<CategoryGroupEntry>>> upsertMany({
    required List<CategoryGroupEntry> entries,
  }) async {
    try {
      final models = await remoteDataSource.upsertMany(
        data: entries.map((e) => _updatePayload(e)).toList(),
      );
      return Right(models.map((m) => _toEntity(m)).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> delete({required String id}) async {
    try {
      await remoteDataSource.delete(id: id);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
    }
  }
}
