import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/auth/domain/entities/user_entry.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntry>> login({
    required String email,
    required String pass,
  });
  Future<Either<Failure, UserEntry>> getCurrentUser();
  Future<Either<Failure, Unit>> refreshToken({required String refreshToken});
  Future<void> logout();
}
