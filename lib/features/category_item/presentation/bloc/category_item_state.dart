import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_entry.dart';

part 'category_item_state.freezed.dart';

@freezed
abstract class CategoryItemState with _$CategoryItemState {
  const factory CategoryItemState({
    @Default(false) bool isLoading,
    @Default([]) List<CategoryItemEntry> entries,
    String? error,
    String? successMessage,
  }) = _CategoryItemState;
}
