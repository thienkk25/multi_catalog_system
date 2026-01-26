import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/core/utils/formatter/data_time_formatter.dart';
import 'package:multi_catalog_system/core/utils/formatter/phone_number_fomatter.dart';
import 'package:multi_catalog_system/core/widgets/custom_alert_dialog.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/core/widgets/custom_label.dart';
import 'package:multi_catalog_system/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:multi_catalog_system/features/auth/presentation/bloc/auth_state.dart';
import 'package:multi_catalog_system/features/user_management/domain/entities/user_management_entry.dart';
import 'package:multi_catalog_system/features/user_management/presentation/bloc/user_management_bloc.dart';
import 'package:multi_catalog_system/features/user_management/presentation/bloc/user_management_event.dart';
import 'package:multi_catalog_system/features/user_management/presentation/widgets/user_management_avatar_section_widget.dart';

import 'user_management_dialog_grant_access.dart';

class UserManagementCard extends StatelessWidget {
  final UserManagementEntry entry;

  const UserManagementCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(entry: entry),
          const SizedBox(height: 12),
          _MetaInfo(entry: entry),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final UserManagementEntry entry;

  const _Header({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserManagementAvatarSectionWidget(entry: entry),
        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocSelector<AuthBloc, AuthState, String?>(
                selector: (state) =>
                    state.mapOrNull(authenticated: (v) => v.entry.email),
                builder: (context, email) {
                  return Text(
                    entry.email == email
                        ? 'Tôi'
                        : entry.fullName ?? 'Chưa cập nhật',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
              const SizedBox(height: 2),
              Text(
                entry.email ?? '-',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  CustomLabel(
                    text: entry.role?.name ?? 'Chưa có quyền',
                    color: _colorRole(entry.role?.code),
                  ),
                  const SizedBox(width: 6),
                  CustomLabel(
                    text: _status(entry.status),
                    color: _colorStatus(entry.status),
                  ),
                ],
              ),
            ],
          ),
        ),

        _ActionMenu(entry: entry),
      ],
    );
  }
}

class _ActionMenu extends StatelessWidget {
  final UserManagementEntry entry;

  const _ActionMenu({required this.entry});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AuthBloc, AuthState, String?>(
      selector: (state) => state.mapOrNull(authenticated: (v) => v.entry.email),
      builder: (context, email) {
        if (entry.email == email) return const SizedBox.shrink();

        return PopupMenuButton<_MenuAction>(
          icon: const Icon(Icons.more_vert, size: 20),
          onSelected: (action) {
            final bloc = context.read<UserManagementBloc>();

            switch (action) {
              case _MenuAction.lock:
                bloc.add(UserManagementEvent.deactivate(id: entry.id!));
                break;
              case _MenuAction.unlock:
                bloc.add(UserManagementEvent.activate(id: entry.id!));
                break;
              case _MenuAction.grant:
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      UserManagementDialogGrantAccess(bloc: bloc, entry: entry),
                );
                break;
              case _MenuAction.edit:
                context.pushNamed(
                  RouterNames.userManagementForm,
                  extra: {'bloc': bloc, 'entry': entry},
                );
                break;
              case _MenuAction.delete:
                showDialog(
                  context: context,
                  builder: (_) => CustomAlertDialog(
                    onCancel: () => context.pop(),
                    onConfirm: () {
                      context.pop();
                      bloc.add(UserManagementEvent.delete(id: entry.id!));
                    },
                  ),
                );
                break;
            }
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              value: entry.status == 'active'
                  ? _MenuAction.lock
                  : _MenuAction.unlock,
              child: Row(
                children: [
                  Icon(
                    entry.status == 'active' ? Icons.lock : Icons.lock_open,
                    size: 18,
                    color: entry.status == 'active' ? Colors.red : Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    entry.status == 'active'
                        ? 'Khóa tài khoản'
                        : 'Mở khóa tài khoản',
                  ),
                ],
              ),
            ),
            const PopupMenuItem(
              value: _MenuAction.grant,
              child: Row(
                children: [
                  Icon(Icons.security_outlined, size: 18, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Quyền tài khoản'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: _MenuAction.edit,
              child: Row(
                children: [
                  Icon(Icons.edit, size: 18),
                  SizedBox(width: 8),
                  Text('Chỉnh sửa'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: _MenuAction.delete,
              child: Row(
                children: [
                  Icon(Icons.delete, size: 18, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Xóa'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

enum _MenuAction { lock, unlock, grant, edit, delete }

class _MetaInfo extends StatelessWidget {
  final UserManagementEntry entry;

  const _MetaInfo({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        _InfoItem(icon: Icons.phone, text: phoneNumberFormatter(entry.phone)),
        _InfoItem(
          icon: Icons.calendar_today,
          text: 'Tạo: ${dateTimeFormat(entry.createdAt)}',
        ),
        _InfoItem(
          icon: Icons.login,
          text: 'Đăng nhập: ${dateTimeFormat(entry.lastSignInAt)}',
        ),
      ],
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      ],
    );
  }
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
