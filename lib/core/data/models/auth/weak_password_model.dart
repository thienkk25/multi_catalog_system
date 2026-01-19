import 'package:freezed_annotation/freezed_annotation.dart';

part 'weak_password_model.freezed.dart';
part 'weak_password_model.g.dart';

@freezed
abstract class WeakPasswordModel with _$WeakPasswordModel {
  const factory WeakPasswordModel({String? message, List<String>? reasons}) =
      _WeakPasswordModel;

  factory WeakPasswordModel.fromJson(Map<String, dynamic> json) =>
      _$WeakPasswordModelFromJson(json);
}
