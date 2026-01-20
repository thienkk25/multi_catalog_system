import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/core/widgets/bottom_form_actions.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/core/widgets/custom_dropdown_button.dart';
import 'package:multi_catalog_system/core/widgets/custom_input.dart';
import 'package:multi_catalog_system/core/widgets/file_icon.dart';
import 'package:multi_catalog_system/features/catalog_lookup/presentation/bloc/catalog_lookup_bloc.dart';
import 'package:multi_catalog_system/features/catalog_lookup/presentation/bloc/catalog_lookup_event.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_entry.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_bloc.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_event.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_state.dart';
import 'package:multi_catalog_system/features/legal_document/domain/entities/legal_document_entry.dart';

class CategoryItemFormPage extends StatefulWidget {
  final CategoryItemEntry? entry;
  const CategoryItemFormPage({super.key, this.entry});

  @override
  State<CategoryItemFormPage> createState() => _CategoryItemFormPageState();
}

class _CategoryItemFormPageState extends State<CategoryItemFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List _domains = [];
  List _categoryGroups = [];
  List<LegalDocumentEntry> _legalDocuments = [];
  String? _selectedDomainId;
  String? _selectedCategoryGroupId;

  final GlobalKey _bottomBarKey = GlobalKey();
  double _bottomBarHeight = 0;

  bool get _isUpdate => widget.entry != null;

  @override
  void initState() {
    super.initState();
    context.read<CatalogLookupBloc>().add(
      const CatalogLookupEvent.getDomainsRef(),
    );
    _domains = context.read<CatalogLookupBloc>().state.domainsRef;
    if (widget.entry != null) {
      _codeController.text = widget.entry!.code!;
      _nameController.text = widget.entry!.name!;
      _descriptionController.text = widget.entry!.description ?? '';
      // _selectedDomainId = widget.entry!.group?.domain.id ?? '';
      _selectedCategoryGroupId = widget.entry!.groupId ?? '';
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
    _formKey.currentState?.dispose();
    _codeController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _bottomBarKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isUpdate ? 'Cập nhật Mục danh mục' : 'Tạo Mục danh mục'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(10.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Form(
                        key: _formKey,
                        child: Column(
                          spacing: 15,
                          children: [_generalInformation(), _legalDocument()],
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
            BlocSelector<CategoryItemBloc, CategoryItemState, bool>(
              selector: (state) => state.isLoading,
              builder: (context, isLoading) => BottomFormActions(
                isLoading: isLoading,
                key: _bottomBarKey,
                onCancel: () => context.pop(),
                onSave: () => _onSave(context: context, isEdit: true),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _generalInformation() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          CustomInput(
            controller: _codeController,
            lable: const Text(
              'Mã Mục danh mục',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            hintText: 'Nhập mã mục danh mục (VD: DM01)',
            validator: (v) =>
                v == null || v.isEmpty ? 'Vui nhập mã danh mục' : null,
          ),
          CustomInput(
            controller: _nameController,
            lable: const Text(
              'Tên Mục danh mục',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            hintText: 'Nhập tên mục danh mục',
            validator: (v) =>
                v == null || v.isEmpty ? 'Vui nhập tên danh mục' : null,
          ),
          CustomDropdownButton<String>(
            lable: const Text(
              'Lĩnh vực',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            hint: 'Chọn lĩnh vực',
            value: _selectedDomainId,
            items: _domains
                .map(
                  (e) => DropdownMenuItem<String>(
                    value: e.id,
                    child: Text(e.name),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                _selectedDomainId = value;
                _selectedCategoryGroupId = null;
              });
              context.read<CatalogLookupBloc>().add(
                CatalogLookupEvent.getCategoryGroupsRef(domainId: value),
              );
              _categoryGroups = context
                  .read<CatalogLookupBloc>()
                  .state
                  .categoryGroupRef;
            },
            validator: (v) =>
                v == null || v.isEmpty ? 'Vui nhập chọn lĩnh vực' : null,
          ),
          CustomDropdownButton<String>(
            lable: const Text(
              'Nhóm danh mục',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            hint: 'Chọn nhóm danh mục',
            value: _selectedCategoryGroupId,
            items: _categoryGroups
                .map(
                  (e) => DropdownMenuItem<String>(
                    value: e.id,
                    child: Text(e.name),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategoryGroupId = value;
              });
            },
            validator: (v) =>
                v == null || v.isEmpty ? 'Vui nhập chọn nhóm danh mục' : null,
          ),
          CustomInput(
            controller: _descriptionController,
            lable: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Mô tả',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text('Tùy chọn', style: TextStyle(color: Colors.grey)),
              ],
            ),
            hintText: 'Nhập mô tả về mục danh mục này...',
            minLines: 5,
            maxLines: 5,
          ),
        ],
      ),
    );
  }

  Widget _legalDocument() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Văn bản pháp lý liên quan',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              IconButton(
                onPressed: () async {
                  final result =
                      await context.pushNamed(
                            RouterNames.categoryItemAddLegalDocuments,
                          )
                          as List<LegalDocumentEntry>?;
                  if (result == null) return;

                  setState(() {
                    _legalDocuments = result;
                  });
                },
                icon: Icon(Icons.add),
              ),
            ],
          ),
          _legalDocuments.isNotEmpty
              ? ListView.separated(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _legalDocuments.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final entry = _legalDocuments[index];
                    return Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: .15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.blue.withValues(alpha: .5),
                        ),
                      ),
                      child: Row(
                        spacing: 8,
                        children: [
                          FileIcon(fileName: entry.fileName!),
                          Expanded(
                            child: Text(
                              entry.fileName!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _legalDocuments.removeAt(index);
                              });
                            },
                            icon: Icon(Icons.close),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  void _onSave({required BuildContext context, required bool isEdit}) {
    if (!_formKey.currentState!.validate()) return;
    if (_isUpdate) {
      final entry = CategoryItemEntry(
        id: widget.entry!.id,
        name: widget.entry?.name != _nameController.text
            ? _nameController.text
            : widget.entry?.name,
        code: widget.entry?.code != _codeController.text
            ? _codeController.text
            : widget.entry?.code,
        description: widget.entry?.description != _descriptionController.text
            ? _descriptionController.text
            : widget.entry?.description,
        status: 'active',
        groupId: _selectedCategoryGroupId,
      );
      context.read<CategoryItemBloc>().add(
        CategoryItemEvent.update(entry: entry),
      );
    } else {
      final entry = CategoryItemEntry(
        name: _nameController.text,
        code: _codeController.text,
        description: _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : null,
        status: 'active',
        groupId: _selectedCategoryGroupId,
      );
      context.read<CategoryItemBloc>().add(
        CategoryItemEvent.create(entry: entry),
      );
    }
    context.pop();
  }
}
