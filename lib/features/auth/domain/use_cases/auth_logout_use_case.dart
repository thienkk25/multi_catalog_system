import 'package:multi_catalog_system/features/auth/domain/repositories/auth_repository.dart';

class AuthLogoutUseCase {
  final AuthRepository authRepository;

  AuthLogoutUseCase({required this.authRepository});

  Future<void> call() {
    return authRepository.logout();
  }
}
