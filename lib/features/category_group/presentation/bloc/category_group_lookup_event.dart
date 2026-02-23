import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/core/domain/entities/category_group/category_group_ref_entry.dart';

part 'category_group_lookup_event.freezed.dart';

@freezed
abstract class CategoryGroupLookupEvent with _$CategoryGroupLookupEvent {
  const factory CategoryGroupLookupEvent.lookup({required String domainId}) =
      _Lookup;

  const factory CategoryGroupLookupEvent.loadMore() = _LoadMore;

  const factory CategoryGroupLookupEvent.selectEntries({
    required List<CategoryGroupRefEntry> entries,
  }) = _Refresh;
}
