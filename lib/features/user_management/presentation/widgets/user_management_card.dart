import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/core/utils/formatter/data_time_formatter.dart';
import 'package:multi_catalog_system/core/utils/formatter/phone_number_fomatter.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/core/widgets/custom_label.dart';
import 'package:multi_catalog_system/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:multi_catalog_system/features/auth/presentation/bloc/auth_state.dart';
import 'package:multi_catalog_system/features/user_management/domain/entities/user_management_entry.dart';
import 'package:multi_catalog_system/features/user_management/presentation/bloc/user_management_bloc.dart';
import 'package:multi_catalog_system/features/user_management/presentation/bloc/user_management_event.dart';
import 'package:multi_catalog_system/features/user_management/presentation/widgets/user_management_avatar_section_widget.dart';

class UserManagementCard extends StatelessWidget {
  final UserManagementEntry entry;
  const UserManagementCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        spacing: 20,
        children: [
          Row(
            spacing: 10,
            children: [
              UserManagementAvatarSectionWidget(entry: entry),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5,
                  children: [
                    BlocSelector<AuthBloc, AuthState, String?>(
                      selector: (state) => state.mapOrNull(
                        authenticated: (value) => value.entry.email,
                      ),
                      builder: (context, email) {
                        return Text(
                          entry.email == email
                              ? 'Tôi'
                              : entry.fullName ?? 'Chưa cập nhật',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                    Text(
                      entry.email ?? '-',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Row(
                      spacing: 5,
                      children: [
                        CustomLabel(
                          text: entry.role?.name ?? 'Chưa có quyền',
                          color: _colorRole(entry.role?.code),
                        ),
                        CustomLabel(
                          text: _status(entry.status),
                          color: _colorStatus(entry.status),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              BlocSelector<AuthBloc, AuthState, String?>(
                selector: (state) => state.mapOrNull(
                  authenticated: (value) => value.entry.email,
                ),
                builder: (context, email) => entry.email == email
                    ? SizedBox.shrink()
                    : PopupMenuButton(
                        icon: SvgPicture.asset(
                          'assets/icons/menu-vertical-menu-dots-more-svgrepo-com.svg',
                          width: 20,
                          height: 20,
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: _UserCardMenu(
                              isLocked: entry.status == 'active',
                              onLockUnlock: () {
                                context.pop();
                                if (entry.status == 'active') {
                                  context.read<UserManagementBloc>().add(
                                    UserManagementEvent.deactivate(
                                      id: entry.id!,
                                    ),
                                  );
                                } else {
                                  context.read<UserManagementBloc>().add(
                                    UserManagementEvent.activate(id: entry.id!),
                                  );
                                }
                              },
                              onEdit: () {
                                context.pushNamed(
                                  RouterNames.userManagementForm,
                                  extra: {
                                    'bloc': context.read<UserManagementBloc>(),
                                    'entry': entry,
                                  },
                                );
                              },
                              onDelete: () {
                                context.pop();
                                context.read<UserManagementBloc>().add(
                                  UserManagementEvent.delete(id: entry.id!),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 10,
            children: [
              CustomLabel(
                text: 'SĐT: ${phoneNumberFormatter(entry.phone)}',
                color: Colors.grey.shade700,
              ),
              CustomLabel(
                text: 'Ngày tạo: ${dateTimeFormat(entry.createdAt)}',
                color: Colors.grey.shade500,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _status(String? status) {
    switch (status) {
      case 'active':
        return 'Hoạt động';
      case 'inactive':
        return 'Khóa';
      default:
        return '-';
    }
  }

  Color _colorStatus(String? status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _colorRole(String? role) {
    switch (role) {
      case 'admin':
        return Colors.red;
      case 'domainOfficer':
        return Colors.blue;
      case 'approver':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

class _UserCardMenu extends StatelessWidget {
  final bool isLocked;
  final VoidCallback? onLockUnlock;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _UserCardMenu({
    required this.onEdit,
    required this.onDelete,
    required this.isLocked,
    required this.onLockUnlock,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 5,
      children: [
        if (isLocked)
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onLockUnlock,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ListTile(
                leading: Icon(Icons.lock, color: Colors.brown),
                title: Text('Khóa tài khoản'),
              ),
            ),
          )
        else
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onLockUnlock,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ListTile(
                leading: Icon(Icons.lock_open, color: Colors.green),
                title: Text('Mở khóa tài khoản'),
              ),
            ),
          ),
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
