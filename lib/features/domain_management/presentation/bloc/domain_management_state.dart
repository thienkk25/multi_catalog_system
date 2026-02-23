import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/features/domain_management/domain/domain.dart';

part 'domain_management_state.freezed.dart';

@freezed
abstract class DomainManagementState with _$DomainManagementState {
  const factory DomainManagementState({
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasMore,

    String? search,
    @Default(1) int page,
    @Default(20) int limit,
    String? sortBy,
    String? sort,
    Map<String, dynamic>? filter,
    @Default(<DomainEntry>[]) List<DomainEntry> entries,

    DomainEntry? entry,

    String? error,
    String? successMessage,
  }) = _DomainManagementState;
}
