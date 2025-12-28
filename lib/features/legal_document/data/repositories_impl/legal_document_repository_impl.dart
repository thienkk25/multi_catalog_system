import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/legal_document/data/data_sources/legal_document_remote_data_source.dart';
import 'package:multi_catalog_system/features/legal_document/data/models/legal_document_model.dart';
import 'package:multi_catalog_system/features/legal_document/domain/domain.dart';

class LegalDocumentRepositoryImpl implements LegalDocumentRepository {
  final LegalDocumentRemoteDataSource remoteDataSource;

  LegalDocumentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, LegalDocumentEntry>> create(
    LegalDocumentEntry entry,
  ) async {
    try {
      final model = await remoteDataSource.create(
        LegalDocumentModel.fromEntity(entry),
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<LegalDocumentEntry>>> createMany(
    List<LegalDocumentEntry> entries,
  ) async {
    try {
      final models = await remoteDataSource.createMany(
        entries.map((e) => LegalDocumentModel.fromEntity(e)).toList(),
      );
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, LegalDocumentEntry>> getById(String id) async {
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
  Future<Either<Failure, List<LegalDocumentEntry>>> getAll({
    String? search,
  }) async {
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
  Future<Either<Failure, LegalDocumentEntry>> update(
    LegalDocumentEntry entry,
  ) async {
    try {
      final model = await remoteDataSource.update(
        LegalDocumentModel.fromEntity(entry),
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<LegalDocumentEntry>>> upsertMany(
    List<LegalDocumentEntry> entries,
  ) async {
    try {
      final models = await remoteDataSource.upsertMany(
        entries.map((e) => LegalDocumentModel.fromEntity(e)).toList(),
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
