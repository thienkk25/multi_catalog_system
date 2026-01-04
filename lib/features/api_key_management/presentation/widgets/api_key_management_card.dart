import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/features/api_key_management/domain/entries/api_key_entry.dart';

class ApiKeyManagementCard extends StatelessWidget {
  final ApiKeyEntry entry;
  const ApiKeyManagementCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 5,
            children: [
              Text(
                _getHintKey(entry.key),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () => _copyToClipboard(context, entry.key),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SvgPicture.asset(
                    'assets/icons/copy-svgrepo-com.svg',
                    height: 20,
                    width: 20,
                    colorFilter: ColorFilter.mode(
                      Colors.blueAccent,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text('Tên: ${entry.systemName}'),
          Text(
            'Quyền: ${entry.allowedDomains}',
            style: TextStyle(color: Colors.grey),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tạo bởi: ${entry.createdBy ?? 'System'}'),
                  Text('Ngày tạo: ${_formatDate(entry.createdAt)}'),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: _actionColor(entry.status).withValues(alpha: .2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  spacing: 5,
                  children: [
                    CircleAvatar(
                      radius: 5,
                      backgroundColor: _actionColor(entry.status),
                    ),
                    Text(
                      _actionText(entry.status),
                      style: TextStyle(
                        color: _actionColor(entry.status),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _copyToClipboard(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sao chép thành công'),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Color _actionColor(String action) {
    switch (action) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _actionText(String action) {
    switch (action) {
      case 'active':
        return 'Hoạt động';
      case 'inactive':
        return 'Không hoạt động';
      default:
        return 'Không hoạt động';
    }
  }

  String _getHintKey(String key) {
    final start = key.substring(0, 7);
    final end = key.substring(key.length - 4);
    return '$start...$end';
  }
}
