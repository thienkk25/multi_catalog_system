import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/features/domain_management/domain/domain.dart';

part 'domain_management_state.freezed.dart';

@freezed
class DomainManagementState with _$DomainManagementState {
  const factory DomainManagementState.initial() = _Initial;
  const factory DomainManagementState.loading() = _Loading;
  const factory DomainManagementState.loaded({
    required List<DomainEntry> domains,
  }) = _Loaded;
  const factory DomainManagementState.error({required String message}) = _Error;
}
