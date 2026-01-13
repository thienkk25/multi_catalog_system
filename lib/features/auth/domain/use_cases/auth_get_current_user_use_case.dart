import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/profile/domain/entities/user_entry.dart';
import 'package:multi_catalog_system/features/auth/domain/repositories/auth_repository.dart';

class AuthGetCurrentUserUseCase {
  final AuthRepository authRepository;

  AuthGetCurrentUserUseCase({required this.authRepository});

  Future<Either<Failure, UserEntry>> call() {
    return authRepository.getCurrentUser();
  }
}
