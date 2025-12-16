import 'package:multi_catalog_system/features/auth/domain/repositories/auth_repository.dart';

class AuthCheckAuthenticatedUseCase {
  final AuthRepository authRepository;

  AuthCheckAuthenticatedUseCase(this.authRepository);
  Future<bool> call() {
    return authRepository.checkAuthenticated();
  }
}
