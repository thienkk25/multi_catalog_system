import 'package:freezed_annotation/freezed_annotation.dart';
import 'category_group_res_model.dart';

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
    @JsonKey(name: 'group_id') String? groupId,
    required CategoryGroupResModel group,
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'updated_by') String? updatedBy,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _CategoryItemModel;

  factory CategoryItemModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryItemModelFromJson(json);
}
