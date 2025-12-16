import 'package:multi_catalog_system/features/auth/domain/entities/user_entry.dart';
import 'package:multi_catalog_system/features/auth/domain/repositories/auth_repository.dart';

class AuthGetCurrentUserUseCase {
  final AuthRepository authRepository;

  AuthGetCurrentUserUseCase({required this.authRepository});

  Future<UserEntry?> call() {
    return authRepository.getCurrentUser();
  }
}
