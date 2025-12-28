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
    @JsonKey(name: 'issue_by') String? issueBy,
    @JsonKey(name: 'issue_date') DateTime? issueDate,
    @JsonKey(name: 'effective_date') DateTime? effectiveDate,
    @JsonKey(name: 'expiry_date') DateTime? expiryDate,
    String? description,
    @JsonKey(name: 'file_url') String? fileUrl,
    String? status,
    @JsonKey(name: 'created_date') required DateTime createdDate,
    @JsonKey(name: 'updated_date') DateTime? updatedDate,
  }) = _LegalDocumentModel;

  factory LegalDocumentModel.fromJson(Map<String, dynamic> json) =>
      _$LegalDocumentModelFromJson(json);

  factory LegalDocumentModel.fromEntity(LegalDocumentEntry entry) {
    return LegalDocumentModel(
      id: entry.id,
      code: entry.code,
      title: entry.title,
      type: entry.type,
      issueBy: entry.issueBy,
      issueDate: entry.issueDate,
      effectiveDate: entry.effectiveDate,
      expiryDate: entry.expiryDate,
      description: entry.description,
      fileUrl: entry.fileUrl,
      status: entry.status,
      createdDate: entry.createdDate,
      updatedDate: entry.updatedDate,
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
      issueBy: issueBy,
      issueDate: issueDate,
      effectiveDate: effectiveDate,
      expiryDate: expiryDate,
      description: description,
      fileUrl: fileUrl,
      status: status,
      createdDate: createdDate,
      updatedDate: updatedDate,
    );
  }
}
