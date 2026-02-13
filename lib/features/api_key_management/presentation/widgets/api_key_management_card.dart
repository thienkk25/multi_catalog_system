import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/core/utils/formatter/data_time_formatter.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/core/widgets/role_based_widget.dart';
import 'package:multi_catalog_system/features/api_key_management/domain/entities/api_key_entry.dart';
import 'package:multi_catalog_system/features/api_key_management/presentation/bloc/api_key_event.dart';

class ApiKeyManagementCard extends StatelessWidget {
  final ApiKeyEntry entry;
  const ApiKeyManagementCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.goNamed(
          RouterNames.apiKeyDetail,
          pathParameters: {'id': entry.id!},
        );
      },
      child: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 5,
                      children: [
                        Text(
                          _getHintKey(entry.key!),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () => _copyToClipboard(context, entry.key!),
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
                  ],
                ),
                RoleBasedWidget(
                  permission: ['admin', 'domainOfficer'],
                  child: Positioned(
                    right: 0,
                    top: 0,
                    child: PopupMenuButton(
                      icon: SvgPicture.asset(
                        'assets/icons/menu-vertical-menu-dots-more-svgrepo-com.svg',
                        width: 20,
                        height: 20,
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: _APIKeyCardMenu(
                            onEdit: () {
                              context.pop();
                              context.goNamed(
                                RouterNames.apiKeyForm,
                                queryParameters: {
                                  'mode': 'update',
                                  'id': entry.id!,
                                },
                              );
                            },
                            onDelete: () {
                              context.pop();
                              context.apiKeyBloc.add(
                                ApiKeyEvent.delete(id: entry.id!),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tạo bởi: ${entry.createdBy ?? 'System'}'),
                      Text('Ngày tạo: ${dateFormat(entry.createdAt!)}'),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                  decoration: BoxDecoration(
                    color: _actionColor(entry.status!).withValues(alpha: .2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    spacing: 5,
                    children: [
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: _actionColor(entry.status!),
                      ),
                      Text(
                        _actionText(entry.status!),
                        style: TextStyle(
                          color: _actionColor(entry.status!),
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
      ),
    );
  }

  Future<void> _copyToClipboard(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    context.notificationCubit.success('Sao chép API Key thành công');
  }

  Color _actionColor(String action) {
    switch (action) {
      case 'active':
        return Colors.green;
      case 'revoked':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _actionText(String action) {
    switch (action) {
      case 'active':
        return 'Hoạt động';
      case 'revoked':
        return 'Thu hồi';
      default:
        return 'Thu hồi';
    }
  }

  String _getHintKey(String key) {
    final start = key.substring(0, 7);
    final end = key.substring(key.length - 4);
    return '$start...$end';
  }
}

class _APIKeyCardMenu extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _APIKeyCardMenu({required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 5,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onEdit,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ListTile(
              leading: Icon(Icons.edit, color: Colors.blue),
              title: Text('Chỉnh sửa'),
            ),
          ),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onDelete,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Xóa'),
            ),
          ),
        ),
      ],
    );
  }
}
