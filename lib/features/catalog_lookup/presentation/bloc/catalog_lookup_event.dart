import 'package:freezed_annotation/freezed_annotation.dart';

part 'catalog_lookup_event.freezed.dart';

@freezed
class CatalogLookupEvent with _$CatalogLookupEvent {
  const factory CatalogLookupEvent.getDomainsRef() = _GetDomainsRef;
  const factory CatalogLookupEvent.getCategoryGroupsRef({
    required String domainId,
  }) = _GetCategoryGroupsRef;
  const factory CatalogLookupEvent.searchCatalog({
    required String keyword,
    required String domainId,
    int? limit,
    int? offset,
  }) = _SearchCatalog;
}
