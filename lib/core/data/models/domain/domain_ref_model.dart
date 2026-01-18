import 'package:freezed_annotation/freezed_annotation.dart';

part 'domain_ref_model.freezed.dart';
part 'domain_ref_model.g.dart';

@freezed
abstract class DomainRefModel with _$DomainRefModel {
  const factory DomainRefModel({
    required String id,
    required String code,
    required String name,
  }) = _DomainRefModel;

  factory DomainRefModel.fromJson(Map<String, dynamic> json) =>
      _$DomainRefModelFromJson(json);
}
