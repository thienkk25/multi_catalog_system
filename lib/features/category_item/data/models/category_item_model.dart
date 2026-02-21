import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/core/data/models/category_group/category_group_ref_model.dart';
import 'package:multi_catalog_system/core/data/models/domain/domain_ref_model.dart';
import 'package:multi_catalog_system/features/legal_document/data/models/legal_document_model.dart';

part 'category_item_model.freezed.dart';
part 'category_item_model.g.dart';

@freezed
abstract class CategoryItemModel with _$CategoryItemModel {
  const factory CategoryItemModel({
    required String id,
    required String code,
    required String name,
    String? description,
    String? status,
    @JsonKey(name: 'group_id') required String groupId,
    @JsonKey(name: 'domain_id') required String domainId,
    required CategoryGroupRefModel group,
    required DomainRefModel domain,
    @JsonKey(name: 'legal_documents') List<LegalDocumentModel>? legalDocuments,
    @JsonKey(name: 'created_by_name') String? createdByName,
    @JsonKey(name: 'updated_by_name') String? updatedByName,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _CategoryItemModel;

  factory CategoryItemModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryItemModelFromJson(json);
}
