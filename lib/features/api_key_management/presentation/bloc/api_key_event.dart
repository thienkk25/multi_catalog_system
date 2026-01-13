import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:multi_catalog_system/features/api_key_management/domain/entities/api_key_entry.dart';

part 'api_key_event.freezed.dart';

@freezed
class ApiKeyEvent with _$ApiKeyEvent {
  const factory ApiKeyEvent.getAll({String? search}) = _GetAll;
  const factory ApiKeyEvent.getById({required String id}) = _GetById;

  const factory ApiKeyEvent.create({required ApiKeyEntry entry}) = _Create;
  const factory ApiKeyEvent.createMany({required List<ApiKeyEntry> entries}) =
      _CreateMany;
  const factory ApiKeyEvent.upsertMany({required List<ApiKeyEntry> entries}) =
      _UpsertMany;

  const factory ApiKeyEvent.update({required ApiKeyEntry entry}) = _Update;

  const factory ApiKeyEvent.delete({required String id}) = _Delete;
}
