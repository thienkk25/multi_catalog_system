import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/core/data/models/domain/domain_ref_model.dart';

part 'api_key_model.freezed.dart';
part 'api_key_model.g.dart';

@freezed
abstract class ApiKeyModel with _$ApiKeyModel {
  const factory ApiKeyModel({
    required String id,
    required String key,
    @JsonKey(name: 'system_name') required String systemName,
    @JsonKey(name: 'allowed_domains')
    required List<DomainRefModel> allowedDomains,
    required String status,
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _ApiKeyModel;

  factory ApiKeyModel.fromJson(Map<String, dynamic> json) =>
      _$ApiKeyModelFromJson(json);
}
