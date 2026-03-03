import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';

abstract class ExportFileRepository {
  Future<Either<Failure, void>> exportSingleFile({
    required int type,
    String? format,
  });
  Future<Either<Failure, void>> exportCatalogFile({String? format});
}
