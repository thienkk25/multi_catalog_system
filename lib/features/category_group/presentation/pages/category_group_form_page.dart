import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/catalog_lookup/domain/entities/domain_ref_entry.dart';
import 'package:multi_catalog_system/features/catalog_lookup/presentation/presentation.dart';
import 'package:multi_catalog_system/features/category_group/domain/domain.dart';
import 'package:multi_catalog_system/features/category_group/presentation/bloc/category_group_bloc.dart';
import 'package:multi_catalog_system/features/category_group/presentation/bloc/category_group_event.dart';

enum CategoryGroupFormType { detail, create, update }

class CategoryGroupFormPage extends StatefulWidget {
  final CategoryGroupFormType type;
  final CategoryGroupEntry? entry;
  const CategoryGroupFormPage({super.key, required this.type, this.entry});

  @override
  State<CategoryGroupFormPage> createState() => _CategoryGroupFormPageState();
}

class _CategoryGroupFormPageState extends State<CategoryGroupFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedDomainId;
  final GlobalKey _bottomBarKey = GlobalKey();
  double _bottomBarHeight = 0;

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _codeController.text = widget.entry!.code;
      _nameController.text = widget.entry!.name;
      _descriptionController.text = widget.entry!.description;
      _selectedDomainId = widget.entry!.domainId;
    }
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
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.type == CategoryGroupFormType.update;
    final isView = widget.type == CategoryGroupFormType.detail;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          isView
              ? 'Chi tiết nhóm danh mục'
              : isEdit
              ? 'Chỉnh sửa nhóm danh mục'
              : 'Thêm nhóm danh mục',
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
                                    enabled: isView ? false : true,
                                    controller: _codeController,
                                    lable: _requiredLabel('Mã Nhóm danh mục'),
                                    hintText: 'Nhập mã nhóm danh mục',
                                    validator: (p0) => p0 == null || p0.isEmpty
                                        ? 'Vui lòng nhập mã nhóm danh mục'
                                        : null,
                                  ),
                                  CustomInput(
                                    enabled: isView ? false : true,
                                    controller: _nameController,
                                    lable: _requiredLabel('Tên Nhóm danh mục'),
                                    hintText: 'Nhập tên nhóm danh mục',
                                    validator: (p0) => p0 == null || p0.isEmpty
                                        ? 'Vui lòng nhập tên nhóm danh mục'
                                        : null,
                                  ),
                                  BlocSelector<
                                    CatalogLookupBloc,
                                    CatalogLookupState,
                                    List<DomainRefEntry>
                                  >(
                                    selector: (state) => state.domainsRef,
                                    builder: (context, domains) {
                                      return CustomDropdownButton<String>(
                                        lable: const Text(
                                          'Lĩnh vực',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        hint: 'Chọn lĩnh vực',
                                        value: _selectedDomainId,
                                        items: domains
                                            .map(
                                              (e) => DropdownMenuItem<String>(
                                                value: e.id,
                                                child: Text(e.name),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: isView
                                            ? null
                                            : (value) {
                                                if (value == null) return;

                                                setState(() {
                                                  _selectedDomainId = value;
                                                });
                                              },
                                        validator: (p0) =>
                                            p0 == null || p0.isEmpty
                                            ? 'Vui lòng chọn lĩnh vực'
                                            : null,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            CustomCard(
                              child: CustomInput(
                                enabled: isView ? false : true,
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
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                hintText:
                                    'Nhập mô tả chi tiết về nhóm danh mục này...',
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
      final entry = CategoryGroupEntry(
        id: widget.entry!.id,
        domainId: widget.entry!.domainId,
        code: _codeController.text,
        name: _nameController.text,
        description: _descriptionController.text,
        createdAt: widget.entry!.createdAt,
        updatedAt: DateTime.now(),
      );
      context.read<CategoryGroupBloc>().add(
        CategoryGroupEvent.update(entry: entry),
      );
    } else {
      final domainId = _selectedDomainId;
      if (domainId == null) return;

      final code = _codeController.text;
      final name = _nameController.text;
      final description = _descriptionController.text;

      final entry = CategoryGroupEntry(
        domainId: domainId,
        code: code,
        name: name,
        description: description,
        createdAt: DateTime.now(),
      );

      context.read<CategoryGroupBloc>().add(
        CategoryGroupEvent.create(entry: entry),
      );
    }
    Navigator.pop(context);
  }
}
