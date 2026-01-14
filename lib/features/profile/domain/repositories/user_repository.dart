import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/profile/domain/entities/user_entry.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntry>> getMe();
  Future<Either<Failure, UserEntry>> getUser();
  Future<Either<Failure, UserEntry>> changePassword({
    required String newPassword,
  });
  Future<Either<Failure, UserEntry>> updateProfile({required UserEntry entry});
}
