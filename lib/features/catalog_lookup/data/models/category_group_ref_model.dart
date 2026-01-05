import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/features/catalog_lookup/domain/entities/category_group_ref_entry.dart';

part 'category_group_ref_model.freezed.dart';
part 'category_group_ref_model.g.dart';

@freezed
abstract class CategoryGroupRefModel with _$CategoryGroupRefModel {
  const factory CategoryGroupRefModel({
    required String id,
    required String code,
    required String name,
  }) = _CategoryGroupRefModel;

  factory CategoryGroupRefModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryGroupRefModelFromJson(json);

  factory CategoryGroupRefModel.fromEntity(CategoryGroupRefEntry entry) =>
      CategoryGroupRefModel(id: entry.id, code: entry.code, name: entry.name);
}

extension CategoryGroupRefModelMapper on CategoryGroupRefModel {
  CategoryGroupRefEntry toEntity() {
    return CategoryGroupRefEntry(id: id, code: code, name: name);
  }
}
