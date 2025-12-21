class CategoryGroupEntry {
  String? id;
  String domainId;
  String code;
  String name;
  String description;
  DateTime createdAt;
  DateTime? updatedAt;
  CategoryGroupEntry({
    this.id,
    required this.domainId,
    required this.code,
    required this.name,
    required this.description,
    required this.createdAt,
    this.updatedAt,
  });
}
