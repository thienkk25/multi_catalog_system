import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/features/api_key_management/domain/entries/api_key_entry.dart';

part 'api_key_model.freezed.dart';
part 'api_key_model.g.dart';

@freezed
abstract class ApiKeyModel with _$ApiKeyModel {
  const factory ApiKeyModel({
    String? id,
    required String key,
    @JsonKey(name: 'system_name') required String systemName,
    @JsonKey(name: 'allowed_domains') List<String>? allowedDomains,
    required String status,
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _ApiKeyModel;

  factory ApiKeyModel.fromJson(Map<String, dynamic> json) =>
      _$ApiKeyModelFromJson(json);

  factory ApiKeyModel.fromEntity(ApiKeyEntry entry) => ApiKeyModel(
    id: entry.id,
    key: entry.key,
    systemName: entry.systemName,
    allowedDomains: entry.allowedDomains,
    status: entry.status,
    createdBy: entry.createdBy,
    createdAt: entry.createdAt,
  );
}

extension ApiKeyModelMapper on ApiKeyModel {
  ApiKeyEntry toEntity() => ApiKeyEntry(
    id: id,
    key: key,
    systemName: systemName,
    allowedDomains: allowedDomains,
    status: status,
    createdBy: createdBy,
    createdAt: createdAt,
  );
}
