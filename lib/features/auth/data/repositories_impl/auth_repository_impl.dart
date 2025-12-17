import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
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

  /// Ưu tiên local → fallback remote
  @override
  Future<Either<Failure, UserEntry>> getCurrentUser() async {
    try {
      final cachedUser = await authLocalDataSource.getCachedUser();

      if (cachedUser != null) {
        return Right(cachedUser.toEntry());
      }

      final token = await authLocalDataSource.getCachedAuthToken();
      if (token == null) {
        return Left(CacheFailure());
      }

      final remoteUser = await authRemoteDataSource.getCurrentUser();

      if (remoteUser == null) {
        return Left(ServerFailure());
      }

      await authLocalDataSource.cacheUser(remoteUser);
      return Right(remoteUser.toEntry());
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  /// Login → cache token + refresh token + user
  @override
  Future<Either<Failure, UserEntry>> login({
    required String email,
    required String pass,
  }) async {
    try {
      final result = await authRemoteDataSource.login(email: email, pass: pass);

      await authLocalDataSource.cacheAuthToken(result.accessToken);
      await authLocalDataSource.cacheRefreshToken(result.refreshToken);
      await authLocalDataSource.cacheUser(result.user);

      return Right(result.user.toEntry());
    } on InvalidCredentialsException {
      return Left(InvalidCredentialsFailure());
    } on ServerException {
      return Left(ServerFailure());
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  /// Refresh token → cập nhật token mới
  @override
  Future<Either<Failure, Unit>> refreshToken({
    required String refreshToken,
  }) async {
    try {
      final result = await authRemoteDataSource.refreshToken(
        refreshToken: refreshToken,
      );

      await authLocalDataSource.cacheAuthToken(result.accessToken);

      if (result.refreshToken.isNotEmpty) {
        await authLocalDataSource.cacheRefreshToken(result.refreshToken);
      }

      return const Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    } on CacheException {
      return Left(CacheFailure());
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
