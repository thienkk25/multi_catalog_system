import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/domain/entities/auth/user_entry.dart';
import 'package:multi_catalog_system/core/error/failures.dart';

abstract class UserManagementRepository {
  Future<Either<Failure, List<UserEntry>>> getAll({String? search});
  Future<Either<Failure, UserEntry>> getById({required String id});
  Future<Either<Failure, UserEntry>> create({required UserEntry entry});
  Future<Either<Failure, UserEntry>> update({required UserEntry entry});
  Future<Either<Failure, void>> delete({required String id});
  Future<Either<Failure, UserEntry>> activate({required String id});
  Future<Either<Failure, UserEntry>> deactivate({required String id});
  Future<Either<Failure, UserEntry>> grantAccess({required UserEntry entry});
}
