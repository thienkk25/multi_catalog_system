import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/utils/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/core/widgets/bottom_form_actions.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/core/widgets/custom_dropdown_button.dart';
import 'package:multi_catalog_system/core/widgets/custom_input.dart';
import 'package:multi_catalog_system/core/widgets/file_icon_widget.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_entry.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_version_entry.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_bloc.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_event.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_state.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/bloc/domain_lookup_event.dart';
import 'package:multi_catalog_system/features/legal_document/domain/entities/legal_document_entry.dart';

class ApproveFormPage extends StatefulWidget {
  final String versionId;

  const ApproveFormPage({super.key, required this.versionId});

  @override
  State<ApproveFormPage> createState() => _ApproveFormPageState();
}

class _ApproveFormPageState extends State<ApproveFormPage> {
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

  @override
  void initState() {
    super.initState();
    context.domainLookupBloc.add(const DomainLookupEvent.lookup());
    _loadData();
  }

  void _loadData() {
    context.itemVersionBloc.add(
      CategoryItemVersionEvent.getById(id: widget.versionId),
    );
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
    return BlocConsumer<CategoryItemVersionBloc, CategoryItemVersionState>(
      listenWhen: (prev, curr) =>
          prev.entry?.id != curr.entry?.id && curr.entry != null,
      listener: (context, state) {
        final entry = state.entry;
        if (entry != null) {
          _initFromVersion(entry);
        }
      },
      buildWhen: (prev, curr) =>
          prev.entry?.id != curr.entry?.id && curr.entry != null,
      builder: (context, state) => SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(10.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const Text(
                        'Cập nhật phiên bản Mục danh mục',
                        style: TextStyle(
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
            BlocSelector<
              CategoryItemVersionBloc,
              CategoryItemVersionState,
              bool
            >(
              selector: (state) => state.isLoading,
              builder: (context, isLoading) => BottomFormActions(
                isLoading: isLoading,
                key: _bottomBarKey,
                onCancel: () {
                  context.goNamed(RouterNames.approve);
                },
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
                            RouterNames.approveFormAddLegalDocuments,
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
        id: widget.versionId,
        type: 1,
        entry: updateEntry,
      ),
    );
    context.goNamed(RouterNames.approve);
  }
}
