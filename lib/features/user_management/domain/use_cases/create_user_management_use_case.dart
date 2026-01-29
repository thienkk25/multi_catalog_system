import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/domain/entities/auth/user_entry.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/user_management/domain/repositories/user_management_repository.dart';

class CreateUserManagementUseCase {
  final UserManagementRepository repository;
  CreateUserManagementUseCase({required this.repository});

  Future<Either<Failure, UserEntry>> call({required UserEntry entry}) {
    return repository.create(entry: entry);
  }
}
