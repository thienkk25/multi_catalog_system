import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/core/domain/entities/domain/domain_ref_entry.dart';

part 'domain_lookup_state.freezed.dart';

@freezed
abstract class DomainLookupState with _$DomainLookupState {
  const factory DomainLookupState({
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasMore,

    @Default(1) int page,
    @Default(20) int limit,
    @Default([]) List<DomainRefEntry> entries,
    String? error,
  }) = _DomainLookupState;
}
