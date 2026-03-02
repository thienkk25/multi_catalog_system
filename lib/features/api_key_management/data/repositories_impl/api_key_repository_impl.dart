import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/domain/entities/domain/domain_ref_entry.dart';
import 'package:multi_catalog_system/core/domain/entities/page/page_entry.dart';
import 'package:multi_catalog_system/core/domain/entities/page/pagination_entry.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/api_key_management/data/data_sources/api_key_remote_data_source.dart';
import 'package:multi_catalog_system/features/api_key_management/data/models/api_key_model.dart';
import 'package:multi_catalog_system/features/api_key_management/domain/domain.dart';

class ApiKeyRepositoryImpl implements ApiKeyRepository {
  final ApiKeyRemoteDataSource remoteDataSource;

  ApiKeyRepositoryImpl({required this.remoteDataSource});

  ApiKeyEntry _toEntity(ApiKeyModel m) {
    return ApiKeyEntry(
      id: m.id,
      key: m.key,
      systemName: m.systemName,
      allowedDomains: m.allowedDomains
          .map((e) => DomainRefEntry(id: e.id, name: e.name, code: e.code))
          .toList(),
      status: m.status,
      createdBy: m.createdBy,
      createdAt: m.createdAt,
    );
  }

  Map<String, dynamic> _createPayload(ApiKeyEntry e) => {
    'system_name': e.systemName,
    'allowed_domains': e.allowedDomains
        ?.map((e) => {'id': e.id, 'code': e.code, 'name': e.name})
        .toList(),
  };

  @override
  Future<Either<Failure, ApiKeyEntry>> create({
    required ApiKeyEntry entry,
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
  Future<Either<Failure, ApiKeyEntry>> getById({required String id}) async {
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
  Future<Either<Failure, PageEntry<ApiKeyEntry>>> getAll({
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
        PageEntry<ApiKeyEntry>(
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
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ApiKeyEntry>> revoke({required String id}) async {
    try {
      final model = await remoteDataSource.revoke(id: id);
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
