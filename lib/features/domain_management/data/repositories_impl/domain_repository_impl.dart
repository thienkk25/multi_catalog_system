import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/domain_management/data/data_sources/domain_remote_data_source.dart';
import 'package:multi_catalog_system/features/domain_management/data/models/domain_model.dart';
import 'package:multi_catalog_system/features/domain_management/domain/domain.dart';

class DomainRepositoryImpl implements DomainRepository {
  final DomainRemoteDataSource remoteDataSource;

  DomainRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, DomainEntry>> create(DomainEntry entry) async {
    try {
      final model = await remoteDataSource.create(
        DomainModel.fromEntity(entry),
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<DomainEntry>>> createMany(
    List<DomainEntry> entries,
  ) async {
    try {
      final models = await remoteDataSource.createMany(
        entries.map((e) => DomainModel.fromEntity(e)).toList(),
      );
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, DomainEntry>> getById(String id) async {
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
  Future<Either<Failure, List<DomainEntry>>> getAll({String? search}) async {
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
  Future<Either<Failure, DomainEntry>> update(DomainEntry entry) async {
    try {
      final model = await remoteDataSource.update(
        DomainModel.fromEntity(entry),
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<DomainEntry>>> upsertMany(
    List<DomainEntry> entries,
  ) async {
    try {
      final models = await remoteDataSource.upsertMany(
        entries.map((e) => DomainModel.fromEntity(e)).toList(),
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
