import 'package:equatable/equatable.dart';

class CategoryItemRefEntry extends Equatable {
  final String? id;
  final String? code;
  final String? name;

  const CategoryItemRefEntry({this.id, this.code, this.name});

  @override
  List<Object?> get props => [id, code, name];
}
