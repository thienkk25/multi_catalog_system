import 'package:multi_catalog_system/features/auth/domain/repositories/auth_repository.dart';

class AuthRefreshTokenUseCase {
  final AuthRepository authRepository;

  AuthRefreshTokenUseCase({required this.authRepository});

  Future<void> call({required String refreshToken}) {
    return authRepository.refreshToken(refreshToken: refreshToken);
  }
}
