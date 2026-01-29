import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/domain/entities/auth/user_profile_entry.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/user_management/domain/repositories/user_management_repository.dart';

class GrantAccessUserManagementUseCase {
  final UserManagementRepository repository;

  GrantAccessUserManagementUseCase({required this.repository});

  Future<Either<Failure, UserProfileEntry>> call({
    required UserProfileEntry entry,
  }) {
    return repository.grantAccess(entry: entry);
  }
}
