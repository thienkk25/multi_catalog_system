import 'package:equatable/equatable.dart';

class CategoryItemVersionEntry extends Equatable {
  final String? id;
  final String? itemId;
  final Map<String, dynamic>? oldValue;
  final Map<String, dynamic>? newValue;
  final String? changeSummary;
  final String? changeType;
  final String? status;
  final String? changeBy;
  final String? approvedBy;
  final String? rejectReason;
  final DateTime? appliedAt;
  final DateTime? createdAt;

  const CategoryItemVersionEntry({
    this.id,
    this.itemId,
    this.oldValue,
    this.newValue,
    this.changeSummary,
    this.changeType,
    this.status,
    this.changeBy,
    this.approvedBy,
    this.rejectReason,
    this.appliedAt,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    itemId,
    oldValue,
    newValue,
    changeSummary,
    changeType,
    status,
    changeBy,
    approvedBy,
    rejectReason,
    appliedAt,
    createdAt,
  ];
}
