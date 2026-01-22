import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/user_management/domain/repositories/user_management_repository.dart';

class DeleteUserManagementUseCase {
  final UserManagementRepository repository;

  DeleteUserManagementUseCase({required this.repository});

  Future<Either<Failure, void>> call({required String id}) {
    return repository.delete(id: id);
  }
}
