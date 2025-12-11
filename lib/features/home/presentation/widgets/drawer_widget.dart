import 'package:flutter/material.dart';

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
            children: [
              Row(
                spacing: 10,
                children: [
                  CircleAvatar(radius: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nguyễn Văn A',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight(600),
                        ),
                      ),
                      Text('Email: admin@gmail.com'),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Divider(),
                      ListTile(title: Text('Tra cứu danh mục')),
                      ListTile(title: Text('Tra cứu danh mục')),
                      ListTile(title: Text('Tra cứu danh mục')),
                      ListTile(title: Text('Tra cứu danh mục')),

                      Divider(),
                      ListTile(title: Text('Quản lý lĩnh vực')),
                      ListTile(title: Text('Quản lý lĩnh vực')),
                      ListTile(title: Text('Quản lý lĩnh vực')),
                      ListTile(title: Text('Quản lý lĩnh vực')),
                    ],
                  ),
                ),
              ),
              ListTile(title: Text('Đăng xuất')),
            ],
          ),
        ),
      ),
    );
  }
}
