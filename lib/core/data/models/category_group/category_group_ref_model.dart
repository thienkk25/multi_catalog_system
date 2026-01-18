import 'package:freezed_annotation/freezed_annotation.dart';

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
}
