import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/core/widgets/custom_button.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/core/widgets/error_retry_widget.dart';
import 'package:multi_catalog_system/features/profile/domain/entities/user_entry.dart';
import 'package:multi_catalog_system/features/profile/presentation/presentation.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ProfileBloc bloc;
  final GlobalKey _bottomBarKey = GlobalKey();
  double _bottomBarHeight = 0;

  @override
  void initState() {
    super.initState();
    bloc = context.read<ProfileBloc>();
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
    _bottomBarKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thông tin cá nhân'), centerTitle: true),
      body: SafeArea(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) => state.when((
            isLoading,
            entry,
            error,
            successMessage,
          ) {
            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (error != null) {
              return Center(
                child: ErrorRetryWidget(
                  error: error,
                  onRetry: () {
                    bloc.add(const ProfileEvent.getUser());
                  },
                ),
              );
            }
            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(10),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          _AvatarSection(entry: entry),
                          const SizedBox(height: 24),
                          _InfoCard(
                            title: 'Thông tin tài khoản',
                            children: [
                              _InfoRow(
                                label: 'Họ tên',
                                value: entry?.fullName ?? 'Chưa cập nhật',
                              ),
                              _InfoRow(
                                label: 'Email',
                                value: entry?.email ?? '',
                              ),
                              _InfoRow(
                                label: 'Số điện thoại',
                                value: entry?.phone ?? 'Chưa cập nhật',
                              ),
                              _InfoRow(
                                label: 'Trạng thái',
                                value: _statusText(entry?.status ?? ''),
                                valueColor: _statusColor(entry?.status ?? ''),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _InfoCard(
                            title: 'Thời gian',
                            children: [
                              _InfoRow(
                                label: 'Ngày tạo',
                                value: _formatDate(entry?.createdAt),
                              ),
                              _InfoRow(
                                label: 'Cập nhật lần cuối',
                                value: _formatDate(entry?.updatedAt),
                              ),
                            ],
                          ),
                        ]),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.only(bottom: _bottomBarHeight),
                    ),
                  ],
                ),
                Positioned(
                  key: _bottomBarKey,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CustomButton(
                      colorBackground: Colors.blue,
                      textButton: Text(
                        'Chỉnh sửa thông tin',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        context.pushNamed(RouterNames.profileForm);
                      },
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  String _statusText(String status) {
    switch (status) {
      case 'active':
        return 'Hoạt động';
      case 'inactive':
        return 'Không hoạt động';
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

class _AvatarSection extends StatelessWidget {
  final UserEntry? entry;

  const _AvatarSection({this.entry});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey.shade300,
          child: Text(
            entry?.fullName != null && entry!.fullName!.isNotEmpty
                ? entry!.fullName![0].toUpperCase()
                : '?',
            style: const TextStyle(fontSize: 40),
          ),
        ),
        if (entry?.fullName != null)
          Text(
            entry?.fullName ?? '',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        if (entry?.email != null) Text(entry?.email ?? ''),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _InfoCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      color: Colors.blue.shade50,
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
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
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
