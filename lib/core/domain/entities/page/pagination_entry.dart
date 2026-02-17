import 'package:equatable/equatable.dart';

class PaginationEntry extends Equatable {
  final int? page;
  final int? limit;
  final int? total;
  final int? totalPages;
  final bool? hasMore;

  const PaginationEntry({
    this.page,
    this.limit,
    this.total,
    this.totalPages,
    this.hasMore,
  });

  @override
  List<Object?> get props => [page, limit, total, totalPages, hasMore];
}
