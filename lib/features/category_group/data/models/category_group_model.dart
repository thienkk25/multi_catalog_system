import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/features/category_group/domain/entities/category_group_entry.dart';

part 'category_group_model.freezed.dart';
part 'category_group_model.g.dart';

@freezed
abstract class CategoryGroupModel with _$CategoryGroupModel {
  const factory CategoryGroupModel({
    String? id,
    @JsonKey(name: 'domain_id') required String domainId,
    required String code,
    required String name,
    required String description,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _CategoryGroupModel;

  factory CategoryGroupModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryGroupModelFromJson(json);

  factory CategoryGroupModel.fromEntity(CategoryGroupEntry entry) {
    return CategoryGroupModel(
      id: entry.id,
      domainId: entry.domainId,
      code: entry.code,
      name: entry.name,
      description: entry.description,
      createdAt: entry.createdAt,
      updatedAt: entry.updatedAt,
    );
  }
}

extension CategoryGroupModelMapper on CategoryGroupModel {
  CategoryGroupEntry toEntity() {
    return CategoryGroupEntry(
      id: id,
      domainId: domainId,
      code: code,
      name: name,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
