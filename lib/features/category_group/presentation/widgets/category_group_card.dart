import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/utils/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/core/widgets/custom_alert_dialog.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/core/widgets/role_based_widget.dart';
import 'package:multi_catalog_system/core/widgets/app_network_image.dart';
import 'package:multi_catalog_system/features/category_group/domain/entities/category_group_entry.dart';
import 'package:multi_catalog_system/features/category_group/presentation/bloc/category_group_event.dart';

class CategoryGroupCard extends StatelessWidget {
  final CategoryGroupEntry entry;
  const CategoryGroupCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: () {
        context.goNamed(
          RouterNames.categoryGroupDetail,
          pathParameters: {'id': entry.id!},
        );
      },
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (entry.imageUrl != null && entry.imageUrl!.isNotEmpty) ...[
                  AppNetworkImage(
                    imageUrl: entry.imageUrl,
                    width: 48,
                    height: 48,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mã: ${entry.code}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Tên: ${entry.name}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Text(
              'Lĩnh vực: ${entry.domain?.name}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 5),
            RoleBasedWidget(
              permission: ['admin', 'domainOfficer'],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: 10,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _onUpdate(context: context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.edit, size: 14),
                    label: const Text('Chỉnh sửa', style: TextStyle(fontSize: 12)),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _onRemove(context: context, id: entry.id!),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.delete, size: 14),
                    label: const Text('Xóa', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }

  void _onUpdate({required BuildContext context}) {
    context.goNamed(
      RouterNames.categoryGroupForm,
      queryParameters: {'mode': 'update', 'id': entry.id},
    );
  }

  void _onRemove({required BuildContext context, required String id}) {
    final bloc = context.groupBloc;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomAlertDialog(
          onConfirm: () {
            bloc.add(CategoryGroupEvent.delete(id: id));
            context.pop();
          },
        );
      },
    );
  }
}
