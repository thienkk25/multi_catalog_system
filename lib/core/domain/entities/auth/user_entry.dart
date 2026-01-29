import 'package:equatable/equatable.dart';
import 'package:multi_catalog_system/core/domain/entities/domain/domain_ref_entry.dart';
import 'package:multi_catalog_system/core/domain/entities/role/role_entry.dart';

class UserEntry extends Equatable {
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

  const UserEntry({
    this.id,
    this.email,
    this.fullName,
    this.phone,
    this.status,
    this.role,
    this.domains,
    this.password,
    this.createdAt,
    this.updatedAt,
    this.lastSignInAt,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    fullName,
    phone,
    status,
    role,
    domains,
    password,
    createdAt,
    updatedAt,
    lastSignInAt,
  ];
}
