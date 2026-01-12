import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_group_model.freezed.dart';
part 'category_group_model.g.dart';

@freezed
abstract class CategoryGroupModel with _$CategoryGroupModel {
  const factory CategoryGroupModel({
    required String id,
    @JsonKey(name: 'domain_id') required String domainId,
    required String code,
    required String name,
    required String description,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _CategoryGroupModel;

  factory CategoryGroupModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryGroupModelFromJson(json);
}
