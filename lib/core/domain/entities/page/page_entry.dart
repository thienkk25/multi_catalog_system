import 'package:equatable/equatable.dart';

import 'pagination_entry.dart';

class PageEntry<T> extends Equatable {
  final List<T>? entries;
  final PaginationEntry? pagination;

  const PageEntry({this.entries, this.pagination});

  @override
  List<Object?> get props => [entries, pagination];
}
