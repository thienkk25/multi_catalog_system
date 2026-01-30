import 'package:equatable/equatable.dart';
import 'package:multi_catalog_system/features/legal_document/domain/entities/legal_document_entry.dart';

class CategoryItemEntry extends Equatable {
  final String? id;
  final String? code;
  final String? name;
  final String? description;
  final String? status;
  final String? groupId;
  final String? groupName;
  final String? domainName;
  final List<LegalDocumentEntry>? legalDocuments;
  final String? createdByName;
  final String? updatedByName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CategoryItemEntry({
    this.id,
    this.code,
    this.name,
    this.description,
    this.status,
    this.groupId,
    this.groupName,
    this.domainName,
    this.legalDocuments,
    this.createdByName,
    this.updatedByName,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    code,
    name,
    description,
    status,
    groupId,
    groupName,
    domainName,
    legalDocuments,
    createdByName,
    updatedByName,
    createdAt,
    updatedAt,
  ];
}
