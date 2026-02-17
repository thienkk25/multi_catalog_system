import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/domain/entities/page/page_entry.dart';
import 'package:multi_catalog_system/core/domain/entities/page/pagination_entry.dart';
import 'package:multi_catalog_system/core/error/exception_mapper.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/category_group/data/data_sources/category_group_remote_data_source.dart';
import 'package:multi_catalog_system/features/category_group/data/models/category_group_model.dart';
import 'package:multi_catalog_system/features/category_group/domain/entities/category_group_entry.dart';
import 'package:multi_catalog_system/features/category_group/domain/repositories/category_group_repository.dart';

class CategoryGroupRepositoryImpl implements CategoryGroupRepository {
  final CategoryGroupRemoteDataSource remoteDataSource;

  CategoryGroupRepositoryImpl({required this.remoteDataSource});

  CategoryGroupEntry _toEntity(CategoryGroupModel model) => CategoryGroupEntry(
    id: model.id,
    domainId: model.domainId,
    code: model.code,
    name: model.name,
    description: model.description,
    createdAt: model.createdAt,
    updatedAt: model.updatedAt,
  );

  Map<String, dynamic> _createPayload(CategoryGroupEntry entry) => {
    'domain_id': entry.domainId,
    'code': entry.code,
    'name': entry.name,
    if (entry.description != null) 'description': entry.description,
  };

  Map<String, dynamic> _updatePayload(CategoryGroupEntry entry) => {
    if (entry.domainId != null) 'domain_id': entry.domainId,
    if (entry.code != null) 'code': entry.code,
    if (entry.name != null) 'name': entry.name,
    if (entry.description != null) 'description': entry.description,
  };

  @override
  Future<Either<Failure, CategoryGroupEntry>> create({
    required CategoryGroupEntry entry,
  }) async {
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
  Future<Either<Failure, CategoryGroupEntry>> getById({
    required String id,
  }) async {
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
  Future<Either<Failure, PageEntry<CategoryGroupEntry>>> getAll({
    String? search,
    int? page,
    int? limit,
    Map<String, dynamic>? filter,
  }) async {
    try {
      final models = await remoteDataSource.getAll(
        search: search,
        page: page,
        limit: limit,
        filter: filter,
      );
      return Right(
        PageEntry<CategoryGroupEntry>(
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
  Future<Either<Failure, CategoryGroupEntry>> update({
    required CategoryGroupEntry entry,
  }) async {
    try {
      final model = await remoteDataSource.update(
        id: entry.id!,
        data: _updatePayload(entry),
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
}
