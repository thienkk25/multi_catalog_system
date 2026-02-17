import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/features/category_group/domain/entities/category_group_entry.dart';

part 'category_group_state.freezed.dart';

@freezed
abstract class CategoryGroupState with _$CategoryGroupState {
  const factory CategoryGroupState({
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasMore,

    @Default(1) int page,
    @Default(20) int limit,
    @Default([]) List<CategoryGroupEntry> entries,
    CategoryGroupEntry? entry,
    String? error,
    String? successMessage,
  }) = _CategoryGroupState;
}
