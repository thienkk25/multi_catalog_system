import 'package:equatable/equatable.dart';
import 'package:multi_catalog_system/core/domain/entities/pagination/pagination_entry.dart';

import 'domain_entry.dart';

class DomainPageEntry extends Equatable {
  final List<DomainEntry>? entries;
  final PaginationEntry? pagination;

  const DomainPageEntry({this.entries, this.pagination});

  @override
  List<Object?> get props => [entries, pagination];
}
