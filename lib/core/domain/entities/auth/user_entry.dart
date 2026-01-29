import 'package:equatable/equatable.dart';
import 'package:multi_catalog_system/core/domain/entities/role/role_entry.dart';

class UserEntry extends Equatable {
  final String? id;
  final String? email;
  final String? fullName;
  final String? phone;
  final String? status;
  final RoleEntry? role;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastSignInAt;
  const UserEntry({
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

  @override
  List<Object?> get props => [
    id,
    email,
    fullName,
    phone,
    status,
    createdAt,
    updatedAt,
    lastSignInAt,
    role,
  ];
}
