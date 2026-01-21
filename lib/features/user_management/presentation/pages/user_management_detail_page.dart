import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/utils/formatter/data_time_formatter.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/core/widgets/custom_circular_progress.dart';
import 'package:multi_catalog_system/core/widgets/custom_label.dart';
import 'package:multi_catalog_system/features/user_management/domain/entities/user_management_entry.dart';
import 'package:multi_catalog_system/features/user_management/presentation/bloc/user_management_bloc.dart';
import 'package:multi_catalog_system/features/user_management/presentation/bloc/user_management_state.dart';
import 'package:multi_catalog_system/features/user_management/presentation/widgets/user_management_avatar_section_widget.dart';

class UserManagementDetailPage extends StatelessWidget {
  const UserManagementDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết người dùng'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<UserManagementBloc, UserManagementState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CustomCircularProgressScreen());
            }
            if (state.error != null) {
              return const Center(child: Text('Xảy ra lỗi'));
            }
            final entry = state.entries.firstOrNull;
            if (entry == null) {
              return const Center(child: Text('Không tìm thấy dữ liệu'));
            }
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    _Header(entry: entry),
                    const SizedBox(height: 16),
                    _InfoSection(entry: entry),
                    const SizedBox(height: 16),
                    _SystemSection(entry: entry),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final UserManagementEntry entry;

  const _Header({required this.entry});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            UserManagementAvatarSectionWidget(entry: entry, sizeAvatar: 100),
            const SizedBox(height: 12),
            Text(
              entry.fullName ?? 'Chưa cập nhật',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              entry.email ?? '-',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomLabel(
                  text: entry.role?.name ?? 'Chưa có quyền',
                  color: _colorRole(entry.role?.code),
                ),
                const SizedBox(width: 8),
                CustomLabel(
                  text: _status(entry.status),
                  color: _colorStatus(entry.status),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final UserManagementEntry entry;

  const _InfoSection({required this.entry});

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Thông tin cá nhân',
      children: [
        _InfoRow(
          icon: Icons.phone,
          label: 'Số điện thoại',
          value: entry.phone == null || entry.phone!.isEmpty
              ? '-'
              : entry.phone!,
        ),
        if (entry.domains != null && entry.domains!.isNotEmpty)
          _InfoRow(
            icon: Icons.business,
            label: 'Lĩnh vực quản lý',
            value: entry.domains == null || entry.domains!.isEmpty
                ? '-'
                : entry.domains!.map((e) => e.name).join(', '),
          ),
      ],
    );
  }
}

class _SystemSection extends StatelessWidget {
  final UserManagementEntry entry;

  const _SystemSection({required this.entry});

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Thông tin hệ thống',
      children: [
        _InfoRow(
          icon: Icons.calendar_today,
          label: 'Ngày tạo',
          value: dateTimeFormatFull(entry.createdAt),
        ),
        _InfoRow(
          icon: Icons.update,
          label: 'Cập nhật gần nhất',
          value: dateTimeFormatFull(entry.updatedAt),
        ),
        _InfoRow(
          icon: Icons.login,
          label: 'Lần đăng nhập cuối',
          value: dateTimeFormatFull(entry.lastSignInAt),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: SizedBox(
              width: 130,
              child: Text(label, style: TextStyle(color: Colors.grey.shade600)),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
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
