import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/core/domain/entities/domain/domain_ref_entry.dart';

part 'domain_lookup_event.freezed.dart';

@freezed
class DomainLookupEvent with _$DomainLookupEvent {
  const factory DomainLookupEvent.lookup() = _Lookup;
  const factory DomainLookupEvent.loadMore() = _LoadMore;
  const factory DomainLookupEvent.selectedEntries({
    required List<DomainRefEntry> entries,
  }) = _SelectedEntries;
}
