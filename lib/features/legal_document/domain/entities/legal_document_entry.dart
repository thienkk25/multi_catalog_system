import 'package:equatable/equatable.dart';

class LegalDocumentEntry extends Equatable {
  final String? id;
  final String? code;
  final String? title;
  final String? type;
  final String? issuedByName;
  final DateTime? issueDate;
  final DateTime? effectiveDate;
  final DateTime? expiryDate;
  final String? description;
  final String? fileName;
  final String? fileUrl;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const LegalDocumentEntry({
    this.id,
    this.code,
    this.title,
    this.type,
    this.issuedByName,
    this.issueDate,
    this.effectiveDate,
    this.expiryDate,
    this.description,
    this.fileName,
    this.fileUrl,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    code,
    title,
    type,
    issuedByName,
    issueDate,
    effectiveDate,
    expiryDate,
    description,
    fileName,
    fileUrl,
    status,
    createdAt,
    updatedAt,
  ];
}
