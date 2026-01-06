class LegalDocumentEntry {
  final String? id;
  final String code;
  final String title;
  final String type;
  final String? issuedBy;
  final DateTime? issueDate;
  final DateTime? effectiveDate;
  final DateTime? expiryDate;
  final String? description;
  final String? fileUrl;
  final String? status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  LegalDocumentEntry({
    this.id,
    required this.code,
    required this.title,
    required this.type,
    this.issuedBy,
    this.issueDate,
    this.effectiveDate,
    this.expiryDate,
    this.description,
    this.fileUrl,
    this.status,
    required this.createdAt,
    this.updatedAt,
  });
}
