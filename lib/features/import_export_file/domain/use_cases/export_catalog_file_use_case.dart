import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/import_export_file/domain/repositories/export_file_repository.dart';

class ExportCatalogFileUseCase {
  final ExportFileRepository repository;

  ExportCatalogFileUseCase({required this.repository});

  Future<Either<Failure, void>> call({String? format}) {
    return repository.exportCatalogFile(format: format);
  }
}
