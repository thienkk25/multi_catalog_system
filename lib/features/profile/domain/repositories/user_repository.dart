import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/core/domain/entities/auth/user_entry.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntry>> getProfile();
  Future<Either<Failure, UserEntry>> changePassword({
    required String newPassword,
  });
  Future<Either<Failure, UserEntry>> updateProfile({required UserEntry entry});
}
