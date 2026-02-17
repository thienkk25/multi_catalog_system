import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/utils/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/core/utils/formatter/data_time_formatter.dart';
import 'package:multi_catalog_system/core/widgets/custom_button.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/core/widgets/error_retry_widget.dart';
import 'package:multi_catalog_system/features/profile/presentation/presentation.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late final ProfileBloc bloc;
  final GlobalKey _bottomBarKey = GlobalKey();
  double _bottomBarHeight = 0;

  @override
  void initState() {
    super.initState();
    bloc = context.profileBloc;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _bottomBarKey.currentContext;
      if (context != null) {
        final height = context.size?.height ?? 0;
        if (height != _bottomBarHeight) {
          setState(() => _bottomBarHeight = height);
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state.error != null) {
          return Center(
            child: ErrorRetryWidget(
              error: state.error!,
              onRetry: () => bloc.add(const ProfileEvent.getProfile()),
            ),
          );
        }

        final entry = state.entry;
        if (entry == null) {
          return const Center(child: Text('Không có dữ liệu'));
        }

        return SafeArea(
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(10),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        ProfileAvatarSectionWidget(entry: entry),
                        const SizedBox(height: 24),
                        _InfoCard(
                          title: 'Thông tin tài khoản',
                          children: [
                            _InfoRow(
                              icon: Icons.person,
                              label: 'Họ tên',
                              value: entry.fullName ?? 'Chưa cập nhật',
                            ),
                            _InfoRow(
                              icon: Icons.email,
                              label: 'Email',
                              value: entry.email ?? '',
                            ),
                            _InfoRow(
                              icon: Icons.phone,
                              label: 'Số điện thoại',
                              value: entry.phone ?? 'Chưa cập nhật',
                            ),
                            _InfoRow(
                              icon: Icons.lock_outline,
                              label: 'Trạng thái',
                              value: _statusText(entry.status ?? ''),
                              valueColor: _statusColor(entry.status ?? ''),
                            ),
                            if (entry.domains != null &&
                                entry.domains!.isNotEmpty)
                              _InfoRow(
                                icon: Icons.domain,
                                label: 'Lĩnh vực quản lý',
                                value: entry.domains!
                                    .map((d) => '${d.name} (${d.code})')
                                    .join(', '),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _InfoCard(
                          title: 'Thời gian',
                          children: [
                            _InfoRow(
                              icon: Icons.calendar_month_outlined,
                              label: 'Ngày tạo',
                              value: dateTimeFormat(entry.createdAt),
                            ),
                            _InfoRow(
                              icon: Icons.login_outlined,
                              label: 'Lần cuối đăng nhập',
                              value: dateTimeFormat(entry.lastSignInAt),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _InfoCard(
                          title: 'Bảo mật',
                          children: [
                            _ActionRow(
                              icon: Icons.lock_outline,
                              label: 'Đổi mật khẩu',
                              onTap: () {
                                context.goNamed(
                                  RouterNames.changePassword,
                                  extra: bloc,
                                );
                              },
                            ),
                          ],
                        ),
                      ]),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(bottom: 60 + _bottomBarHeight),
                  ),
                ],
              ),
              Positioned(
                key: _bottomBarKey,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  color: Colors.white,
                  child: CustomButton(
                    colorBackground: Colors.blue,
                    textButton: Text(
                      'Chỉnh sửa thông tin',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      context.goNamed(RouterNames.profileForm);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _statusText(String status) {
    switch (status) {
      case 'active':
        return 'Hoạt động';
      case 'inactive':
        return 'Khóa';
      default:
        return 'Không xác định';
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _InfoCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),
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
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 5),
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: TextStyle(
                color: valueColor ?? Colors.black87,
                fontWeight: valueColor != null ? FontWeight.bold : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      hoverColor: Colors.blue.withValues(alpha: .2),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.blue),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
