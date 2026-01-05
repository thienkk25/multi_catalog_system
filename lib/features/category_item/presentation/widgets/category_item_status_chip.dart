import 'package:flutter/material.dart';

class CategoryItemStatusChip extends StatelessWidget {
  final String status;
  const CategoryItemStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _statusText(status),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _statusText(String status) {
    switch (status) {
      case 'active':
        return 'HOẠT ĐỘNG';
      case 'pending':
        return 'CHỜ DUYỆT';
      case 'rejected':
        return 'TỪ CHỐI';
      default:
        return 'KHÔNG RÕ';
    }
  }
}
