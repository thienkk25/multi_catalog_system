import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/core.dart';

class FilterSearchWidget extends StatelessWidget {
  const FilterSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
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
                lable: Text('Trạng thái'),
                hint: 'Trạng thái',
                value: 'active',
                items: [
                  DropdownMenuItem(value: 'active', child: Text('Hoạt động')),
                  DropdownMenuItem(value: '', child: Text('Ngừng hoạt động')),
                ],
                onChanged: (value) {},
              ),
              SizedBox(height: 16),
              CustomDropdownButton(
                lable: Text('Sắp xếp theo'),
                hint: 'Sắp xếp theo',
                value: 'asc',
                items: [
                  DropdownMenuItem(value: 'asc', child: Text('A-Z')),
                  DropdownMenuItem(value: 'desc', child: Text('Z-A')),
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
      ),
    );
  }
}
