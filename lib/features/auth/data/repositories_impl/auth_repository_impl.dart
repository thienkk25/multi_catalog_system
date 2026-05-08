import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/data/models/auth/user_model.dart';
import 'package:multi_catalog_system/core/data/models/auth/user_profile_model.dart';
import 'package:multi_catalog_system/core/domain/entities/role/role_entry.dart';
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

  UserEntry _toEntity({
    required UserModel model,
    RoleEntry? role,
    UserProfileModel? profile,
  }) => UserEntry(
    id: model.id,
    email: model.email,
    fullName: profile?.fullName,
    phone: profile?.phone,
    imageUrl: profile?.imageUrl,
    createdAt: model.createdAt,
    updatedAt: model.updatedAt,
    lastSignInAt: model.lastSignInAt,
    role: role,
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
      final token = await authLocalDataSource.getCachedAuthToken();
      if (token == null) {
        return Left(CacheFailure(message: "Token not found"));
      }

      try {
        final cachedUser = await authLocalDataSource.getCachedUser();
        
        if (cachedUser == null) {
          return Left(CacheFailure(message: "User not found in cache"));
        }

        final role = await authRemoteDataSource.getRole(accessToken: token);
        final profile = await authRemoteDataSource.getProfile(accessToken: token);

        await authLocalDataSource.cacheUser(cachedUser);
        await authLocalDataSource.cacheUserRole(role);
        await authLocalDataSource.cacheUserProfile(profile);

        return Right(
          _toEntity(
            model: cachedUser,
            role: RoleEntry(id: role?.id, code: role?.code, name: role?.name),
            profile: profile,
          ),
        );
      } catch (_) {
        final cachedUser = await authLocalDataSource.getCachedUser();
        final cachedRole = await authLocalDataSource.getCachedUserRole();
        final cachedProfile = await authLocalDataSource.getCachedUserProfile();

        if (cachedUser != null && cachedRole != null) {
          return Right(
            _toEntity(
              model: cachedUser,
              role: RoleEntry(
                id: cachedRole.id,
                code: cachedRole.code,
                name: cachedRole.name,
              ),
              profile: cachedProfile,
            ),
          );
        }
        rethrow;
      }
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
      final profile = await authRemoteDataSource.getProfile(
        accessToken: result.accessToken,
      );

      await authLocalDataSource.cacheAuthToken(result.accessToken);
      await authLocalDataSource.cacheRefreshToken(result.refreshToken);
      await authLocalDataSource.cacheUser(result.user);

      await authLocalDataSource.cacheUserRole(role);
      await authLocalDataSource.cacheUserProfile(profile);

      return Right(
        _toEntity(
          model: result.user,
          role: RoleEntry(id: role?.id, code: role?.code, name: role?.name),
          profile: profile,
        ),
      );
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
