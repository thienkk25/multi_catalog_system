import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/domain/entities/auth/user_profile_entry.dart';
import 'package:multi_catalog_system/core/error/failures.dart';

abstract class UserManagementRepository {
  Future<Either<Failure, List<UserProfileEntry>>> getAll({String? search});
  Future<Either<Failure, UserProfileEntry>> getById({required String id});
  Future<Either<Failure, UserProfileEntry>> create({
    required UserProfileEntry entry,
  });
  Future<Either<Failure, UserProfileEntry>> update({
    required UserProfileEntry entry,
  });
  Future<Either<Failure, void>> delete({required String id});
  Future<Either<Failure, UserProfileEntry>> activate({required String id});
  Future<Either<Failure, UserProfileEntry>> deactivate({required String id});
  Future<Either<Failure, UserProfileEntry>> grantAccess({
    required UserProfileEntry entry,
  });
}
