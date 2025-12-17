import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/auth/domain/entities/user_entry.dart';
import 'package:multi_catalog_system/features/auth/domain/repositories/auth_repository.dart';

class AuthLoginUseCase {
  final AuthRepository authRepository;

  AuthLoginUseCase({required this.authRepository});

  Future<Either<Failure, UserEntry>> call({
    required String email,
    required String pass,
  }) {
    return authRepository.login(email: email, pass: pass);
  }
}
