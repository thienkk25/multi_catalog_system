import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/exception_mapper.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/import_export_file/data/data_sources/export_file_remote_data_source.dart';
import 'package:multi_catalog_system/features/import_export_file/domain/repositories/export_file_repository.dart';

class ExportFileRepositoryImpl implements ExportFileRepository {
  final ExportFileRemoteDataSource remoteDataSource;

  ExportFileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Unit>> exportCatalogFile({String? format}) async {
    try {
      await remoteDataSource.exportCatalogFile(format: format);
      return Right(unit);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> exportSingleFile({
    required int type,
    String? format,
  }) async {
    try {
      await remoteDataSource.exportSingleFile(type: type, format: format);
      return Right(unit);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
