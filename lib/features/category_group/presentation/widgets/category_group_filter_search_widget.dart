import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/core.dart';

class CategoryGroupFilterSearchWidget extends StatelessWidget {
  const CategoryGroupFilterSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  'Bộ lọc tìm kiếm',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    context.pop();
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            CustomDropdownButton(
              lable: Text('Lĩnh vực'),
              hint: 'Lĩnh vực',
              value: '',
              items: [
                DropdownMenuItem(value: '', child: Text('Tất cả')),
                DropdownMenuItem(value: '1', child: Text('Lĩnh vực 1')),
                DropdownMenuItem(value: '2', child: Text('Lĩnh vực 2')),
                DropdownMenuItem(value: '3', child: Text('Lĩnh vực 3')),
              ],
              onChanged: (value) {},
            ),
            SizedBox(height: 16),
            CustomDropdownButton(
              lable: Text('Loại sắp xếp'),
              hint: 'Loại sắp xếp',
              value: 'code',
              items: [
                DropdownMenuItem(value: 'code', child: Text('Mã nhóm')),
                DropdownMenuItem(value: 'name', child: Text('Tên nhóm')),
                DropdownMenuItem(value: 'createdAt', child: Text('Ngày tạo')),
                DropdownMenuItem(
                  value: 'updatedAt',
                  child: Text('Ngày cập nhật'),
                ),
              ],
              onChanged: (value) {},
            ),
            SizedBox(height: 16),
            CustomDropdownButton(
              lable: Text('Sắp xếp theo'),
              hint: 'Sắp xếp theo',
              value: 'asc',
              items: [
                DropdownMenuItem(value: 'asc', child: Text('Tăng dần')),
                DropdownMenuItem(value: 'desc', child: Text('Giảm dần')),
              ],
              onChanged: (value) {},
            ),
            SizedBox(height: 24),
            Row(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: CustomButton(
                    onTap: () {},
                    colorBackground: Colors.grey,
                    textButton: Text(
                      'Xóa bộ lọc',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  child: CustomButton(
                    onTap: () {
                      context.pop();
                    },
                    colorBackground: Colors.blue,
                    textButton: Text(
                      'Áp dụng',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
