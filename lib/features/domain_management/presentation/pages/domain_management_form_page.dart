import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/domain_management/domain/domain.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/bloc/domain_management_bloc.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/bloc/domain_management_event.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/bloc/domain_management_state.dart';

class DomainManagementFormPage extends StatefulWidget {
  const DomainManagementFormPage({super.key, this.entry});

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

  bool get _isUpdate => widget.entry != null;

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _nameController.text = widget.entry!.name!;
      _codeController.text = widget.entry!.code!;
      _descriptionController.text = widget.entry!.description ?? '';
    }
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _nameController.dispose();
    _codeController.dispose();
    _descriptionController.dispose();
    _bottomBarKey.currentState?.dispose();
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
    return SafeArea(
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(10),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Text(
                      _isUpdate ? 'Chỉnh sửa lĩnh vực' : 'Thêm lĩnh vực',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
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
                                  lable: _requiredLabel('Mã lĩnh vực'),
                                  hintText: 'Ví dụ: CT-A,...',
                                  validator: (p0) => p0 == null || p0.isEmpty
                                      ? 'Vui lòng nhập mã lĩnh vực'
                                      : null,
                                ),
                                CustomInput(
                                  controller: _nameController,
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

              SliverPadding(padding: EdgeInsets.only(bottom: _bottomBarHeight)),
            ],
          ),

          BlocSelector<DomainManagementBloc, DomainManagementState, bool>(
            selector: (state) => state.isLoading,
            builder: (context, isLoading) => BottomFormActions(
              isLoading: isLoading,
              key: _bottomBarKey,
              onCancel: () => context.pop(),
              onSave: () => _onSave(context: context),
            ),
          ),
        ],
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

  void _onSave({required BuildContext context}) {
    if (!_formKey.currentState!.validate()) return;
    if (_isUpdate) {
      final entry = DomainEntry(
        id: widget.entry!.id,
        code: widget.entry?.code != _codeController.text
            ? _codeController.text
            : widget.entry?.code,
        name: widget.entry?.name != _nameController.text
            ? _nameController.text
            : widget.entry?.name,
        description: widget.entry?.description != _descriptionController.text
            ? _descriptionController.text
            : widget.entry?.description,
      );
      context.domainManagementBloc.add(
        DomainManagementEvent.update(entry: entry),
      );
    } else {
      final entry = DomainEntry(
        code: _codeController.text,
        name: _nameController.text,
        description: _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : null,
      );
      context.domainManagementBloc.add(
        DomainManagementEvent.create(entry: entry),
      );
    }
    context.pop();
  }
}
