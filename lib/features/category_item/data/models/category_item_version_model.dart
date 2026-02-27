import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/core/data/models/category_item/category_item_ref_model.dart';
import 'package:multi_catalog_system/core/data/models/domain/domain_ref_model.dart';
import 'package:multi_catalog_system/features/legal_document/data/models/legal_document_model.dart';

part 'category_item_version_model.freezed.dart';
part 'category_item_version_model.g.dart';

@freezed
abstract class CategoryItemVersionModel with _$CategoryItemVersionModel {
  const factory CategoryItemVersionModel({
    required String id,
    @JsonKey(name: 'domain_id') required String domainId,
    @JsonKey(name: 'item_id') String? itemId,
    required DomainRefModel domain,
    CategoryItemRefModel? item,
    @JsonKey(name: 'old_value') Map<String, dynamic>? oldValue,
    @JsonKey(name: 'new_value') Map<String, dynamic>? newValue,
    @JsonKey(name: 'change_summary') required String changeSummary,
    @JsonKey(name: 'change_type') required String changeType,
    required String status,
    @JsonKey(name: 'legal_documents') List<LegalDocumentModel>? legalDocuments,
    @JsonKey(name: 'change_by') String? changeBy,
    @JsonKey(name: 'change_by_name') String? changeByName,
    @JsonKey(name: 'approved_by') String? approvedBy,
    @JsonKey(name: 'approved_by_name') String? approvedByName,
    @JsonKey(name: 'reject_reason') String? rejectReason,
    @JsonKey(name: 'applied_at') DateTime? appliedAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _CategoryItemVersionModel;

  factory CategoryItemVersionModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryItemVersionModelFromJson(json);
}
