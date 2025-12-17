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
      if (cachedUser != null) return Right(cachedUser.toEntry());

      final token = await authLocalDataSource.getCachedAuthToken();
      if (token == null) return Left(CacheFailure(message: "Token not found"));

      final remoteUser = await authRemoteDataSource.getCurrentUser();
      await authLocalDataSource.cacheUser(remoteUser);

      return Right(remoteUser.toEntry());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
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
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
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
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
    }
  }

  /// Logout → clear local + gọi API
  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await authRemoteDataSource.logout();
      await authLocalDataSource.clearAuthToken();
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
    }
  }
}
