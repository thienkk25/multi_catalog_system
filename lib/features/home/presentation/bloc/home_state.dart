import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;
  const factory HomeState.loading() = _Loading;
  const factory HomeState.success(String data) = _Success;
  const factory HomeState.error(String message) = _Error;
  const factory HomeState.page(int index, String title) = _Page;
}
