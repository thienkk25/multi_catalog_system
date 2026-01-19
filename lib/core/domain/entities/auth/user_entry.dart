import 'package:multi_catalog_system/core/domain/entities/role/role_entry.dart';

class UserEntry {
  final String? id;
  final String? email;
  final String? fullName;
  final String? phone;
  final String? status;
  final RoleEntry? role;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastSignInAt;
  UserEntry({
    this.id,
    this.email,
    this.fullName,
    this.phone,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.lastSignInAt,
    this.role,
  });
}
