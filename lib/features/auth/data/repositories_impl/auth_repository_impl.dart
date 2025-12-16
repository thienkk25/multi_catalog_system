import 'package:multi_catalog_system/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:multi_catalog_system/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:multi_catalog_system/features/auth/data/models/user_model.dart';
import 'package:multi_catalog_system/features/auth/domain/entities/user_entry.dart';
import 'package:multi_catalog_system/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.authLocalDataSource,
  });

  /// Check auth dựa vào local token
  @override
  Future<bool> checkAuthenticated() async {
    final token = await authLocalDataSource.getCachedAuthToken();
    return token != null && token.isNotEmpty;
  }

  /// Ưu tiên local → fallback remote
  @override
  Future<UserEntry?> getCurrentUser() async {
    final cachedUser = await authLocalDataSource.getCachedUser();
    if (cachedUser != null) {
      return cachedUser.toEntry();
    }

    final remoteUser = await authRemoteDataSource.getCurrentUser();
    if (remoteUser != null) {
      await authLocalDataSource.cacheUser(remoteUser);
      return remoteUser.toEntry();
    }

    return null;
  }

  /// Login → cache token + refresh token + user
  @override
  Future<void> login({required String email, required String pass}) async {
    final result = await authRemoteDataSource.login(email: email, pass: pass);

    await authLocalDataSource.cacheAuthToken(result.accessToken);
    await authLocalDataSource.cacheRefreshToken(result.refreshToken);
    await authLocalDataSource.cacheUser(result.user);
  }

  /// Refresh token → cập nhật token mới
  @override
  Future<void> refreshToken({required String refreshToken}) async {
    final result = await authRemoteDataSource.refreshToken(
      refreshToken: refreshToken,
    );

    await authLocalDataSource.cacheAuthToken(result.accessToken);

    // Backend có thể trả refresh token mới
    if (result.refreshToken.isNotEmpty) {
      await authLocalDataSource.cacheRefreshToken(result.refreshToken);
    }
  }

  /// Logout → clear local + gọi API
  @override
  Future<void> logout() async {
    try {
      await authRemoteDataSource.logout();
    } finally {
      await authLocalDataSource.clearAuthToken();
    }
  }
}
