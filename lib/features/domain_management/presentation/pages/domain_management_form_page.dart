import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/domain_management/domain/domain.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/bloc/domain_management_bloc.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/bloc/domain_management_event.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/bloc/domain_management_state.dart';

enum DomainManagementFormType { create, update }

class DomainManagementFormPage extends StatefulWidget {
  final DomainManagementFormType mode;
  final String? id;
  const DomainManagementFormPage({super.key, required this.mode, this.id});

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
  DomainEntry? _entry;

  bool get _isUpdate => widget.mode == DomainManagementFormType.update;

  bool _didInit = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    switch (widget.mode) {
      case DomainManagementFormType.create:
        break;
      case DomainManagementFormType.update:
        context.domainManagementBloc.add(
          DomainManagementEvent.getById(id: widget.id!),
        );
        break;
    }
  }

  void _initFromData(DomainEntry entry) {
    if (_didInit) return;
    _entry = entry;
    _nameController.text = entry.name!;
    _codeController.text = entry.code!;
    _descriptionController.text = entry.description ?? '';

    _didInit = true;
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
    return BlocConsumer<DomainManagementBloc, DomainManagementState>(
      listenWhen: (previous, current) =>
          previous.entry?.id != current.entry?.id && current.entry != null,
      listener: (context, state) {
        final entry = state.entry;
        if (entry != null) {
          _initFromData(entry);
        }
      },
      buildWhen: (previous, current) =>
          previous.entry?.id != current.entry?.id && current.entry != null,
      builder: (context, state) => SafeArea(
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

                SliverPadding(
                  padding: EdgeInsets.only(bottom: _bottomBarHeight),
                ),
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
        id: _entry!.id,
        code: _entry?.code != _codeController.text
            ? _codeController.text
            : _entry?.code,
        name: _entry?.name != _nameController.text
            ? _nameController.text
            : _entry?.name,
        description: _entry?.description != _descriptionController.text
            ? _descriptionController.text
            : _entry?.description,
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
