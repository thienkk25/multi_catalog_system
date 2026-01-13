import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/system_history_management/domain/entities/system_history_entry.dart';
import 'package:multi_catalog_system/features/system_history_management/domain/repositories/system_history_repository.dart';

class GetAllSystemHistoryUseCase {
  final SystemHistoryRepository repository;

  GetAllSystemHistoryUseCase({required this.repository});

  Future<Either<Failure, List<SystemHistoryEntry>>> call({String? search}) {
    return repository.getAll(search: search);
  }
}
