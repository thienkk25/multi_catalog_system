import 'package:multi_catalog_system/core/domain/entities/pagination/pagination_entry.dart';

import 'domain_entry.dart';

class DomainPageEntry {
  final List<DomainEntry>? entries;
  final PaginationEntry? pagination;

  DomainPageEntry({this.entries, this.pagination});
}
