import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/core/utils/extensions/auth_permission_extension.dart';
import 'package:multi_catalog_system/core/utils/formatter/data_time_formatter.dart';
import 'package:multi_catalog_system/core/widgets/custom_alert_dialog.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/core/widgets/role_based_widget.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_entry.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_bloc.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_event.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_bloc.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_event.dart';

import 'category_item_status_chip.dart';

class CategoryItemCard extends StatelessWidget {
  final CategoryItemEntry entry;
  const CategoryItemCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.hasRole('admin');
    return GestureDetector(
      onTap: () {
        context.goNamed(
          RouterNames.categoryItemDetail,
          pathParameters: {'id': entry.id!},
        );
      },
      child: CustomCard(
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
            _InfoRow(label: 'Lĩnh vực', value: entry.group?.domain?.name),
            _InfoRow(label: 'Nhóm', value: entry.group?.name),

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
            if (isAdmin || entry.status == 'active')
              _buildDeleteButton(
                context: context,
                permission: const ['admin', 'domainOfficer'],
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => CustomAlertDialog(
                      title: 'Xác nhận vô hiệu hóa',
                      content: 'Bạn có chắc chắn muốn vô hiệu hóa bản ghi?',
                      onCancel: () => context.pop(),
                      confirmText: 'Vô hiệu hóa',
                      onConfirm: () {
                        if (entry.id == null) return;

                        if (isAdmin) {
                          final bloc = context.read<CategoryItemBloc>();

                          context.pop();
                          bloc.add(CategoryItemEvent.delete(id: entry.id!));
                        } else {
                          final bloc = context.read<CategoryItemVersionBloc>();

                          context.pop();
                          bloc.add(
                            CategoryItemVersionEvent.deleteVersion(
                              id: entry.id!,
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteButton({
    required BuildContext context,
    required List<String> permission,
    required VoidCallback onTap,
  }) {
    final isAdmin = context.hasRole('admin');
    return RoleBasedWidget(
      permission: permission,
      child: Align(
        alignment: Alignment.centerRight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 12),
            GestureDetector(
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  isAdmin ? Icons.delete : Icons.block,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
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
