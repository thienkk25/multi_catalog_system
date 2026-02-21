import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_group_lookup_event.freezed.dart';

@freezed
abstract class CategoryGroupLookupEvent with _$CategoryGroupLookupEvent {
  const factory CategoryGroupLookupEvent.lookup({required String domainId}) =
      _Lookup;

  const factory CategoryGroupLookupEvent.loadMore() = _LoadMore;
}
