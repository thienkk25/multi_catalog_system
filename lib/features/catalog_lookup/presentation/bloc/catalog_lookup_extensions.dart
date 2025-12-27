import 'catalog_lookup_state.dart';

extension CatalogLookupX on CatalogLookupState {
  String domainNameOf(String id) {
    return domainNameMap[id] ?? '---';
  }
}
