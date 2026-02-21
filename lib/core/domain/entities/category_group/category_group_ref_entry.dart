import 'package:equatable/equatable.dart';

class CategoryGroupRefEntry extends Equatable {
  final String? id;
  final String? code;
  final String? name;

  const CategoryGroupRefEntry({this.id, this.name, this.code});

  @override
  List<Object?> get props => [id, name, code];
}
