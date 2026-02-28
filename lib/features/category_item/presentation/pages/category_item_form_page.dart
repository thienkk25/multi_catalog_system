import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/domain/entities/category_group/category_group_ref_entry.dart';
import 'package:multi_catalog_system/core/domain/entities/domain/domain_ref_entry.dart';
import 'package:multi_catalog_system/core/responsive/screen_size.dart';
import 'package:multi_catalog_system/core/utils/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/core/utils/extensions/auth_permission_extension.dart';
import 'package:multi_catalog_system/core/widgets/bottom_form_actions.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/core/widgets/custom_dropdown_button.dart';
import 'package:multi_catalog_system/core/widgets/custom_input.dart';
import 'package:multi_catalog_system/core/widgets/file_icon_widget.dart';
import 'package:multi_catalog_system/core/widgets/overlay_dropdown_load_button.dart';
import 'package:multi_catalog_system/features/category_group/presentation/bloc/category_group_lookup_bloc.dart';
import 'package:multi_catalog_system/features/category_group/presentation/bloc/category_group_lookup_event.dart';
import 'package:multi_catalog_system/features/category_group/presentation/bloc/category_group_lookup_state.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_entry.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_version_entry.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_bloc.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_event.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_state.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_bloc.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_event.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_state.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/bloc/domain_lookup_bloc.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/bloc/domain_lookup_event.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/bloc/domain_lookup_state.dart';
import 'package:multi_catalog_system/features/legal_document/domain/entities/legal_document_entry.dart';

enum CategoryItemFormMode { create, updateItem, updateVersion }

class CategoryItemFormPage extends StatefulWidget {
  final CategoryItemFormMode mode;
  final String? itemId;
  final String? versionId;

  const CategoryItemFormPage({
    super.key,
    required this.mode,
    this.itemId,
    this.versionId,
  });

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
  String? _selectedStatus;

  final GlobalKey _bottomBarKey = GlobalKey();
  double _bottomBarHeight = 0;

  bool _didInit = false;

  CategoryItemEntry? _entry;

  bool get _isCreate => widget.mode == CategoryItemFormMode.create;
  bool get _isUpdateItem => widget.mode == CategoryItemFormMode.updateItem;
  bool get _isAdmin => context.hasRole('admin');

  @override
  void initState() {
    super.initState();
    context.domainLookupBloc.add(const DomainLookupEvent.lookup());
    _loadData();
  }

  void _loadData() {
    switch (widget.mode) {
      case CategoryItemFormMode.create:
        return;

      case CategoryItemFormMode.updateItem:
        context.itemBloc.add(CategoryItemEvent.getById(id: widget.itemId!));
        break;

      case CategoryItemFormMode.updateVersion:
        context.itemVersionBloc.add(
          CategoryItemVersionEvent.getById(id: widget.versionId!),
        );
        break;
    }
  }

  Future<void> _initFromItem(CategoryItemEntry entry) async {
    if (_didInit) return;

    _entry = entry;

    final domainId = entry.domainId;
    final groupId = entry.groupId;
    _codeController.text = entry.code ?? '';
    _nameController.text = entry.name ?? '';
    _descriptionController.text = entry.description ?? '';
    _selectedStatus = entry.status;

    _selectedDomainId = domainId;

    context.categoryGroupLookupBloc.add(
      CategoryGroupLookupEvent.lookup(domainIds: [domainId]),
    );

    _selectedCategoryGroupId = groupId;

    _legalDocuments = entry.legalDocuments ?? [];

    _didInit = true;
  }

