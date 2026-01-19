import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/core/domain/entities/auth/user_entry.dart';

enum AuthStatus { authenticated, unauthenticated }

abstract class AuthRepository {
  /// Stream phát trạng thái auth (token hết hạn, logout, login)
  Stream<AuthStatus> get authStatus;

  /// Interceptor / Repository gọi khi phát hiện hết phiên
  void notifyUnauthenticated();

  Future<Either<Failure, UserEntry>> login({
    required String email,
    required String pass,
  });

  Future<Either<Failure, UserEntry>> getCurrentUser();

  Future<Either<Failure, Unit>> refreshToken({required String refreshToken});

  Future<Either<Failure, Unit>> logout();
}
