import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multi_catalog_system/core/core.dart';

class DomainPage extends StatefulWidget {
  const DomainPage({super.key});

  @override
  State<DomainPage> createState() => _DomainPageState();
}

class _DomainPageState extends State<DomainPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            spacing: 10,
            children: [
              CustomInput(
                hintText: 'Tìm kiếm lĩnh vực',
                icon: Icon(Icons.search),
              ),
              Expanded(child: _DomainGridView()),
            ],
          ),
        ),
        Positioned(
          right: 20,
          bottom: 50,
          child: FloatingActionButton(onPressed: () {}, child: Icon(Icons.add)),
        ),
      ],
    );
  }
}

class _DomainGridView extends StatelessWidget {
  const _DomainGridView();

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
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/menu-vertical-menu-dots-more-svgrepo-com.svg',
                      width: 20,
                      height: 20,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return _DomainCardMenu();
                        },
                      );
                    },
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
      children: [
        ListTile(
          leading: Icon(Icons.edit),
          title: Text('Chỉnh sửa lĩnh vực'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.delete),
          title: Text('Xóa lĩnh vực'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
