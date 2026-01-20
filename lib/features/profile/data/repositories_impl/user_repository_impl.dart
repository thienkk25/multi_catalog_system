import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/data/models/auth/user_model.dart';
import 'package:multi_catalog_system/core/domain/entities/role/role_entry.dart';
import 'package:multi_catalog_system/core/error/exception_mapper.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/profile/data/data_sources/user_remote_data_source.dart';
import 'package:multi_catalog_system/core/domain/entities/auth/user_entry.dart';
import 'package:multi_catalog_system/features/profile/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  UserEntry _toEntity(UserModel model) => UserEntry(
    id: model.id,
    email: model.email,
    fullName: model.userMetadata?.fullName,
    phone: model.userMetadata?.phone,
    createdAt: model.createdAt,
    updatedAt: model.updatedAt,
    lastSignInAt: model.lastSignInAt,
  );

  Map<String, dynamic> _toJson(UserEntry entry) => {
    if (entry.fullName != null) 'full_name': entry.fullName,
    if (entry.phone != null) 'phone': entry.phone,
  };

  @override
  Future<Either<Failure, UserEntry>> changePassword({
    required String newPassword,
  }) async {
    try {
      final model = await remoteDataSource.changePassword(
        data: {'new_password': newPassword},
      );
      return Right(_toEntity(model));
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntry>> getMe() async {
    try {
      final model = await remoteDataSource.getMe();
      return Right(_toEntity(model));
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntry>> getProfile() async {
    try {
      final model = await remoteDataSource.getProfile();
      return Right(
        UserEntry(
          id: model.id,
          email: model.email,
          fullName: model.fullName,
          phone: model.phone,
          status: model.status,
          role: RoleEntry(code: model.roleCode, name: model.roleName),
          createdAt: model.createdAt,
          updatedAt: model.updatedAt,
        ),
      );
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntry>> updateProfile({
    required UserEntry entry,
  }) async {
    try {
      final model = await remoteDataSource.updateProfile(data: _toJson(entry));
      return Right(_toEntity(model));
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
