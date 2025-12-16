import 'package:flutter/material.dart';
import 'package:multi_catalog_system/core/core.dart';

class DomainManagementAddEditPage extends StatelessWidget {
  const DomainManagementAddEditPage({super.key, required this.isEdit});
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Chỉnh sửa lĩnh vực' : 'Thêm lĩnh vực',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            spacing: 20,
            children: [
              CustomInput(
                lable: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Mã lĩnh vực ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight(600),
                        ),
                      ),
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          fontWeight: FontWeight(600),
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                hintText: 'Ví dụ: CT-A,...',
              ),
              CustomInput(
                lable: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Tên lĩnh vực ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight(600),
                        ),
                      ),
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          fontWeight: FontWeight(600),
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                hintText: 'Ví dụ: Chăn nuôi, Môi trường...',
              ),
              CustomInput(
                lable: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Mô tả chi tiết',
                      style: TextStyle(fontWeight: FontWeight(600)),
                    ),
                    Text('Tùy chọn', style: TextStyle(color: Colors.grey[500])),
                  ],
                ),
                hintText:
                    'Nhập mô tả về phạm vi, mục đích về các thông tin liên quan đến lĩnh vực này...',
                minLines: 5,
                maxLines: 5,
              ),
              Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 20,
                children: [
                  Expanded(
                    child: CustomButton(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      colorBackground: Colors.white,
                      colorBorder: Colors.blue.withValues(alpha: .5),
                      textButton: Text(
                        'Hủy',
                        style: TextStyle(fontWeight: FontWeight(600)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: CustomButton(
                      onTap: () {},
                      colorBackground: Colors.blue,
                      textButton: Row(
                        spacing: 5,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.save, size: 20, color: Colors.white),
                          Text(
                            'Lưu Lĩnh vực',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight(600),
                            ),
                          ),
                        ],
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
