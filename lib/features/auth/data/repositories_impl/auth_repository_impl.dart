import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/data/models/auth/user_model.dart';
import 'package:multi_catalog_system/core/error/exception_mapper.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:multi_catalog_system/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:multi_catalog_system/core/domain/entities/auth/user_entry.dart';
import 'package:multi_catalog_system/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.authLocalDataSource,
  });

  UserEntry _toEntity(UserModel model) => UserEntry(
    id: model.id,
    email: model.email,
    fullName: model.userMetadata?.fullName,
    phone: model.userMetadata?.phone,
    createdAt: model.createdAt,
    updatedAt: model.updatedAt,
    lastSignInAt: model.lastSignInAt,
  );

  final _controller = StreamController<AuthStatus>.broadcast();

  @override
  Stream<AuthStatus> get authStatus => _controller.stream;

  @override
  void notifyUnauthenticated() {
    _controller.add(AuthStatus.unauthenticated);
  }

  @override
  Future<Either<Failure, UserEntry>> getCurrentUser() async {
    try {
      final cachedUser = await authLocalDataSource.getCachedUser();
      if (cachedUser != null) return Right(_toEntity(cachedUser));

      final token = await authLocalDataSource.getCachedAuthToken();
      if (token == null) return Left(CacheFailure(message: "Token not found"));

      final remoteUser = await authRemoteDataSource.getCurrentUser();
      await authLocalDataSource.cacheUser(remoteUser);

      return Right(_toEntity(remoteUser));
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntry>> login({
    required String email,
    required String pass,
  }) async {
    try {
      final result = await authRemoteDataSource.login(email: email, pass: pass);
      final role = await authRemoteDataSource.getRole(
        accessToken: result.accessToken,
      );
      await authLocalDataSource.cacheAuthToken(result.accessToken);
      await authLocalDataSource.cacheRefreshToken(result.refreshToken);
      await authLocalDataSource.cacheUser(result.user);

      await authLocalDataSource.cacheUserRole(role);

      return Right(_toEntity(result.user));
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

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
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await authLocalDataSource.clearAuthToken();
      await authRemoteDataSource.logout();
      return const Right(unit);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
