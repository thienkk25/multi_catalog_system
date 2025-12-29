import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/api_key_management/data/data_sources/api_key_remote_data_source.dart';
import 'package:multi_catalog_system/features/api_key_management/data/models/api_key_model.dart';
import 'package:multi_catalog_system/features/api_key_management/domain/domain.dart';

class ApiKeyRepositoryImpl implements ApiKeyRepository {
  final ApiKeyRemoteDataSource remoteDataSource;

  ApiKeyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ApiKeyEntry>> create(ApiKeyEntry entry) async {
    try {
      final model = await remoteDataSource.create(
        ApiKeyModel.fromEntity(entry),
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<ApiKeyEntry>>> createMany(
    List<ApiKeyEntry> entries,
  ) async {
    try {
      final models = await remoteDataSource.createMany(
        entries.map((e) => ApiKeyModel.fromEntity(e)).toList(),
      );
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ApiKeyEntry>> getById(String id) async {
    try {
      final model = await remoteDataSource.getById(id);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<ApiKeyEntry>>> getAll({String? search}) async {
    try {
      final models = await remoteDataSource.getAll(search: search);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ApiKeyEntry>> update(ApiKeyEntry entry) async {
    try {
      final model = await remoteDataSource.update(
        ApiKeyModel.fromEntity(entry),
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<ApiKeyEntry>>> upsertMany(
    List<ApiKeyEntry> entries,
  ) async {
    try {
      final models = await remoteDataSource.upsertMany(
        entries.map((e) => ApiKeyModel.fromEntity(e)).toList(),
      );
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> delete(String id) async {
    try {
      await remoteDataSource.delete(id);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
    }
  }
}
