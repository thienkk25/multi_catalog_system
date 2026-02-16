import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/utils/extensions/auth_permission_extension.dart';
import 'package:multi_catalog_system/core/utils/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/utils/formatter/data_time_formatter.dart';
import 'package:multi_catalog_system/core/widgets/custom_alert_dialog.dart';
import 'package:multi_catalog_system/core/widgets/custom_button.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_version_entry.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_event.dart';

import 'category_item_status_chip.dart';

class CategoryItemVersionHistoryCard extends StatelessWidget {
  final CategoryItemVersionEntry entry;
  final int indexVersion;
  const CategoryItemVersionHistoryCard({
    super.key,
    required this.entry,
    required this.indexVersion,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return _InfoBottomSheet(entry: entry);
          },
        );
      },
      child: CustomCard(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.history, size: 22, color: Colors.blue),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      children: [
                        Text(
                          'Phiên bản ${indexVersion + 1}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _changeType(entry.changeType),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(entry.changeSummary ?? '-'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 4,
                      children: [
                        Text(
                          'Ngày tạo: ${dateFormat(entry.createdAt)}',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),

                        if (entry.appliedAt != null)
                          Text(
                            'Áp dụng: ${dateFormat(entry.appliedAt)}',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              CategoryItemStatusChip(status: entry.status ?? ''),
            ],
          ),
        ),
      ),
    );
  }

  Widget _changeType(String? changeType) {
    switch (changeType) {
      case 'create':
        return Icon(Icons.add_circle, size: 16, color: Colors.green);
      case 'update':
        return Icon(Icons.edit, size: 16, color: Colors.blue);
      case 'delete':
        return Icon(Icons.delete, size: 16, color: Colors.red);
      default:
        return const SizedBox.shrink();
    }
  }
}

class _InfoBottomSheet extends StatelessWidget {
  final CategoryItemVersionEntry entry;

  const _InfoBottomSheet({required this.entry});

  @override
  Widget build(BuildContext context) {
    final canRollback = entry.status == 'approved';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.history, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Text(
                    "Chi tiết phiên bản",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  CategoryItemStatusChip(status: entry.status ?? ''),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  const Text(
                    "Loại thay đổi: ",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  _changeTypeLabel(entry.changeType),
                ],
              ),

              const SizedBox(height: 8),

              _infoRow("Người tạo", entry.changeBy),
              _infoRow(
                "Ngày tạo",
                entry.createdAt != null ? dateFormat(entry.createdAt) : null,
              ),
              _infoRow("Người duyệt", entry.approvedBy),
              _infoRow(
                "Ngày áp dụng",
                entry.appliedAt != null ? dateFormat(entry.appliedAt) : null,
              ),

              if (entry.rejectReason != null) ...[
                const SizedBox(height: 8),
                _infoRow("Lý do từ chối", entry.rejectReason),
              ],

              const Divider(height: 32),

              const Text(
                "Mô tả thay đổi",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(entry.changeSummary ?? "-"),

              const SizedBox(height: 20),

              if (entry.oldValue != null) ...[
                const Text(
                  "Giá trị cũ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 6),
                _jsonBox(entry.oldValue!, true),
                const SizedBox(height: 16),
              ],

              if (entry.newValue != null) ...[
                const Text(
                  "Giá trị mới",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 6),
                _jsonBox(entry.newValue!, false),
                const SizedBox(height: 20),
              ],

              if (canRollback && context.hasRole('admin'))
                CustomButton(
                  colorBackground: Colors.blue,
                  textButton: Text(
                    'Khôi phục phiên bản',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () async => _confirmRollback(context),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    if (value == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _jsonBox(Map<String, dynamic> data, bool isOldValue) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isOldValue
            ? Colors.red.withValues(alpha: .05)
            : Colors.green.withValues(alpha: .05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Table(
        columnWidths: const {
          0: IntrinsicColumnWidth(flex: 1),
          1: FlexColumnWidth(),
        },
        border: TableBorder(
          horizontalInside: BorderSide(color: Colors.blue.shade300, width: 0.8),
          verticalInside: BorderSide(color: Colors.blue.shade300, width: 0.8),
        ),
        children: data.entries.map((e) {
          return TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  e.key,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  _formatValue(e.value),
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  String _formatValue(dynamic value) {
    if (value == null) return '';

    if (value is Map) {
      return value.entries.map((e) => "${e.key}: ${e.value}").join(", ");
    }

    if (value is List) {
      return value.join(", ");
    }

    return value.toString();
  }

  Widget _changeTypeLabel(String? type) {
    switch (type) {
      case 'create':
        return const Text("Tạo mới", style: TextStyle(color: Colors.green));
      case 'update':
        return const Text("Cập nhật", style: TextStyle(color: Colors.blue));
      case 'delete':
        return const Text(
          "Vô hiệu hóa",
          style: TextStyle(color: Colors.orange),
        );
      default:
        return const Text("-");
    }
  }

  Future<void> _confirmRollback(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) => CustomAlertDialog(
        title: 'Xác nhận khôi phục',
        content: 'Bạn có chắc chắn muốn khôi phục phiên bản này?',
        confirmText: 'Khôi phục',
        onConfirm: () {
          context.itemVersionBloc.add(
            CategoryItemVersionEvent.rollbackVersion(id: entry.id!),
          );
          context.pop();
        },
      ),
    );
    if (!context.mounted) return;
    context.pop();
  }
}
