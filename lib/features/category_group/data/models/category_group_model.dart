import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/core/data/models/domain/domain_ref_model.dart';

part 'category_group_model.freezed.dart';
part 'category_group_model.g.dart';

@freezed
abstract class CategoryGroupModel with _$CategoryGroupModel {
  const factory CategoryGroupModel({
    required String id,
    required String code,
    required String name,
    String? description,
    required DomainRefModel domain,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _CategoryGroupModel;

  factory CategoryGroupModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryGroupModelFromJson(json);
}
