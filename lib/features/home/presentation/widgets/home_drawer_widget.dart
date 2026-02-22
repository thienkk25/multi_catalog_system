import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/utils/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/responsive/screen_size.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/core/widgets/custom_button.dart';
import 'package:multi_catalog_system/core/widgets/role_based_widget.dart';
import 'package:multi_catalog_system/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:multi_catalog_system/features/auth/presentation/bloc/auth_event.dart';
import 'package:multi_catalog_system/features/auth/presentation/bloc/auth_state.dart';

class HomeDrawerWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int index) onSelectTab;
  final double? drawerWidth;
  const HomeDrawerWidget({
    super.key,
    this.drawerWidth,
    required this.onSelectTab,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final drawerWidth = this.drawerWidth ?? 250;
    return Drawer(
      width: drawerWidth,
      backgroundColor: Color(0xFFF5F7FA),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              _HeaderDrawer(drawerWidth: drawerWidth),
              Divider(),
              _MainDrawer(currentIndex: currentIndex, onSelectTab: onSelectTab),
              _FooterDrawer(
                currentIndex: currentIndex,
                onSelectTab: onSelectTab,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderDrawer extends StatelessWidget {
  final double drawerWidth;
  const _HeaderDrawer({required this.drawerWidth});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final sizeW = drawerWidth - 20;

        return state.maybeWhen(
          authenticated: (user) => Row(
            children: [
              CircleAvatar(radius: 30, child: const Icon(Icons.person)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName ?? 'Chưa cập nhật',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text('Email: ${user.email}'),
                  ],
                ),
              ),
            ],
          ),
          orElse: () => SizedBox(
            width: sizeW,
            child: CustomButton(
              onTap: () {
                context.goNamed(RouterNames.login);
              },
              colorBackground: Colors.blue,
              textButton: const Text(
                'Đăng nhập',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MainDrawer extends StatelessWidget {
  final int currentIndex;
  final Function(int index) onSelectTab;
  const _MainDrawer({required this.onSelectTab, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      key: ValueKey('drawer'),
      child: SingleChildScrollView(
        child: Column(
          spacing: 10,
          children: [
            _DrawerItem(
              icon: SvgPicture.asset(
                'assets/icons/folder-favourites-svgrepo-com.svg',
                height: 20,
              ),
              title: 'Lĩnh vực',
              pageIndex: 0,
              onSelectTab: onSelectTab,
              selected: currentIndex == 0,
            ),
            _DrawerItem(
              icon: SvgPicture.asset(
                'assets/icons/folder-document-svgrepo-com.svg',
                height: 20,
              ),
              title: 'Nhóm danh mục',
              pageIndex: 1,
              onSelectTab: onSelectTab,
              selected: currentIndex == 1,
            ),
            _DrawerItem(
              icon: SvgPicture.asset(
                'assets/icons/document-text-svgrepo-com.svg',
                height: 20,
              ),
              title: 'Mục danh mục',
              pageIndex: 2,
              onSelectTab: onSelectTab,
              selected: currentIndex == 2,
            ),
            _DrawerItem(
              icon: SvgPicture.asset(
                'assets/icons/legal-hammer-symbol-svgrepo-com.svg',
                height: 20,
              ),
              title: 'Văn bản pháp lý',
              pageIndex: 3,
              onSelectTab: onSelectTab,
              selected: currentIndex == 3,
            ),

            RoleBasedWidget(
              permission: ['admin', 'domainOfficer'],
              child: _DrawerItem(
                icon: SvgPicture.asset(
                  'assets/icons/import-svgrepo-com.svg',
                  height: 20,
                ),
                title: 'Nhập dữ liệu File',
                pageIndex: 4,
                onSelectTab: onSelectTab,
                selected: currentIndex == 4,
              ),
            ),
            RoleBasedWidget(
              permission: ['approver', 'domainOfficer'],
              child: _DrawerItem(
                icon: SvgPicture.asset(
                  'assets/icons/approve-invoice-svgrepo-com.svg',
                  height: 20,
                ),
                title: 'Duyệt danh sách danh mục',
                pageIndex: 5,
                selected: currentIndex == 5,
                onSelectTab: onSelectTab,
              ),
            ),
            RoleBasedWidget(
              permission: ['admin'],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 10,
                children: [
                  _DrawerItem(
                    icon: SvgPicture.asset(
                      'assets/icons/group-svgrepo-com.svg',
                      height: 20,
                    ),
                    title: 'Quản lý người dùng',
                    pageIndex: 6,
                    onSelectTab: onSelectTab,
                    selected: currentIndex == 6,
                  ),
                  _DrawerItem(
                    icon: SvgPicture.asset(
                      'assets/icons/key-svgrepo-com.svg',
                      height: 20,
                    ),
                    title: 'API Key',
                    pageIndex: 7,
                    onSelectTab: onSelectTab,
                    selected: currentIndex == 7,
                  ),
                  _DrawerItem(
                    icon: SvgPicture.asset(
                      'assets/icons/history-svgrepo-com.svg',
                      height: 20,
                    ),
                    title: 'Nhật kí hệ thống',
                    pageIndex: 8,
                    onSelectTab: onSelectTab,
                    selected: currentIndex == 8,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterDrawer extends StatelessWidget {
  final int currentIndex;
  final Function(int index) onSelectTab;
  const _FooterDrawer({required this.currentIndex, required this.onSelectTab});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return state.maybeMap(
          orElse: () => SizedBox.shrink(),
          authenticated: (value) {
            return Column(
              spacing: 5,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  hoverColor: Colors.blue.withValues(alpha: .2),
                  onTap: () {
                    if (ScreenSize.of(context).isMobile) {
                      context.pop();
                    }
                    onSelectTab(9);
                  },
                  child: ListTile(
                    selected: currentIndex == 9,
                    selectedColor: const Color(0xFF1976D2),
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
                  onTap: () {
                    context.notificationCubit.success('Đăng xuất thành công');
                    context.authBloc.add(const AuthEvent.logout());
                  },
                  child: ListTile(
                    leading: Icon(Icons.exit_to_app_outlined, size: 20),
                    title: Text('Đăng xuất'),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final Widget icon;
  final String title;
  final int? pageIndex;
  final Function(int index)? onSelectTab;
  final bool selected;

  const _DrawerItem({
    required this.icon,
    required this.title,
    this.pageIndex,
    this.onSelectTab,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      hoverColor: Colors.blue.withValues(alpha: .2),
      onTap: () {
        if (ScreenSize.of(context).isMobile) {
          context.pop();
        }
        onSelectTab?.call(pageIndex ?? 0);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: selected
              ? Colors.blue.withValues(alpha: .2)
              : Colors.transparent,
        ),
        child: ListTile(
          selected: selected,
          selectedColor: const Color(0xFF1976D2),
          leading: icon,
          title: Text(title),
        ),
      ),
    );
  }
}
