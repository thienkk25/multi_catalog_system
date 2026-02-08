import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/core/utils/extensions/auth_permission_extension.dart';
import 'package:multi_catalog_system/core/widgets/bottom_form_actions.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/core/widgets/custom_dropdown_button.dart';
import 'package:multi_catalog_system/core/widgets/custom_input.dart';
import 'package:multi_catalog_system/core/widgets/file_icon_widget.dart';
import 'package:multi_catalog_system/features/catalog_lookup/presentation/bloc/catalog_lookup_bloc.dart';
import 'package:multi_catalog_system/features/catalog_lookup/presentation/bloc/catalog_lookup_event.dart';
import 'package:multi_catalog_system/features/catalog_lookup/presentation/bloc/catalog_lookup_state.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_group_ref_entry.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_entry.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_bloc.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_event.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_state.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_bloc.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_event.dart';
import 'package:multi_catalog_system/features/legal_document/domain/entities/legal_document_entry.dart';

class CategoryItemFormPage extends StatefulWidget {
  const CategoryItemFormPage({super.key});

  @override
  State<CategoryItemFormPage> createState() => _CategoryItemFormPageState();
}

class _CategoryItemFormPageState extends State<CategoryItemFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<LegalDocumentEntry> _legalDocuments = [];
  String? _selectedDomainId;
  String? _selectedCategoryGroupId;

  final GlobalKey _bottomBarKey = GlobalKey();
  double _bottomBarHeight = 0;

  bool _didInit = false;

  CategoryItemEntry? _entry;

  bool get _isUpdate => _entry != null;
  bool get _isAdmin => context.hasRole('admin');

  @override
  void initState() {
    super.initState();
    context.read<CatalogLookupBloc>().add(
      const CatalogLookupEvent.getDomainsRef(),
    );
  }

  void _initFromEntry(CategoryItemEntry entry) {
    if (_didInit) return;

    _entry = entry;

    _codeController.text = entry.code ?? '';
    _nameController.text = entry.name ?? '';
    _descriptionController.text = entry.description ?? '';
    _selectedDomainId = entry.group?.domain?.id ?? '';
    if (_selectedDomainId != null) {
      context.read<CatalogLookupBloc>().add(
        CatalogLookupEvent.getCategoryGroupsRef(domainId: _selectedDomainId!),
      );
    }
    _selectedCategoryGroupId = entry.group?.id ?? '';
    _legalDocuments = entry.legalDocuments ?? [];

    _didInit = true;
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
    return BlocListener<CategoryItemBloc, CategoryItemState>(
      listenWhen: (previous, current) => current.entries.isNotEmpty,
      listener: (context, state) {
        if (state.entries.isNotEmpty) {
          _initFromEntry(state.entries.first);
        }
      },
      child: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(10.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Text(
                        _isUpdate
                            ? 'Cập nhật Mục danh mục'
                            : 'Tạo Mục danh mục',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 10),
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
          BlocBuilder<CatalogLookupBloc, CatalogLookupState>(
            builder: (context, state) {
              final domains = state.domainsRef;

              return CustomDropdownButton<String>(
                lable: const Text(
                  'Lĩnh vực',
                  style: TextStyle(fontWeight: FontWeight.w600),
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

                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    _selectedDomainId = value;
                    _selectedCategoryGroupId = null;
                  });

                  context.read<CatalogLookupBloc>().add(
                    CatalogLookupEvent.getCategoryGroupsRef(domainId: value),
                  );
                },
                validator: (v) =>
                    v == null || v.isEmpty ? 'Vui lòng chọn lĩnh vực' : null,
              );
            },
          ),
          BlocBuilder<CatalogLookupBloc, CatalogLookupState>(
            buildWhen: (prev, curr) =>
                prev.categoryGroupRef != curr.categoryGroupRef,
            builder: (context, state) {
              final categoryGroups = state.categoryGroupRef;

              return CustomDropdownButton<String>(
                lable: const Text(
                  'Nhóm danh mục',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                hint: 'Chọn nhóm danh mục',
                value: _selectedCategoryGroupId,
                items: categoryGroups
                    .map(
                      (e) => DropdownMenuItem<String>(
                        value: e.id,
                        child: Text(e.name),
                      ),
                    )
                    .toList(),
                onChanged: categoryGroups.isEmpty
                    ? null
                    : (value) {
                        setState(() {
                          _selectedCategoryGroupId = value;
                        });
                      },
                validator: (v) => v == null || v.isEmpty
                    ? 'Vui lòng chọn nhóm danh mục'
                    : null,
              );
            },
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
                            RouterNames.categoryItemFormAddLegalDocuments,
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
                          FileIconWidget(fileName: entry.fileName!),
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
      final updateEntry = CategoryItemEntry(
        id: _entry!.id,
        name: _entry?.name != _nameController.text
            ? _nameController.text
            : _entry?.name,
        code: _entry?.code != _codeController.text
            ? _codeController.text
            : _entry?.code,
        description: _entry?.description != _descriptionController.text
            ? _descriptionController.text
            : _entry?.description,
        group: CategoryGroupRefEntry(id: _selectedCategoryGroupId),
        legalDocuments: _legalDocuments,
      );
      if (_isAdmin) {
        context.read<CategoryItemBloc>().add(
          CategoryItemEvent.update(entry: updateEntry),
        );
      } else {
        context.read<CategoryItemVersionBloc>().add(
          CategoryItemVersionEvent.updateVersion(entry: updateEntry),
        );
      }
    } else {
      final createEntry = CategoryItemEntry(
        name: _nameController.text,
        code: _codeController.text,
        description: _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : null,
        group: CategoryGroupRefEntry(id: _selectedCategoryGroupId),
        legalDocuments: _legalDocuments,
      );
      if (_isAdmin) {
        context.read<CategoryItemBloc>().add(
          CategoryItemEvent.create(entry: createEntry),
        );
      } else {
        context.read<CategoryItemVersionBloc>().add(
          CategoryItemVersionEvent.createVersion(entry: createEntry),
        );
      }
    }
    context.pop();
  }
}
