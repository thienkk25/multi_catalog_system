import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/system_history_management/domain/entries/system_history_entry.dart';
import 'package:multi_catalog_system/features/system_history_management/domain/repositories/system_history_repository.dart';

class GetByIdSystemHistoryUseCase {
  final SystemHistoryRepository repository;

  GetByIdSystemHistoryUseCase({required this.repository});

  Future<Either<Failure, SystemHistoryEntry>> call({required String id}) {
    return repository.getById(id: id);
  }
}
