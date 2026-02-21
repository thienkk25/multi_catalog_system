import 'package:equatable/equatable.dart';

class DomainRefEntry extends Equatable {
  final String? id;
  final String? code;
  final String? name;

  const DomainRefEntry({this.id, this.name, this.code});

  @override
  List<Object?> get props => [id, name, code];
}
