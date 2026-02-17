import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/domain/entities/page/page_entry.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/api_key_management/domain/entities/api_key_entry.dart';

abstract class ApiKeyRepository {
  Future<Either<Failure, PageEntry<ApiKeyEntry>>> getAll({
    String? search,
    int? page,
    int? limit,
    Map<String, dynamic>? filter,
  });
  Future<Either<Failure, ApiKeyEntry>> getById({required String id});
  Future<Either<Failure, ApiKeyEntry>> create({required ApiKeyEntry entry});
  Future<Either<Failure, ApiKeyEntry>> update({required ApiKeyEntry entry});
  Future<Either<Failure, void>> delete({required String id});
}
