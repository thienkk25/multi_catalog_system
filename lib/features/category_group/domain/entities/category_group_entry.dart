import 'package:equatable/equatable.dart';
import 'package:multi_catalog_system/core/domain/entities/domain/domain_ref_entry.dart';

class CategoryGroupEntry extends Equatable {
  final String? id;
  final String? code;
  final String? name;
  final String? description;
  final DomainRefEntry? domain;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const CategoryGroupEntry({
    this.id,
    this.code,
    this.name,
    this.description,
    this.domain,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    code,
    name,
    description,
    domain,
    createdAt,
    updatedAt,
  ];
}
