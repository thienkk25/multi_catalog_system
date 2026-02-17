import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/domain/entities/auth/user_entry.dart';
import 'package:multi_catalog_system/core/domain/entities/page/page_entry.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/user_management/domain/repositories/user_management_repository.dart';

class GetAllUserManagementUseCase {
  final UserManagementRepository repository;

  GetAllUserManagementUseCase({required this.repository});

  Future<Either<Failure, PageEntry<UserEntry>>> call({
    String? search,
    int? page,
    int? limit,
    Map<String, dynamic>? filter,
  }) {
    return repository.getAll(
      search: search,
      page: page,
      limit: limit,
      filter: filter,
    );
  }
}
