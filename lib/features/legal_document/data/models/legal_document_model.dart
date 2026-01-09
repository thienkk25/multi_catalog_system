import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/features/legal_document/domain/entries/legal_document_entry.dart';

part 'legal_document_model.freezed.dart';
part 'legal_document_model.g.dart';

@freezed
abstract class LegalDocumentModel with _$LegalDocumentModel {
  const factory LegalDocumentModel({
    String? id,
    required String code,
    required String title,
    required String type,
    @JsonKey(name: 'issued_by') String? issuedBy,
    @JsonKey(name: 'issue_date') DateTime? issueDate,
    @JsonKey(name: 'effective_date') DateTime? effectiveDate,
    @JsonKey(name: 'expiry_date') DateTime? expiryDate,
    String? description,
    @JsonKey(name: 'file_name') String? fileName,
    @JsonKey(name: 'file_url') String? fileUrl,
    String? status,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _LegalDocumentModel;

  factory LegalDocumentModel.fromJson(Map<String, dynamic> json) =>
      _$LegalDocumentModelFromJson(json);

  factory LegalDocumentModel.fromEntity(LegalDocumentEntry entry) {
    return LegalDocumentModel(
      id: entry.id,
      code: entry.code,
      title: entry.title,
      type: entry.type,
      issuedBy: entry.issuedBy,
      issueDate: entry.issueDate,
      effectiveDate: entry.effectiveDate,
      expiryDate: entry.expiryDate,
      description: entry.description,
      fileName: entry.fileName,
      fileUrl: entry.fileUrl,
      status: entry.status,
      createdAt: entry.createdAt,
      updatedAt: entry.updatedAt,
    );
  }
}

extension LegalDocumentModelMapper on LegalDocumentModel {
  LegalDocumentEntry toEntity() {
    return LegalDocumentEntry(
      id: id,
      code: code,
      title: title,
      type: type,
      issuedBy: issuedBy,
      issueDate: issueDate,
      effectiveDate: effectiveDate,
      expiryDate: expiryDate,
      description: description,
      fileName: fileName,
      fileUrl: fileUrl,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
