import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multi_catalog_system/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:multi_catalog_system/features/auth/presentation/bloc/auth_state.dart';
import 'package:multi_catalog_system/features/home/presentation/bloc/home_bloc.dart';
import 'package:multi_catalog_system/features/home/presentation/bloc/home_event.dart';
import 'package:multi_catalog_system/features/home/presentation/bloc/home_state.dart';
import 'package:multi_catalog_system/features/import_file/presentation/pages/import_file_page.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [_HeaderDrawer(), _MainDrawer(), _FooterDrawer()],
          ),
        ),
      ),
    );
  }
}

class _HeaderDrawer extends StatelessWidget {
  const _HeaderDrawer();

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox(),

              loading: () => const CircularProgressIndicator(),

              unauthenticated: () {
                return Row(
                  children: const [
                    CircleAvatar(radius: 30, child: Icon(Icons.person_outline)),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chưa đăng nhập',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text('Vui lòng đăng nhập'),
                      ],
                    ),
                  ],
                );
              },

              authenticated: (user) {
                return Row(
                  children: [
                    CircleAvatar(radius: 30, child: const Icon(Icons.person)),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.fullName ?? 'Không tên',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text('Email: ${user.email}'),
                      ],
                    ),
                  ],
                );
              },

              error: (message) {
                return Text(message, style: const TextStyle(color: Colors.red));
              },
            );
          },
        ),
      ],
    );
  }
}

class _MainDrawer extends StatelessWidget {
  const _MainDrawer();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      key: ValueKey('drawer'),
      child: SingleChildScrollView(
        child: Column(
          spacing: 10,
          children: [
            Divider(),
            _DrawerItem(
              icon: Icon(Icons.search, size: 20),
              title: 'Tra cứu danh mục',
              pageIndex: 0,
            ),
            _DrawerItem(
              icon: SvgPicture.asset(
                'assets/icons/folder-favourites-svgrepo-com.svg',
                height: 20,
              ),
              title: 'Lĩnh vực',
              pageIndex: 1,
            ),
            _DrawerItem(
              icon: SvgPicture.asset(
                'assets/icons/folder-document-svgrepo-com.svg',
                height: 20,
              ),
              title: 'Nhóm danh mục',
              pageIndex: 2,
            ),
            _DrawerItem(
              icon: SvgPicture.asset(
                'assets/icons/document-text-svgrepo-com.svg',
                height: 20,
              ),
              title: 'Mục danh mục',
              pageIndex: 3,
            ),
            _DrawerItem(
              icon: SvgPicture.asset(
                'assets/icons/legal-hammer-symbol-svgrepo-com.svg',
                height: 20,
              ),
              title: 'Văn bản pháp lý',
              pageIndex: 4,
            ),
            _DrawerItem(
              icon: SvgPicture.asset(
                'assets/icons/approve-invoice-svgrepo-com.svg',
                height: 20,
              ),
              title: 'Danh sách chờ duyệt',
              pageIndex: 5,
            ),

            Divider(),

            _DrawerItem(
              icon: SvgPicture.asset(
                'assets/icons/import-svgrepo-com.svg',
                height: 20,
              ),
              title: 'Nhập dữ liệu File',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImportFilePage(typeImport: 0),
                  ),
                );
              },
            ),
            _DrawerItem(
              icon: SvgPicture.asset(
                'assets/icons/group-svgrepo-com.svg',
                height: 20,
              ),
              title: 'Quản lý người dùng',
              pageIndex: 7,
            ),
            _DrawerItem(
              icon: SvgPicture.asset(
                'assets/icons/key-svgrepo-com.svg',
                height: 20,
              ),
              title: 'API Key',
              pageIndex: 8,
            ),
            _DrawerItem(
              icon: SvgPicture.asset(
                'assets/icons/history-svgrepo-com.svg',
                height: 20,
              ),
              title: 'Nhật kí hệ thống',
              pageIndex: 9,
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterDrawer extends StatelessWidget {
  const _FooterDrawer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(10),
          hoverColor: Colors.blue.withValues(alpha: .2),
          onTap: () {},
          child: ListTile(
            leading: SvgPicture.asset(
              'assets/icons/profile-circle-svgrepo-com.svg',
              height: 20,
              width: 20,
              fit: BoxFit.contain,
            ),
            title: Text('Hồ sơ'),
          ),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(10),
          hoverColor: Colors.blue.withValues(alpha: .2),
          onTap: () {},
          child: ListTile(
            leading: Icon(Icons.exit_to_app_outlined, size: 20),
            title: Text('Đăng xuất'),
          ),
        ),
      ],
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final Widget icon;
  final String title;
  final int? pageIndex;
  final VoidCallback? onTap;

  const _DrawerItem({
    required this.icon,
    required this.title,
    this.pageIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selected = pageIndex != null
        ? (context.watch<HomeBloc>().state.mapOrNull(
                page: (value) => value.index == pageIndex,
              ) ??
              false)
        : false;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      hoverColor: Colors.blue.withValues(alpha: .2),
      onTap: () {
        if (pageIndex != null) {
          context.read<HomeBloc>().add(HomeEvent.changePage(pageIndex!, title));
          Navigator.pop(context);
        } else {
          onTap?.call();
        }
      },
      child: ListTile(
        selected: selected,
        selectedColor: const Color(0xFF1976D2),
        leading: icon,
        title: Text(title),
      ),
    );
  }
}
