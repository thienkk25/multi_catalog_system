class LegalDocumentEntry {
  final String? id;
  final String code;
  final String title;
  final String type;
  final String? issueBy;
  final DateTime? issueDate;
  final DateTime? effectiveDate;
  final DateTime? expiryDate;
  final String? description;
  final String? fileUrl;
  final String? status;
  final DateTime createdDate;
  final DateTime? updatedDate;

  LegalDocumentEntry({
    required this.id,
    required this.code,
    required this.title,
    required this.type,
    required this.issueBy,
    required this.issueDate,
    required this.effectiveDate,
    required this.expiryDate,
    required this.description,
    required this.fileUrl,
    required this.status,
    required this.createdDate,
    required this.updatedDate,
  });
}
