import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/features/domain_management/domain/entities/domain_entry.dart';

part 'domain_management_event.freezed.dart';

@freezed
class DomainManagementEvent with _$DomainManagementEvent {
  const factory DomainManagementEvent.getAll({String? search}) = _GetAll;
  const factory DomainManagementEvent.getById({required String id}) = _GetById;

  const factory DomainManagementEvent.create({required DomainEntry entry}) =
      _Create;
  const factory DomainManagementEvent.createMany({
    required List<DomainEntry> entities,
  }) = _CreateMany;
  const factory DomainManagementEvent.upsertMany({
    required List<DomainEntry> entities,
  }) = _UpsertMany;

  const factory DomainManagementEvent.update({required DomainEntry entry}) =
      _Update;

  const factory DomainManagementEvent.delete({required String id}) = _Delete;
}
