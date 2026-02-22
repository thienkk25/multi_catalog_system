import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/category_group/presentation/bloc/category_group_event.dart';

class CategoryGroupFilterSearchWidget extends StatefulWidget {
  final String? search;
  final Map<String, dynamic> filter;
  const CategoryGroupFilterSearchWidget({
    super.key,
    this.search,
    required this.filter,
  });

  @override
  State<CategoryGroupFilterSearchWidget> createState() =>
      _CategoryGroupFilterSearchWidgetState();
}

class _CategoryGroupFilterSearchWidgetState
    extends State<CategoryGroupFilterSearchWidget> {
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
              hint: '---',
              value: widget.filter['domain_id'],
              items: [
                DropdownMenuItem(value: null, child: Text('Tất cả')),
                DropdownMenuItem(
                  value: 'ef1ce0b7-7b2f-48f3-a628-b2a1e8e4d15b',
                  child: Text('Lĩnh vực 1'),
                ),
                DropdownMenuItem(value: '2', child: Text('Lĩnh vực 2')),
                DropdownMenuItem(value: '3', child: Text('Lĩnh vực 3')),
              ],
              onChanged: (value) {
                setState(() {
                  widget.filter['domain_id'] = value;
                });
              },
            ),
            SizedBox(height: 16),
            CustomDropdownButton(
              lable: Text('Loại sắp xếp'),
              hint: '---',
              items: [
                DropdownMenuItem(value: 'code', child: Text('Mã nhóm')),
                DropdownMenuItem(value: 'name', child: Text('Tên nhóm')),
                DropdownMenuItem(value: 'created_at', child: Text('Ngày tạo')),
                DropdownMenuItem(
                  value: 'updated_at',
                  child: Text('Ngày cập nhật'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  widget.filter['sortBy'] = value;
                });
              },
            ),
            SizedBox(height: 16),
            CustomDropdownButton(
              lable: Text('Sắp xếp theo'),
              hint: '---',
              items: [
                DropdownMenuItem(value: 'asc', child: Text('Tăng dần')),
                DropdownMenuItem(value: 'desc', child: Text('Giảm dần')),
              ],
              onChanged: (value) {
                setState(() {
                  widget.filter['sort'] = value;
                });
              },
            ),
            SizedBox(height: 24),
            Row(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: CustomButton(
                    onTap: () {
                      widget.filter.clear();
                      context.pop();
                      context.groupBloc.add(
                        CategoryGroupEvent.getAll(
                          search: widget.search,
                          filter: widget.filter,
                        ),
                      );
                    },
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
                      context.groupBloc.add(
                        CategoryGroupEvent.getAll(
                          search: widget.search,
                          filter: widget.filter,
                        ),
                      );
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
