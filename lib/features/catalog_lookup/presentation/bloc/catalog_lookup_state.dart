import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/features/catalog_lookup/domain/domain.dart';

part 'catalog_lookup_state.freezed.dart';

@freezed
abstract class CatalogLookupState with _$CatalogLookupState {
  const factory CatalogLookupState({
    @Default(false) bool isLoading,
    String? error,
    @Default([]) List<DomainRefEntry> domainsRef,
    @Default([]) List<CategoryGroupRefEntry> categoryGroupRef,
    @Default([]) List<DomainRefEntry> catalog,

    @Default({}) Map<String, String> domainNameMap,
  }) = _CatalogLookupState;
}
