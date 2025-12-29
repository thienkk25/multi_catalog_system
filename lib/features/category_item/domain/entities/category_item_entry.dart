class CategoryItemEntry {
  final String? id;
  final String groupId;
  final String code;
  final String name;
  final String? description;
  final String status;
  final String createdBy;
  final String? updatedBy;
  final DateTime createdAt;
  final DateTime? updatedAt;

  CategoryItemEntry({
    required this.id,
    required this.groupId,
    required this.code,
    required this.name,
    required this.description,
    required this.status,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });
}
