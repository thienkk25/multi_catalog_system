import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/user_management/domain/entities/user_management_entry.dart';
import 'package:multi_catalog_system/features/user_management/domain/repositories/user_management_repository.dart';

class GetAllUserManagementUseCase {
  final UserManagementRepository repository;

  GetAllUserManagementUseCase({required this.repository});

  Future<Either<Failure, List<UserManagementEntry>>> call({String? search}) {
    return repository.getAll(search: search);
  }
}
