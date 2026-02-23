import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/features/domain_management/domain/entities/domain_entry.dart';

part 'domain_management_event.freezed.dart';

@freezed
class DomainManagementEvent with _$DomainManagementEvent {
  const factory DomainManagementEvent.getAll({
    String? search,
    int? page,
    int? limit,
    String? sortBy,
    String? sort,
    Map<String, dynamic>? filter,
  }) = _GetAll;
  const factory DomainManagementEvent.loadMore() = _LoadMore;
  const factory DomainManagementEvent.getById({required String id}) = _GetById;

  const factory DomainManagementEvent.create({required DomainEntry entry}) =
      _Create;

  const factory DomainManagementEvent.update({required DomainEntry entry}) =
      _Update;

  const factory DomainManagementEvent.delete({required String id}) = _Delete;
}
