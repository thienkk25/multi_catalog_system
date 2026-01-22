import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/features/domain_management/domain/domain.dart';

part 'domain_management_state.freezed.dart';

@freezed
abstract class DomainManagementState with _$DomainManagementState {
  const factory DomainManagementState({
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasMore,

    @Default(1) int page,
    @Default(20) int limit,

    @Default(<DomainEntry>[]) List<DomainEntry> entries,

    String? error,
    String? successMessage,
  }) = _DomainManagementState;
}
