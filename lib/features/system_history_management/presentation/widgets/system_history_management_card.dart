import 'package:flutter/material.dart';
import 'package:multi_catalog_system/core/utils/formatter/data_time_formatter.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/features/system_history_management/domain/entities/system_history_entry.dart';

class SystemHistoryManagementCard extends StatelessWidget {
  final SystemHistoryEntry log;

  const SystemHistoryManagementCard({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    final time = dateTimeFormat(log.timestamp);

    return CustomCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _actionIconColor(log.action).withValues(alpha: .1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _actionIcon(log.action),
              size: 20,
              color: _actionIconColor(log.action),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                RichText(
                  text: TextSpan(
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.black87),
                    children: [
                      TextSpan(
                        text: log.userId ?? 'Hệ thống',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(text: ' ${_actionText(log)}'),
                    ],
                  ),
                ),
                Text(
                  '${log.userId ?? 'System'} • $time',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _actionIcon(String action) {
    switch (action) {
      case 'UPDATE':
        return Icons.edit;
      case 'INSERT':
        return Icons.add;
      case 'DELETE':
        return Icons.delete_outline;
      case 'LOGIN':
        return Icons.login;
      case 'LOGOUT':
        return Icons.logout;
      default:
        return Icons.settings;
    }
  }

  Color _actionIconColor(String action) {
    switch (action) {
      case 'UPDATE':
        return Colors.green;
      case 'DELETE':
        return Colors.red;
      case 'LOGIN':
        return Colors.green;
      case 'LOGOUT':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  String _actionText(SystemHistoryEntry log) {
    switch (log.action) {
      case 'UPDATE':
        return 'đã cập nhật ${log.method}';
      case 'INSERT':
        return 'đã tạo mới ${log.method}';
      case 'DELETE':
        return 'đã xóa ${log.method}';
      case 'LOGIN':
        return 'đã đăng nhập vào hệ thống';
      case 'LOGOUT':
        return 'đã đăng xuất';
      default:
        return 'thực hiện hành động hệ thống';
    }
  }
}
