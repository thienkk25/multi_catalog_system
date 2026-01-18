import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/domain/entities/domain/domain_ref_entry.dart';
import 'package:multi_catalog_system/core/domain/entities/role/role_entry.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/user_management/data/data_sources/user_management_remote_data_source.dart';
import 'package:multi_catalog_system/features/user_management/data/models/user_management_model.dart';
import 'package:multi_catalog_system/features/user_management/domain/entities/user_management_entry.dart';
import 'package:multi_catalog_system/features/user_management/domain/repositories/user_management_repository.dart';

class UserManagementRepositoryImpl implements UserManagementRepository {
  final UserManagementRemoteDataSource remoteDataSource;

  UserManagementRepositoryImpl({required this.remoteDataSource});

  UserManagementEntry _toEntity(UserManagementModel m) {
    return UserManagementEntry(
      id: m.id,
      email: m.email,
      fullName: m.fullName,
      phone: m.phone,
      status: m.status,
      role: RoleEntry(id: m.role?.id, code: m.role?.code, name: m.role?.name),
      domains: m.domains
          ?.map((d) => DomainRefEntry(id: d.id, name: d.name, code: d.code))
          .toList(),
      createdAt: m.createdAt,
    );
  }

  Map<String, dynamic> _createPayload(UserManagementEntry e) => {
    'email': e.email,
    'password': e.password,
    'user_metadata': e.userMetadata,
  };

  Map<String, dynamic> _updatePayload(UserManagementEntry e) => {};

  @override
  Future<Either<Failure, UserManagementEntry>> create({
    required UserManagementEntry entry,
  }) async {
    try {
      final model = await remoteDataSource.create(data: _createPayload(entry));
      return Right(_toEntity(model));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserManagementEntry>> getById({
    required String id,
  }) async {
    try {
      final model = await remoteDataSource.getById(id: id);
      return Right(_toEntity(model));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<UserManagementEntry>>> getAll({
    String? search,
  }) async {
    try {
      final models = await remoteDataSource.getAll(search: search);
      return Right(models.map((m) => _toEntity(m)).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserManagementEntry>> update({
    required UserManagementEntry entry,
  }) async {
    try {
      final model = await remoteDataSource.update(
        data: _updatePayload(entry),
        id: entry.id!,
      );
      return Right(_toEntity(model));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> delete({required String id}) async {
    try {
      await remoteDataSource.delete(id: id);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
    }
  }
}
