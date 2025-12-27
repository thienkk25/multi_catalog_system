import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/domain_management/domain/domain.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/bloc/domain_management_bloc.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/bloc/domain_management_event.dart';

enum DomainFormType { detail, create, update }

class DomainManagementFormPage extends StatefulWidget {
  const DomainManagementFormPage({super.key, required this.type, this.entry});

  final DomainFormType type;
  final DomainEntry? entry;

  @override
  State<DomainManagementFormPage> createState() =>
      _DomainManagementFormPageState();
}

class _DomainManagementFormPageState extends State<DomainManagementFormPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey _bottomBarKey = GlobalKey();
  double _bottomBarHeight = 0;

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _nameController.text = widget.entry!.name;
      _codeController.text = widget.entry!.code;
      _descriptionController.text = widget.entry!.description;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _bottomBarKey.currentContext;
      if (context != null) {
        final height = context.size?.height ?? 0;
        if (height != _bottomBarHeight) {
          setState(() => _bottomBarHeight = height);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.type == DomainFormType.update;
    final isView = widget.type == DomainFormType.detail;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          isView
              ? 'Chi tiết lĩnh vực'
              : isEdit
              ? 'Chỉnh sửa lĩnh vực'
              : 'Thêm lĩnh vực',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(10),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Form(
                        key: _formKey,
                        child: Column(
                          spacing: 20,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomCard(
                              child: Column(
                                spacing: 20,
                                children: [
                                  CustomInput(
                                    controller: _codeController,
                                    enabled: !isView,
                                    lable: _requiredLabel('Mã lĩnh vực'),
                                    hintText: 'Ví dụ: CT-A,...',
                                    validator: (p0) => p0 == null || p0.isEmpty
                                        ? 'Vui lòng nhập mã lĩnh vực'
                                        : null,
                                  ),
                                  CustomInput(
                                    controller: _nameController,
                                    enabled: !isView,
                                    lable: _requiredLabel('Tên lĩnh vực'),
                                    hintText: 'Ví dụ: Chăn nuôi, Môi trường...',
                                    validator: (p0) => p0 == null || p0.isEmpty
                                        ? 'Vui lòng nhập tên lĩnh vực'
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                            CustomCard(
                              child: CustomInput(
                                controller: _descriptionController,
                                enabled: !isView,
                                lable: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Mô tả chi tiết',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'Tùy chọn',
                                      style: TextStyle(color: Colors.grey[500]),
                                    ),
                                  ],
                                ),
                                hintText:
                                    'Nhập mô tả về phạm vi, mục đích liên quan đến lĩnh vực này...',
                                minLines: 5,
                                maxLines: 5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),

                if (!isView)
                  SliverPadding(
                    padding: EdgeInsets.only(bottom: _bottomBarHeight),
                  ),
              ],
            ),

            if (!isView)
              BottomFormActions(
                key: _bottomBarKey,
                onCancel: () => Navigator.pop(context),
                onSave: () => _onSave(context: context, isEdit: isEdit),
              ),
          ],
        ),
      ),
    );
  }

  Widget _requiredLabel(String text) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$text ',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          const TextSpan(
            text: '*',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _onSave({required BuildContext context, required bool isEdit}) {
    if (!_formKey.currentState!.validate()) return;
    if (isEdit) {
      final entry = DomainEntry(
        id: widget.entry!.id,
        code: _codeController.text,
        name: _nameController.text,
        description: _descriptionController.text,
        createdAt: widget.entry!.createdAt,
        updatedAt: DateTime.now(),
      );
      context.read<DomainManagementBloc>().add(
        DomainManagementEvent.update(entry: entry),
      );
    } else {
      final entry = DomainEntry(
        code: _codeController.text,
        name: _nameController.text,
        description: _descriptionController.text,
        createdAt: DateTime.now(),
      );
      context.read<DomainManagementBloc>().add(
        DomainManagementEvent.create(entry: entry),
      );
    }
    Navigator.pop(context);
  }
}
