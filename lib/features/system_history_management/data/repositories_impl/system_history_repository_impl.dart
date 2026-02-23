import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/domain/entities/page/page_entry.dart';
import 'package:multi_catalog_system/core/domain/entities/page/pagination_entry.dart';
import 'package:multi_catalog_system/core/error/exception_mapper.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/system_history_management/data/data_sources/system_history_remote_data_source.dart';
import 'package:multi_catalog_system/features/system_history_management/data/models/system_history_model.dart';
import 'package:multi_catalog_system/features/system_history_management/domain/entities/system_history_entry.dart';
import 'package:multi_catalog_system/features/system_history_management/domain/repositories/system_history_repository.dart';

class SystemHistoryRepositoryImpl implements SystemHistoryRepository {
  final SystemHistoryRemoteDataSource remoteDataSource;

  SystemHistoryRepositoryImpl({required this.remoteDataSource});

  SystemHistoryEntry _toEntity(SystemHistoryModel model) => SystemHistoryEntry(
    id: model.id,
    userId: model.userId,
    action: model.action,
    method: model.method,
    endpoint: model.endpoint,
    metadata: model.metadata,
    timestamp: model.timestamp,
  );

  @override
  Future<Either<Failure, PageEntry<SystemHistoryEntry>>> getAll({
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
        PageEntry<SystemHistoryEntry>(
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
  Future<Either<Failure, SystemHistoryEntry>> getById({
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
}
