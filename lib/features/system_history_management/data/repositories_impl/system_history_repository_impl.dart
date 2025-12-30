import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/system_history_management/data/data_sources/system_history_remote_data_source.dart';
import 'package:multi_catalog_system/features/system_history_management/data/models/system_history_model.dart';
import 'package:multi_catalog_system/features/system_history_management/domain/entries/system_history_entry.dart';
import 'package:multi_catalog_system/features/system_history_management/domain/repositories/system_history_repository.dart';

class SystemHistoryRepositoryImpl implements SystemHistoryRepository {
  final SystemHistoryRemoteDataSource remoteDataSource;

  SystemHistoryRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, List<SystemHistoryEntry>>> getAll({
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
  Future<Either<Failure, SystemHistoryEntry>> getById(String id) async {
    try {
      final model = await remoteDataSource.getById(id);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
    }
  }
}
