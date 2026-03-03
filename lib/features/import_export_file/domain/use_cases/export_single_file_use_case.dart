import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/import_export_file/domain/repositories/export_file_repository.dart';

class ExportSingleFileUseCase {
  final ExportFileRepository repository;

  ExportSingleFileUseCase({required this.repository});

  Future<Either<Failure, void>> call({required int type, String? format}) {
    return repository.exportSingleFile(type: type, format: format);
  }
}
