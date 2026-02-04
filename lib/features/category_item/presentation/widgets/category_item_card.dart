import 'package:flutter/material.dart';
import 'package:multi_catalog_system/core/utils/formatter/data_time_formatter.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_entry.dart';

import 'category_item_status_chip.dart';

class CategoryItemCard extends StatelessWidget {
  final CategoryItemEntry entry;
  const CategoryItemCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  entry.name!,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ),
              CategoryItemStatusChip(status: entry.status ?? '-'),
            ],
          ),

          const SizedBox(height: 12),

          _InfoRow(label: 'Mã mục', value: entry.code),
          _InfoRow(label: 'Lĩnh vực', value: entry.domainName),
          _InfoRow(label: 'Nhóm', value: entry.groupName),

          if (entry.description?.isNotEmpty == true) ...[
            const SizedBox(height: 8),
            Text(
              'Mô tả: ${entry.description}',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ],

          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Tạo ngày ${dateFormat(entry.createdAt!)}',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String? value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? '-',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
