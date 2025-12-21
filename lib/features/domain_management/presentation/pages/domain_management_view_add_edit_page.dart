import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/domain_management/domain/domain.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/bloc/domain_management_bloc.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/bloc/domain_management_event.dart';

enum Type { add, edit, view }

class DomainManagementViewAddEditPage extends StatefulWidget {
  const DomainManagementViewAddEditPage({
    super.key,
    required this.type,
    this.entry,
  });
  final Type type;
  final DomainEntry? entry;

  @override
  State<DomainManagementViewAddEditPage> createState() =>
      _DomainManagementViewAddEditPageState();
}

class _DomainManagementViewAddEditPageState
    extends State<DomainManagementViewAddEditPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      nameController.text = widget.entry!.name;
      codeController.text = widget.entry!.code;
      descriptionController.text = widget.entry!.description;
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    codeController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.type == Type.edit;
    final isView = widget.type == Type.view;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isView
              ? 'Chi tiết lĩnh vực'
              : isEdit
              ? 'Chỉnh sửa lĩnh vực'
              : 'Thêm lĩnh vực',
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
                controller: codeController,
                enabled: isView ? false : true,
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
                controller: nameController,
                enabled: isView ? false : true,
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
                controller: descriptionController,
                enabled: isView ? false : true,
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
              if (!isView)
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
                        onTap: () {
                          if (isEdit) {
                            final entry = DomainEntry(
                              code: codeController.text,
                              name: nameController.text,
                              description: descriptionController.text,
                              id: widget.entry!.id,
                              createdAt: widget.entry!.createdAt,
                              updatedAt: DateTime.now(),
                            );
                            context.read<DomainManagementBloc>().add(
                              DomainManagementEvent.update(entry: entry),
                            );
                          } else {
                            final entry = DomainEntry(
                              code: codeController.text,
                              name: nameController.text,
                              description: descriptionController.text,
                              createdAt: DateTime.now(),
                            );
                            context.read<DomainManagementBloc>().add(
                              DomainManagementEvent.create(entry: entry),
                            );
                          }
                          Navigator.pop(context);
                        },
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
