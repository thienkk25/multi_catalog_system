class CategoryItemEntry {
  String? id;
  final String groupId;
  final String code;
  final String name;
  String? description;
  final String status;
  final String createdBy;
  String? updatedBy;
  final DateTime createdAt;
  DateTime? updatedAt;

  CategoryItemEntry({
    required this.groupId,
    required this.code,
    required this.name,
    required this.status,
    required this.createdBy,
    required this.createdAt,
  });
}
