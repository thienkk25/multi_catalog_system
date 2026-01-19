import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/user_management/domain/entities/user_management_entry.dart';
import 'package:multi_catalog_system/features/user_management/domain/repositories/user_management_repository.dart';

class ActivateUserManagementUseCase {
  final UserManagementRepository repository;

  ActivateUserManagementUseCase({required this.repository});

  Future<Either<Failure, UserManagementEntry>> call({
    required String id,
  }) async {
    return repository.activate(id: id);
  }
}
