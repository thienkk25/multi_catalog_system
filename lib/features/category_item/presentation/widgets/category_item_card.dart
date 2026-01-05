import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/core/widgets/custom_label.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_entry.dart';

class CategoryItemCard extends StatelessWidget {
  final CategoryItemEntry entry;
  const CategoryItemCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tên: ${entry.name}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              CustomLabel(
                color: _actionStatusColor(entry.status),
                text: _actionStatus(entry.status),
              ),
            ],
          ),
          Text('Mã: ${entry.code}'),

          Text(
            'Lĩnh vực: ${entry.group.domainResEntry.name} | Nhóm: ${entry.group.name}',
          ),
          Text('Mô tả: ${entry.description}'),
          Row(
            children: [
              Spacer(),
              Text(
                'Ngày tạo: ${DateFormat('dd/MM/yyyy').format(entry.createdAt)}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _actionStatus(String status) {
    switch (status) {
      case 'active':
        return 'Hoạt động';
      case 'pending':
        return 'Chờ duyệt';
      case 'rejected':
        return 'Từ chối';
      default:
        return 'Không xác định';
    }
  }

  Color _actionStatusColor(String status) {
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
}
