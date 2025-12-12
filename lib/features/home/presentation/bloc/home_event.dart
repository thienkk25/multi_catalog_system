import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_event.freezed.dart';

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent.started() = _Started;
  const factory HomeEvent.fetchData() = _FetchData;
  const factory HomeEvent.refresh() = _Refresh;
  const factory HomeEvent.changePage(int index) = _ChangePage;
}
