import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:multi_catalog_system/core/core.dart';

class DomainManagementGridView extends StatelessWidget {
  const DomainManagementGridView({super.key});

  @override
  Widget build(BuildContext context) {
    screenWidth(BuildContext context) {
      return MediaQuery.of(context).size.width;
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: screenWidth(context) < 600 ? 2 : 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2,
      ),
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Chi tiết lĩnh vực ${index + 1}'),
                  content: Text('Đây là chi tiết về lĩnh vực ${index + 1}.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Đóng'),
                    ),
                  ],
                );
              },
            );
          },
          child: CustomCard(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5,
                  children: [
                    Text(
                      'Mã: ${index + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Lĩnh vực ${index + 1}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Mô tả ngắn về lĩnh vực ${index + 1}',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: PopupMenuButton(
                    icon: SvgPicture.asset(
                      'assets/icons/menu-vertical-menu-dots-more-svgrepo-com.svg',
                      width: 20,
                      height: 20,
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(child: _DomainCardMenu()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DomainCardMenu extends StatelessWidget {
  const _DomainCardMenu();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 5,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(10),

          onTap: () {},
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
          onTap: () {},
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
