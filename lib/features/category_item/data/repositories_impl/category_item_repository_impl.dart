import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/category_item/data/data_sources/category_item_remote_data_source.dart';
import 'package:multi_catalog_system/features/category_item/data/models/category_item_model.dart';
import 'package:multi_catalog_system/features/category_item/domain/domain.dart';

class CategoryItemRepositoryImpl implements CategoryItemRepository {
  final CategoryItemRemoteDataSource remoteDataSource;

  CategoryItemRepositoryImpl({required this.remoteDataSource});

  CategoryItemEntry _toEntity(CategoryItemModel model) => CategoryItemEntry(
    id: model.id,
    code: model.code,
    name: model.name,
    description: model.description,
    status: model.status,
    groupId: model.groupId,
    createdAt: model.createdAt,
    updatedAt: model.updatedAt,
  );

  Map<String, dynamic> _createPayload(CategoryItemEntry entry) => {
    'code': entry.code,
    'name': entry.name,
    'description': entry.description,
    'status': entry.status,
    'groupId': entry.groupId,
  };

  Map<String, dynamic> _updatePayload(CategoryItemEntry entry) => {
    'code': entry.code,
    'name': entry.name,
    'description': entry.description,
    'status': entry.status,
    'groupId': entry.groupId,
  };

  @override
  Future<Either<Failure, CategoryItemEntry>> create({
    required CategoryItemEntry entry,
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
  Future<Either<Failure, List<CategoryItemEntry>>> createMany({
    required List<CategoryItemEntry> entries,
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
  Future<Either<Failure, CategoryItemEntry>> getById({
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
  Future<Either<Failure, List<CategoryItemEntry>>> getAll({
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
  Future<Either<Failure, CategoryItemEntry>> update({
    required CategoryItemEntry entry,
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
  Future<Either<Failure, List<CategoryItemEntry>>> upsertMany({
    required List<CategoryItemEntry> entries,
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
