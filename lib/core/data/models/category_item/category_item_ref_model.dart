import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_item_ref_model.freezed.dart';
part 'category_item_ref_model.g.dart';

@freezed
abstract class CategoryItemRefModel with _$CategoryItemRefModel {
  const factory CategoryItemRefModel({String? id, String? code, String? name}) =
      _CategoryItemRefModel;

  factory CategoryItemRefModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryItemRefModelFromJson(json);
}
