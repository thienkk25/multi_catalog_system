import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/core/widgets/custom_alert_dialog.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/core/widgets/role_based_widget.dart';
import 'package:multi_catalog_system/features/domain_management/domain/entities/domain_entry.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/bloc/domain_management_bloc.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/bloc/domain_management_event.dart';

class DomainManagementCard extends StatelessWidget {
  final DomainEntry entry;
  const DomainManagementCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              Text(
                'Mã: ${entry.code}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                entry.name!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                entry.description ?? '',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
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
                    child: _DomainCardMenu(
                      onEdit: () => _onUpdate(context: context),
                      onDelete: () => _onRemove(context: context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onUpdate({required BuildContext context}) {
    context.pop();
    context.pushNamed(
      RouterNames.domainForm,
      extra: {'bloc': context.read<DomainManagementBloc>(), 'entry': entry},
    );
  }

  void _onRemove({required BuildContext context}) {
    context.pop();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CustomAlertDialog(
        onConfirm: () {
          final id = entry.id;
          if (id == null) return;
          context.read<DomainManagementBloc>().add(
            DomainManagementEvent.delete(id: id),
          );
          context.pop();
        },
      ),
    );
  }
}

class _DomainCardMenu extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _DomainCardMenu({required this.onEdit, required this.onDelete});

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
