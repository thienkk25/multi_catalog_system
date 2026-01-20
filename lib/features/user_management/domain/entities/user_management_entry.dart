import 'package:multi_catalog_system/core/domain/entities/domain/domain_ref_entry.dart';
import 'package:multi_catalog_system/core/domain/entities/role/role_entry.dart';

class UserManagementEntry {
  final String? id;
  final String? email;
  final String? fullName;
  final String? phone;
  final String? status;
  final RoleEntry? role;
  final List<DomainRefEntry>? domains;
  final String? password;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastSignInAt;

  UserManagementEntry({
    this.id,
    this.email,
    this.fullName,
    this.phone,
    this.status,
    this.role,
    this.domains,
    this.createdAt,
    this.password,
    this.updatedAt,
    this.lastSignInAt,
  });
}
