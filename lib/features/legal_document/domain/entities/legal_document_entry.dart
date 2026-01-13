class LegalDocumentEntry {
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

  LegalDocumentEntry({
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
}
