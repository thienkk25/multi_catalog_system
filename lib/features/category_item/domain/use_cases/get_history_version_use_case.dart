import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/domain/entities/page/page_entry.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_version_entry.dart';
import 'package:multi_catalog_system/features/category_item/domain/repositories/category_item_version_repository.dart';

class GetHistoryVersionUseCase {
  final CategoryItemVersionRepository repository;

  GetHistoryVersionUseCase({required this.repository});

  Future<Either<Failure, PageEntry<CategoryItemVersionEntry>>> call({
    required String itemId,
    int? page,
    int? limit,
  }) {
    return repository.getHistoryVersion(
      itemId: itemId,
      page: page,
      limit: limit,
    );
  }
}
