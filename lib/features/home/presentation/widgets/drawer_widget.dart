import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        CircleAvatar(radius: 30),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nguyễn Văn A',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight(600)),
            ),
            Text('Email: admin@gmail.com'),
          ],
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
            InkWell(
              borderRadius: BorderRadius.circular(10),
              hoverColor: Colors.blue.withValues(alpha: .2),
              onTap: () {},
              child: ListTile(
                leading: Icon(Icons.search, size: 20),
                title: Text('Tra cứu danh mục'),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              hoverColor: Colors.blue.withValues(alpha: .2),
              onTap: () {},
              child: ListTile(
                leading: SvgPicture.asset(
                  'assets/icons/folder-favourites-svgrepo-com.svg',
                  height: 20,
                  width: 20,
                  fit: BoxFit.contain,
                ),
                title: Text('Lĩnh vực'),
              ),
            ),

            InkWell(
              borderRadius: BorderRadius.circular(10),
              hoverColor: Colors.blue.withValues(alpha: .2),
              onTap: () {},
              child: ListTile(
                leading: SvgPicture.asset(
                  'assets/icons/folder-document-svgrepo-com.svg',
                  height: 20,
                  width: 20,
                  fit: BoxFit.contain,
                ),
                title: Text('Nhóm danh mục'),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              hoverColor: Colors.blue.withValues(alpha: .2),
              onTap: () {},
              child: ListTile(
                leading: SvgPicture.asset(
                  'assets/icons/document-text-svgrepo-com.svg',
                  height: 20,
                  width: 20,
                  fit: BoxFit.contain,
                ),
                title: Text('Mục danh mục'),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              hoverColor: Colors.blue.withValues(alpha: .2),
              onTap: () {},
              child: ListTile(
                leading: SvgPicture.asset(
                  'assets/icons/legal-hammer-symbol-svgrepo-com.svg',
                  height: 20,
                  width: 20,
                  fit: BoxFit.contain,
                ),
                title: Text('Văn bản pháp lý'),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              hoverColor: Colors.blue.withValues(alpha: .2),
              onTap: () {},
              child: ListTile(
                leading: SvgPicture.asset(
                  'assets/icons/approve-invoice-svgrepo-com.svg',
                  height: 20,
                  width: 20,
                  fit: BoxFit.contain,
                ),
                title: Text('Danh sách chờ duyệt'),
              ),
            ),

            Divider(),

            InkWell(
              borderRadius: BorderRadius.circular(10),
              hoverColor: Colors.blue.withValues(alpha: .2),
              onTap: () {},
              child: ListTile(
                leading: SvgPicture.asset(
                  'assets/icons/import-svgrepo-com.svg',
                  height: 20,
                  width: 20,
                  fit: BoxFit.contain,
                ),
                title: Text('Nhập dữ liệu File'),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              hoverColor: Colors.blue.withValues(alpha: .2),
              onTap: () {},
              child: ListTile(
                leading: SvgPicture.asset(
                  'assets/icons/group-svgrepo-com.svg',
                  height: 20,
                  width: 20,
                  fit: BoxFit.contain,
                ),
                title: Text('Quản lý người dùng'),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              hoverColor: Colors.blue.withValues(alpha: .2),
              onTap: () {},
              child: ListTile(
                leading: SvgPicture.asset(
                  'assets/icons/key-svgrepo-com.svg',
                  height: 20,
                  width: 20,
                  fit: BoxFit.contain,
                ),
                title: Text('API Key'),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              hoverColor: Colors.blue.withValues(alpha: .2),
              onTap: () {},
              child: ListTile(
                leading: SvgPicture.asset(
                  'assets/icons/history-svgrepo-com.svg',
                  height: 20,
                  width: 20,
                  fit: BoxFit.contain,
                ),
                title: Text('Nhật kí hệ thống'),
              ),
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
