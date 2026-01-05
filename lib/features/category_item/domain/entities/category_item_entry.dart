import 'category_group_res_entry.dart';

class CategoryItemEntry {
  final String? id;
  final String groupId;
  final String code;
  final String name;
  final String? description;
  final String status;
  final CategoryGroupResEntry group;
  final String? createdBy;
  final String? updatedBy;
  final DateTime createdAt;
  final DateTime? updatedAt;

  CategoryItemEntry({
    this.id,
    required this.groupId,
    required this.code,
    required this.name,
    this.description,
    required this.status,
    required this.group,
    this.createdBy,
    this.updatedBy,
    required this.createdAt,
    this.updatedAt,
  });
}
