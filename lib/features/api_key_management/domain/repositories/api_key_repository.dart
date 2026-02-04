import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/api_key_management/domain/entities/api_key_entry.dart';

abstract class ApiKeyRepository {
  Future<Either<Failure, List<ApiKeyEntry>>> getAll({String? search});
  Future<Either<Failure, ApiKeyEntry>> getById({required String id});
  Future<Either<Failure, ApiKeyEntry>> create({required ApiKeyEntry entry});
  Future<Either<Failure, ApiKeyEntry>> update({required ApiKeyEntry entry});
  Future<Either<Failure, void>> delete({required String id});
}
