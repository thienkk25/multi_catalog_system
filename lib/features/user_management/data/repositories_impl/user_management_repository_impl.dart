import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/data/models/auth/user_profile_model.dart';
import 'package:multi_catalog_system/core/domain/entities/auth/user_entry.dart';
import 'package:multi_catalog_system/core/domain/entities/domain/domain_ref_entry.dart';
import 'package:multi_catalog_system/core/domain/entities/page/page_entry.dart';
import 'package:multi_catalog_system/core/domain/entities/page/pagination_entry.dart';
import 'package:multi_catalog_system/core/domain/entities/role/role_entry.dart';
import 'package:multi_catalog_system/core/error/exception_mapper.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/user_management/data/data_sources/user_management_remote_data_source.dart';
import 'package:multi_catalog_system/features/user_management/domain/repositories/user_management_repository.dart';

class UserManagementRepositoryImpl implements UserManagementRepository {
  final UserManagementRemoteDataSource remoteDataSource;

  UserManagementRepositoryImpl({required this.remoteDataSource});

  UserEntry _toEntity(UserProfileModel m) {
    return UserEntry(
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
      updatedAt: m.updatedAt,
      lastSignInAt: m.lastSignInAt,
    );
  }

  Map<String, dynamic> _createPayload(UserEntry e) => {
    'email': e.email,
    if (e.password != null) 'password': e.password,
    if (e.fullName != null || e.phone != null)
      'user_metadata': {
        if (e.fullName != null) 'full_name': e.fullName,
        if (e.phone != null) 'phone': e.phone,
      },
  };

  Map<String, dynamic> _updatePayload(UserEntry e) => {
    if (e.password != null) 'password': e.password,
    if (e.fullName != null || e.phone != null)
      'user_metadata': {
        if (e.fullName != null) 'full_name': e.fullName,
        if (e.phone != null) 'phone': e.phone,
      },
  };

  @override
  Future<Either<Failure, UserEntry>> create({required UserEntry entry}) async {
    try {
      final model = await remoteDataSource.create(data: _createPayload(entry));
      return Right(_toEntity(model));
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntry>> getById({required String id}) async {
    try {
      final model = await remoteDataSource.getById(id: id);
      return Right(_toEntity(model));
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PageEntry<UserEntry>>> getAll({
    String? search,
    int? page,
    int? limit,
    String? sortBy,
    String? sort,
    Map<String, dynamic>? filter,
  }) async {
    try {
      final models = await remoteDataSource.getAll(
        search: search,
        page: page,
        limit: limit,
        sortBy: sortBy,
        sort: sort,
        filter: filter,
      );
      return Right(
        PageEntry<UserEntry>(
          entries: models.data.map((m) => _toEntity(m)).toList(),
          pagination: PaginationEntry(
            page: models.pagination.page,
            limit: models.pagination.limit,
            total: models.pagination.total,
            totalPages: models.pagination.totalPages,
            hasMore: models.pagination.hasMore,
          ),
        ),
      );
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntry>> update({required UserEntry entry}) async {
    try {
      final model = await remoteDataSource.update(
        data: _updatePayload(entry),
        id: entry.id!,
      );
      return Right(_toEntity(model));
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> delete({required String id}) async {
    try {
      await remoteDataSource.delete(id: id);
      return const Right(unit);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntry>> activate({required String id}) async {
    try {
      final model = await remoteDataSource.activate(id: id);
      return Right(_toEntity(model));
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntry>> deactivate({required String id}) async {
    try {
      final model = await remoteDataSource.deactivate(id: id);
      return Right(_toEntity(model));
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntry>> grantAccess({
    required UserEntry entry,
  }) async {
    try {
      final model = await remoteDataSource.grantAccess(
        data: {
          'user_id': entry.id,
          'role_id': entry.role?.id,
          'domain_ids': entry.domains?.map((d) => d.id).toList(),
        },
      );
      return Right(_toEntity(model));
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
