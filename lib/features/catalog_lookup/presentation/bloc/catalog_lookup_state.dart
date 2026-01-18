import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/core/domain/entities/category_group/category_group_ref_entry.dart';
import 'package:multi_catalog_system/core/domain/entities/domain/domain_ref_entry.dart';

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
