import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/utils/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/core/widgets/custom_alert_dialog.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/core/widgets/role_based_widget.dart';
import 'package:multi_catalog_system/features/category_group/domain/entities/category_group_entry.dart';
import 'package:multi_catalog_system/features/category_group/presentation/bloc/category_group_event.dart';

class CategoryGroupCard extends StatelessWidget {
  final CategoryGroupEntry entry;
  const CategoryGroupCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.goNamed(
          RouterNames.categoryGroupDetail,
          pathParameters: {'id': entry.id!},
        );
      },
      child: CustomCard(
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                  GestureDetector(
                    onTap: () => _onUpdate(context: context),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Row(
                        spacing: 4,
                        children: [
                          Icon(Icons.edit, color: Colors.white, size: 12),
                          Text(
                            'Chỉnh sửa',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _onRemove(context: context, id: entry.id!),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Row(
                        spacing: 4,
                        children: [
                          Icon(Icons.delete, color: Colors.white, size: 12),
                          Text(
                            'Xóa',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
