import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/core/domain/entities/category_group/category_group_ref_entry.dart';

part 'category_group_lookup_state.freezed.dart';

@freezed
abstract class CategoryGroupLookupState with _$CategoryGroupLookupState {
  const factory CategoryGroupLookupState({
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasMore,

    @Default(1) int page,
    @Default(20) int limit,
    @Default([]) List<CategoryGroupRefEntry> entries,
    @Default([]) List<String> domainIds,
    @Default([]) List<CategoryGroupRefEntry> selectedEntries,
    String? error,
  }) = _CategoryGroupLookupState;
}
