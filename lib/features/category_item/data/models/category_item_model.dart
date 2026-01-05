import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_entry.dart';

part 'category_item_model.freezed.dart';
part 'category_item_model.g.dart';

@freezed
abstract class CategoryItemModel with _$CategoryItemModel {
  const factory CategoryItemModel({
    String? id,
    @JsonKey(name: 'group_id') required String groupId,
    required String code,
    required String name,
    String? description,
    required String status,
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'updated_by') String? updatedBy,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _CategoryItemModel;

  factory CategoryItemModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryItemModelFromJson(json);

  factory CategoryItemModel.fromEntity(CategoryItemEntry entry) =>
      CategoryItemModel(
        id: entry.id,
        groupId: entry.groupId,
        code: entry.code,
        name: entry.name,
        description: entry.description,
        status: entry.status,
        createdBy: entry.createdBy,
        updatedBy: entry.updatedBy,
        createdAt: entry.createdAt,
        updatedAt: entry.updatedAt,
      );
}

extension CategoryItemModelMapper on CategoryItemModel {
  CategoryItemEntry toEntity() => CategoryItemEntry(
    id: id,
    groupId: groupId,
    code: code,
    name: name,
    description: description,
    status: status,
    createdBy: createdBy,
    updatedBy: updatedBy,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
