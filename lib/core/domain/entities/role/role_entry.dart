import 'package:equatable/equatable.dart';

class RoleEntry extends Equatable {
  final int? id;
  final String? code;
  final String? name;

  const RoleEntry({this.id, this.code, this.name});

  @override
  List<Object?> get props => [id, code, name];
}
