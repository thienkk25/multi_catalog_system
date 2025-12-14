import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/features/domain_management/domain/entities/domain_entry.dart';

part 'domain_management_event.freezed.dart';

@freezed
class DomainManagementEvent with _$DomainManagementEvent {
  const factory DomainManagementEvent.getAll() = _GetAll;
  const factory DomainManagementEvent.getById({required String id}) = _GetById;

  const factory DomainManagementEvent.create({required DomainEntry domain}) =
      _Create;
  const factory DomainManagementEvent.createMany({
    required List<DomainEntry> domains,
  }) = _CreateMany;
  const factory DomainManagementEvent.upsertMany({
    required List<DomainEntry> domains,
  }) = _UpsertMany;

  const factory DomainManagementEvent.update({required DomainEntry domain}) =
      _Update;

  const factory DomainManagementEvent.delete({required String id}) = _Delete;
}
