import 'package:equatable/equatable.dart';

class SystemHistoryEntry extends Equatable {
  final int id;
  final String? userId;
  final String action;
  final String method;
  final String endpoint;
  final Map<String, dynamic> metadata;
  final DateTime timestamp;

  const SystemHistoryEntry({
    required this.id,
    required this.userId,
    required this.action,
    required this.method,
    required this.endpoint,
    required this.metadata,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    action,
    method,
    endpoint,
    metadata,
    timestamp,
  ];
}
