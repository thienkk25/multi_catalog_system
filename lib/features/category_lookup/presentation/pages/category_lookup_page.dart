import 'package:flutter/material.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/category_lookup/presentation/widgets/infor_card_widget.dart';

class CategoryLookupPage extends StatefulWidget {
  const CategoryLookupPage({super.key});

  @override
  State<CategoryLookupPage> createState() => _CategoryLookupPageState();
}

class _CategoryLookupPageState extends State<CategoryLookupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Form(
              key: _formKey,
              child: CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Text(
                      'Bộ lọc tìm kiếm',
                      style: TextStyle(
                        fontWeight: FontWeight(600),
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Sử dụng các bộ lọc bên dưới để tìm kiếm.',
                      style: TextStyle(color: Colors.grey),
                    ),
                    CustomInput(
                      hintText: 'Nhập mã hoặc tên danh mục...',
                      lable: Text(
                        'Tìm kiếm',
                        style: TextStyle(fontWeight: FontWeight(600)),
                      ),
                      suffixIcon: Icon(Icons.search),
                      validator: (v) => v == null || v.isEmpty
                          ? 'Vui lòng nhập dữ liệu cần tìm'
                          : null,
                    ),
                    CustomDropdownButton(
                      lable: Text(
                        'Lĩnh vực',
                        style: TextStyle(fontWeight: FontWeight(600)),
                      ),
                      items: [
                        DropdownMenuItem(value: 1, child: Text('1')),
                        DropdownMenuItem(value: 2, child: Text('2')),
                        DropdownMenuItem(value: 3, child: Text('3')),
                      ],
                      hint: 'Chọn Nhóm danh mục',
                      onChanged: (value) {},
                    ),
                    CustomDropdownButton(
                      lable: Text(
                        'Nhóm danh mục',
                        style: TextStyle(fontWeight: FontWeight(600)),
                      ),
                      items: [
                        DropdownMenuItem(value: 1, child: Text('1')),
                        DropdownMenuItem(value: 2, child: Text('2')),
                        DropdownMenuItem(value: 3, child: Text('3')),
                      ],
                      hint: 'Chọn Nhóm danh mục',
                      onChanged: (value) {},
                    ),
                    SizedBox(height: 5),
                    CustomButton(
                      colorBackground: Colors.blue,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {}
                      },
                      textButton: Text(
                        'Tìm kiếm',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              'Kết quả tìm kiếm',
              style: TextStyle(fontWeight: FontWeight(600), fontSize: 16),
            ),

            InforCardWidget(
              dateTime: DateTime.now(),
              title: 'Lệ phí cấp giấy phép hoạt động điện lực',
              subDomain: 'Trồng trọt',
              subGroup: 'Cây trồng',
              subDocument: 'Thông tư 15/2025',
            ),
            InforCardWidget(
              dateTime: DateTime.now(),
              title: 'Lệ phí cấp giấy phép hoạt động điện lực',
              subDomain: 'Trồng trọt',
              subGroup: 'Cây trồng',
              subDocument: 'Thông tư 15/2025',
            ),
            InforCardWidget(
              dateTime: DateTime.now(),
              title: 'Lệ phí cấp giấy phép hoạt động điện lực',
              subDomain: 'Trồng trọt',
              subGroup: 'Cây trồng',
              subDocument: 'Thông tư 15/2025',
            ),
          ],
        ),
      ),
    );
  }
}
