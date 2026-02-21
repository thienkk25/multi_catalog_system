import 'package:freezed_annotation/freezed_annotation.dart';

part 'domain_lookup_event.freezed.dart';

@freezed
class DomainLookupEvent with _$DomainLookupEvent {
  const factory DomainLookupEvent.lookup() = _Lookup;
  const factory DomainLookupEvent.loadMore() = _LoadMore;
}
