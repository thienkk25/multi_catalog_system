import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_metadata_model.freezed.dart';
part 'app_metadata_model.g.dart';

@freezed
abstract class AppMetadataModel with _$AppMetadataModel {
  const factory AppMetadataModel({String? provider, List<String>? providers}) =
      _AppMetadataModel;

  factory AppMetadataModel.fromJson(Map<String, dynamic> json) =>
      _$AppMetadataModelFromJson(json);
}
