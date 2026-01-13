import 'package:freezed_annotation/freezed_annotation.dart';

part 'legal_document_model.freezed.dart';
part 'legal_document_model.g.dart';

@freezed
abstract class LegalDocumentModel with _$LegalDocumentModel {
  const factory LegalDocumentModel({
    required String id,
    required String code,
    required String title,
    required String type,
    @JsonKey(name: 'issued_by_name') String? issuedByName,
    @JsonKey(name: 'issue_date') required DateTime issueDate,
    @JsonKey(name: 'effective_date') required DateTime effectiveDate,
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
}
