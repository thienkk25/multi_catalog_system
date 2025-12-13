import 'package:flutter/material.dart';
import 'package:multi_catalog_system/core/core.dart';

class CategoryGroupPage extends StatefulWidget {
  const CategoryGroupPage({super.key});

  @override
  State<CategoryGroupPage> createState() => _CategoryGroupPageState();
}

class _CategoryGroupPageState extends State<CategoryGroupPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomInput(
                hintText: 'Tìm kiếm theo mã, tên...',
                icon: Icon(Icons.search),
              ),
              FilterSearchWidget(),
              Expanded(child: _CategoryGroupListView()),
            ],
          ),
        ),
        CustomFloatingActionButton(onPressedImport: () {}, onPressedAdd: () {}),
      ],
    );
  }
}

class FilterSearchWidget extends StatelessWidget {
  const FilterSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          SizedBox(
            width: 200,
            child: CustomDropdownButton(
              hint: 'Lĩnh vực',
              items: [
                DropdownMenuItem(value: 1, child: Text('Tất cả')),
                DropdownMenuItem(value: 2, child: Text('A')),
                DropdownMenuItem(value: 3, child: Text('B')),
              ],
              onChanged: (value) {},
            ),
          ),
          SizedBox(width: 10),
          SizedBox(
            width: 200,
            child: CustomDropdownButton(
              hint: 'Trạng thái',
              items: [
                DropdownMenuItem(value: 1, child: Text('Tất cả')),
                DropdownMenuItem(value: 2, child: Text('Hoạt động')),
                DropdownMenuItem(value: 3, child: Text('Ngừng hoạt động')),
              ],
              onChanged: (value) {},
            ),
          ),
          SizedBox(width: 10),
          SizedBox(
            width: 200,
            child: CustomDropdownButton(
              hint: 'Sắp xếp',
              items: [
                DropdownMenuItem(value: 1, child: Text('Mới nhất')),
                DropdownMenuItem(value: 2, child: Text('Cũ nhất')),
              ],
              onChanged: (value) {},
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryGroupListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 10,
      separatorBuilder: (context, index) => SizedBox(height: 10),
      itemBuilder: (context, index) {
        return CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mã: CG001',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Tên: Nhóm danh mục A',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 5),
              Text(
                'Lĩnh vực: Lĩnh vực 1',
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: 10,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Row(
                      spacing: 4,
                      children: [
                        Icon(Icons.edit, color: Colors.white, size: 12),
                        Text(
                          'Chỉnh sửa',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Row(
                      spacing: 4,
                      children: [
                        Icon(Icons.delete, color: Colors.white, size: 12),
                        Text(
                          'Xóa',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
