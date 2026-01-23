import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/data/models/picked_document_file/picked_document_file.dart';
import 'package:multi_catalog_system/core/error/exception_mapper.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/import_file/data/data_sources/import_file_remote_data_source.dart';
import 'package:multi_catalog_system/features/import_file/domain/repositories/import_file_repository.dart';

class ImportFileRepositoryImpl implements ImportFileRepository {
  final ImportFileRemoteDataSource remoteDataSource;

  ImportFileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Unit>> importSingleFile({
    required PickedDocumentFile file,
    required int type,
  }) async {
    try {
      await remoteDataSource.importSingleFile(file: file, type: type);
      return const Right(unit);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> importCatalogFile({
    required PickedDocumentFile file,
  }) async {
    try {
      await remoteDataSource.importCatalogFile(file: file);
      return const Right(unit);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
