import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_version_entry.dart';

part 'category_item_version_state.freezed.dart';

@freezed
abstract class CategoryItemVersionState with _$CategoryItemVersionState {
  const factory CategoryItemVersionState({
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasMore,

    String? search,
    @Default(1) int page,
    @Default(20) int limit,
    String? sortBy,
    String? sort,
    @Default([]) List<CategoryItemVersionEntry> entries,
    CategoryItemVersionEntry? entry,
    String? error,
    String? successMessage,
  }) = _CategoryItemVersionState;
}
