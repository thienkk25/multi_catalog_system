class PaginationEntry {
  final int? page;
  final int? limit;
  final int? total;
  final int? totalPages;
  final bool? hasMore;

  PaginationEntry({
    this.page,
    this.limit,
    this.total,
    this.totalPages,
    this.hasMore,
  });
}
