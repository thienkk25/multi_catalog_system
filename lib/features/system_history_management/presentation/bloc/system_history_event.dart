import 'package:freezed_annotation/freezed_annotation.dart';

part 'system_history_event.freezed.dart';

@freezed
class SystemHistoryEvent with _$SystemHistoryEvent {
  const factory SystemHistoryEvent.getAll({String? search}) = _GetAll;
  const factory SystemHistoryEvent.getById({required String id}) = _GetById;
}
