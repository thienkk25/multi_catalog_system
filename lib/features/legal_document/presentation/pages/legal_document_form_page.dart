import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/legal_document/domain/entries/legal_document_entry.dart';

enum LegalDocumentFormPageType { create, update }

class LegalDocumentFormPage extends StatefulWidget {
  final LegalDocumentEntry? entry;
  final LegalDocumentFormPageType type;
  const LegalDocumentFormPage({super.key, this.entry, required this.type});

  @override
  State<LegalDocumentFormPage> createState() => _LegalDocumentFormPageState();
}

class _LegalDocumentFormPageState extends State<LegalDocumentFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String? _type;
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _effectiveDate;
  DateTime? _expiryDate;
  final GlobalKey _bottomBarKey = GlobalKey();
  double _bottomBarHeight = 0;

  late bool _isEdit;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.type == LegalDocumentFormPageType.update;
    if (widget.entry != null) {
      _codeController.text = widget.entry!.code;
      _nameController.text = widget.entry!.title;
      _type = widget.entry!.type;
      _descriptionController.text = widget.entry!.description!;
      _effectiveDate = widget.entry!.effectiveDate;
      _expiryDate = widget.entry!.expiryDate;
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
    return Scaffold(
      appBar: AppBar(
        title: _isEdit
            ? const Text('Chỉnh sửa văn bản pháp lý')
            : const Text('Tạo văn bản pháp lý'),
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
                          spacing: 10,
                          children: [
                            CustomCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 10,
                                children: [
                                  const Text(
                                    'Thông tin chung',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF111827),
                                    ),
                                  ),
                                  CustomInput(
                                    controller: _codeController,
                                    lable: Text('Mã văn bản'),
                                    hintText: 'Ví dụ: VBN-1,...',
                                    validator: (p0) => p0 == null || p0.isEmpty
                                        ? 'Vui lòng nhập mã văn bản'
                                        : null,
                                  ),
                                  CustomInput(
                                    controller: _nameController,
                                    lable: Text('Tên văn bản'),
                                    hintText: 'Ví dụ: Văn bản...',
                                    validator: (p0) => p0 == null || p0.isEmpty
                                        ? 'Vui lòng nhập tên văn bản'
                                        : null,
                                  ),
                                  CustomDropdownButton(
                                    value: _type,
                                    lable: Text('Loại văn bản'),
                                    hint: '---',
                                    items: [
                                      DropdownMenuItem(
                                        value: 'Luật',
                                        child: Text('Luật'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Nghị định',
                                        child: Text('Nghị định'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Thông tư',
                                        child: Text('Thông tư'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Khác',
                                        child: Text('Khác'),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() => _type = value);
                                    },
                                    validator: (p0) => p0 == null || p0.isEmpty
                                        ? 'Vui lòng chọn loại văn bản'
                                        : null,
                                  ),
                                  CustomInput(
                                    controller: _descriptionController,
                                    lable: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Mô tả văn bản'),
                                        Text(
                                          'Tùy chọn',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    hintText: 'Nhập mô tả về văn bản này...',
                                    minLines: 5,
                                    maxLines: 5,
                                  ),
                                ],
                              ),
                            ),
                            CustomCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 10,
                                children: [
                                  const Text(
                                    'Thời gian',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF111827),
                                    ),
                                  ),
                                  Row(
                                    spacing: 10,
                                    children: [
                                      Expanded(
                                        child: CustomDatePicker(
                                          label: 'Ngày hiệu lực',
                                          initialDate: _effectiveDate,
                                          onChanged: (value) => setState(
                                            () => _effectiveDate = value,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: CustomDatePicker(
                                          label: 'Ngày hết hiệu lực',
                                          initialDate: _expiryDate,
                                          onChanged: (value) => setState(
                                            () => _expiryDate = value,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
            BottomFormActions(
              key: _bottomBarKey,
              onCancel: () => context.pop(),
              onSave: () => _onSave(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSave(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    if (_expiryDate != null &&
        _expiryDate!.isBefore(_effectiveDate!.add(const Duration(days: 1)))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ngày hết hiệu lực phải sau ngày hiệu lực'),
        ),
      );
      return;
    }
  }
}