  void _initFromVersion(CategoryItemVersionEntry version) {
    if (_didInit) return;

    final json = version.newValue ?? {};

    _entry = CategoryItemEntry(
      name: json['name'],
      code: json['code'],
      description: json['description'],
      domainId: json['domain_id'],
      groupId: json['group_id'],
      status: json['status'],
    );

    _codeController.text = json['code'] ?? '';
    _nameController.text = json['name'] ?? '';
    _descriptionController.text = json['description'] ?? '';
    _selectedDomainId = json['domain_id'] ?? '';
    _selectedCategoryGroupId = json['group_id'] ?? '';
    _selectedStatus = json['status'] ?? '';

    _legalDocuments = version.legalDocuments ?? [];

    _didInit = true;
    setState(() {});
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
    return MultiBlocListener(
      listeners: [
        BlocListener<CategoryItemBloc, CategoryItemState>(
          listenWhen: (prev, curr) =>
              prev.entry?.id != curr.entry?.id && curr.entry != null,
          listener: (context, state) {
            final entry = state.entry;
            if (entry != null) {
              _initFromItem(entry);
            }
          },
        ),
        BlocListener<CategoryItemVersionBloc, CategoryItemVersionState>(
          listenWhen: (prev, curr) =>
              prev.entry?.id != curr.entry?.id && curr.entry != null,
          listener: (context, state) {
            final entry = state.entry;
            if (entry != null) {
              _initFromVersion(entry);
            }
          },
        ),
      ],
      child: BlocBuilder<CategoryItemBloc, CategoryItemState>(
        builder: (context, state) => SafeArea(
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(10.0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Text(
                          _isCreate
                              ? 'Tạo Mục danh mục'
                              : _entry != null
                              ? 'Cập nhật Mục danh mục'
                              : 'Cập nhật Version Mục danh mục',
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
                  onCancel: () {
                    if (_isCreate || _isUpdateItem) {
                      context.goNamed(RouterNames.categoryItem);
                    } else {
                      context.goNamed(RouterNames.categoryItem);
                    }
                  },
                  onSave: () => _onSave(context: context, isEdit: true),
                ),
              ),
            ],
          ),
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
          if (_isCreate)
            Column(
              spacing: 10,
              children: [
                BlocBuilder<DomainLookupBloc, DomainLookupState>(
                  builder: (context, state) {
                    return OverlayDropdownLoadButton<DomainRefEntry>(
                      isMulti: false,
                      maxWidthOverlay:
                          ScreenSize.of(context).width -
                          (ScreenSize.of(context).isMobile ? 0 : 300),
                      label: Text(
                        'Lĩnh vực',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      entries: state.entries,
                      selected: state.selectedEntries.firstOrNull,
                      itemLabel: (item) => item.name!,
                      hasMore: state.hasMore,
                      isLoadingMore: state.isLoadingMore,
                      onLoadMore: () {
                        context.domainLookupBloc.add(
                          const DomainLookupEvent.loadMore(),
                        );
                      },
                      onSelected: (value) {
                        _selectedDomainId = value.id;
                        context.domainLookupBloc.add(
                          DomainLookupEvent.selectedEntries(entries: [value]),
                        );
                        context.categoryGroupLookupBloc.add(
                          CategoryGroupLookupEvent.lookup(
                            domainIds: [_selectedDomainId!],
                          ),
                        );
                      },
                    );
                  },
                ),
                BlocBuilder<CategoryGroupLookupBloc, CategoryGroupLookupState>(
                  builder: (context, state) {
                    return OverlayDropdownLoadButton<CategoryGroupRefEntry>(
                      isMulti: false,
                      maxWidthOverlay:
                          ScreenSize.of(context).width -
                          (ScreenSize.of(context).isMobile ? 0 : 300),
                      label: Text(
                        'Nhóm danh mục',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      entries: state.entries,
                      selected: state.selectedEntries.firstOrNull,
                      itemLabel: (item) => item.name!,
                      hasMore: state.hasMore,
                      isLoadingMore: state.isLoadingMore,
                      onLoadMore: () {
                        context.categoryGroupLookupBloc.add(
                          const CategoryGroupLookupEvent.loadMore(),
                        );
                      },
                      onSelected: (value) {
                        _selectedCategoryGroupId = value.id;
                        context.categoryGroupLookupBloc.add(
                          CategoryGroupLookupEvent.selectedEntries(
                            entries: [value],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          CustomDropdownButton<String>(
            lable: const Text(
              'Trạng thái',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            hint: 'Chọn trạng thái',
            value: _selectedStatus,
            items: [
              DropdownMenuItem<String>(
                value: 'active',
                child: Text('Hoạt động'),
              ),
              DropdownMenuItem<String>(
                value: 'inactive',
                child: Text('Ngừng hoạt động'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedStatus = value;
              });
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
                            extra: _legalDocuments,
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
              ? ListView.builder(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _legalDocuments.length,
                  itemBuilder: (context, index) {
                    final entry = _legalDocuments[index];
                    return Container(
                      margin: EdgeInsets.all(10),
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
    if (_isCreate) {
      final createEntry = CategoryItemEntry(
        name: _nameController.text,
        code: _codeController.text,
        description: _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : null,
        domainId: _selectedDomainId!,
        groupId: _selectedCategoryGroupId,
        status: _selectedStatus,
        legalDocuments: _legalDocuments,
      );
      if (_isAdmin) {
        context.itemBloc.add(CategoryItemEvent.create(entry: createEntry));
      } else {
        context.itemVersionBloc.add(
          CategoryItemVersionEvent.createVersion(entry: createEntry),
        );
      }
    } else if (_isUpdateItem) {
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
        domainId: _selectedDomainId!,
        groupId: _selectedCategoryGroupId,
        status: _selectedStatus,
        legalDocuments: _legalDocuments,
      );
      if (_isAdmin) {
        context.itemBloc.add(CategoryItemEvent.update(entry: updateEntry));
      } else {
        context.itemVersionBloc.add(
          CategoryItemVersionEvent.updateVersion(
            id: _entry!.id!,
            type: 0,
            entry: updateEntry,
          ),
        );
      }
    } else {
      final updateEntry = CategoryItemEntry(
        name: _entry?.name != _nameController.text
            ? _nameController.text
            : _entry?.name,
        code: _entry?.code != _codeController.text
            ? _codeController.text
            : _entry?.code,
        description: _entry?.description != _descriptionController.text
            ? _descriptionController.text
            : _entry?.description,
        domainId: _selectedDomainId!,
        groupId: _selectedCategoryGroupId!,
        status: _selectedStatus,
        legalDocuments: _legalDocuments,
      );

      context.itemVersionBloc.add(
        CategoryItemVersionEvent.updateVersion(
          id: widget.versionId!,
          type: 1,
          entry: updateEntry,
        ),
      );
    }
    if (_isCreate || _isUpdateItem) {
      context.goNamed(RouterNames.categoryItem);
    } else {
      context.goNamed(RouterNames.categoryItem);
    }
  }
}
