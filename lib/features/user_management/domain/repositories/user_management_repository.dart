import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/user_management/domain/entities/user_management_entry.dart';

abstract class UserManagementRepository {
  Future<Either<Failure, List<UserManagementEntry>>> getAll({String? search});
  Future<Either<Failure, UserManagementEntry>> getById({required String id});
  Future<Either<Failure, UserManagementEntry>> create({
    required UserManagementEntry entry,
  });
  Future<Either<Failure, UserManagementEntry>> update({
    required UserManagementEntry entry,
  });
  Future<Either<Failure, void>> delete({required String id});
  Future<Either<Failure, UserManagementEntry>> activate({required String id});
  Future<Either<Failure, UserManagementEntry>> deactivate({required String id});
}
