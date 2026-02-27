import 'package:equatable/equatable.dart';
import 'package:multi_catalog_system/core/domain/entities/category_item/category_item_ref_entry.dart';
import 'package:multi_catalog_system/core/domain/entities/domain/domain_ref_entry.dart';
import 'package:multi_catalog_system/features/legal_document/domain/entities/legal_document_entry.dart';

class CategoryItemVersionEntry extends Equatable {
  final String? id;
  final String? domainId;
  final String? itemId;
  final DomainRefEntry? domain;
  final CategoryItemRefEntry? item;
  final Map<String, dynamic>? oldValue;
  final Map<String, dynamic>? newValue;
  final String? changeSummary;
  final String? changeType;
  final String? status;
  final List<LegalDocumentEntry>? legalDocuments;
  final String? changeBy;
  final String? changeByName;
  final String? approvedBy;
  final String? approvedByName;
  final String? rejectReason;
  final DateTime? appliedAt;
  final DateTime? createdAt;

  const CategoryItemVersionEntry({
    this.id,
    this.domainId,
    this.itemId,
    this.domain,
    this.item,
    this.oldValue,
    this.newValue,
    this.changeSummary,
    this.changeType,
    this.status,
    this.legalDocuments,
    this.changeBy,
    this.changeByName,
    this.approvedBy,
    this.approvedByName,
    this.rejectReason,
    this.appliedAt,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    domainId,
    itemId,
    domain,
    item,
    oldValue,
    newValue,
    changeSummary,
    changeType,
    status,
    legalDocuments,
    changeBy,
    changeByName,
    approvedBy,
    approvedByName,
    rejectReason,
    appliedAt,
    createdAt,
  ];
}
