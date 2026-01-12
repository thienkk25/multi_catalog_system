class CategoryGroupEntry {
  final String? id;
  final String domainId;
  final String code;
  final String name;
  final String description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  CategoryGroupEntry({
    this.id,
    required this.domainId,
    required this.code,
    required this.name,
    required this.description,
    this.createdAt,
    this.updatedAt,
  });
}
