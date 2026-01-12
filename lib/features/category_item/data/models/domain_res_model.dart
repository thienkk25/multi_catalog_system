import 'package:freezed_annotation/freezed_annotation.dart';

part 'domain_res_model.freezed.dart';
part 'domain_res_model.g.dart';

@freezed
abstract class DomainResModel with _$DomainResModel {
  const factory DomainResModel({
    required String id,
    required String code,
    required String name,
  }) = _DomainResModel;

  factory DomainResModel.fromJson(Map<String, dynamic> json) =>
      _$DomainResModelFromJson(json);
}
