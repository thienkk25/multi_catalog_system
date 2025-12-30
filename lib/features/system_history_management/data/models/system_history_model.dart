import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/features/system_history_management/domain/entries/system_history_entry.dart';

part 'system_history_model.freezed.dart';
part 'system_history_model.g.dart';

@freezed
abstract class SystemHistoryModel with _$SystemHistoryModel {
  const factory SystemHistoryModel({
    required int id,
    String? userId,
    required String action,
    required String method,
    required String enpoint,
    required Map<String, dynamic> metadata,
    required DateTime timestamp,
  }) = _SystemHistoryModel;

  factory SystemHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$SystemHistoryModelFromJson(json);

  factory SystemHistoryModel.fromEntity(SystemHistoryEntry domain) =>
      SystemHistoryModel(
        id: domain.id,
        userId: domain.userId,
        action: domain.action,
        method: domain.method,
        enpoint: domain.endpoint,
        metadata: domain.metadata,
        timestamp: domain.timestamp,
      );
}

extension SystemHistoryModelMapper on SystemHistoryModel {
  SystemHistoryEntry toEntity() => SystemHistoryEntry(
    id: id,
    userId: userId,
    action: action,
    method: method,
    endpoint: enpoint,
    metadata: metadata,
    timestamp: timestamp,
  );
}
