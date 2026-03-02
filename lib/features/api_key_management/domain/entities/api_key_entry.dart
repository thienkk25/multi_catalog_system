import 'package:equatable/equatable.dart';
import 'package:multi_catalog_system/core/domain/entities/domain/domain_ref_entry.dart';

class ApiKeyEntry extends Equatable {
  final String? id;
  final String? key;
  final String? systemName;
  final List<DomainRefEntry>? allowedDomains;
  final String? status;
  final String? createdBy;
  final DateTime? createdAt;

  const ApiKeyEntry({
    this.id,
    this.key,
    this.systemName,
    this.allowedDomains,
    this.status,
    this.createdBy,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    key,
    systemName,
    allowedDomains,
    status,
    createdBy,
    createdAt,
  ];
}
