import 'package:freezed_annotation/freezed_annotation.dart';

part 'system_history_model.freezed.dart';
part 'system_history_model.g.dart';

@freezed
abstract class SystemHistoryModel with _$SystemHistoryModel {
  const factory SystemHistoryModel({
    required int id,
    @JsonKey(name: 'user_id') String? userId,
    required String action,
    required String method,
    required String endpoint,
    required Map<String, dynamic> metadata,
    required DateTime timestamp,
  }) = _SystemHistoryModel;

  factory SystemHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$SystemHistoryModelFromJson(json);
}
