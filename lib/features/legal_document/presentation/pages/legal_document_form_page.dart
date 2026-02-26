import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/legal_document/domain/entities/legal_document_entry.dart';
import 'package:multi_catalog_system/features/legal_document/presentation/bloc/legal_document_bloc.dart';
import 'package:multi_catalog_system/features/legal_document/presentation/bloc/legal_document_event.dart';
import 'package:multi_catalog_system/features/legal_document/presentation/bloc/legal_document_state.dart';
import 'package:multi_catalog_system/features/legal_document/presentation/widgets/legal_document_import_file.dart';

enum LegalDocumentFormType { create, update }

class LegalDocumentFormPage extends StatefulWidget {
  final LegalDocumentFormType mode;
  final String? id;
  const LegalDocumentFormPage({super.key, required this.mode, this.id});

  @override
  State<LegalDocumentFormPage> createState() => _LegalDocumentFormPageState();
}

class _LegalDocumentFormPageState extends State<LegalDocumentFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String? _type;
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _issueDate;
  DateTime? _effectiveDate;
  DateTime? _expiryDate;
  final GlobalKey _bottomBarKey = GlobalKey();
  double _bottomBarHeight = 0;

  LegalDocumentEntry? _entry;

  bool get _isUpdate => widget.mode == LegalDocumentFormType.update;

  bool _didInit = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    switch (widget.mode) {
      case LegalDocumentFormType.create:
        break;
      case LegalDocumentFormType.update:
        context.legalDocumentBloc.add(
          LegalDocumentEvent.getById(id: widget.id!),
        );
        break;
    }
  }

  void _initFromData(LegalDocumentEntry entry) {
    if (_didInit) return;
    _entry = entry;
    _codeController.text = entry.code ?? '';
    _nameController.text = entry.title ?? '';
    _type = entry.type;
    _descriptionController.text = entry.description ?? '';
    _issueDate = entry.issueDate;
    _effectiveDate = entry.effectiveDate;
    _expiryDate = entry.expiryDate;

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
    return BlocConsumer<LegalDocumentBloc, LegalDocumentState>(
      listenWhen: (previous, current) =>
          previous.entry != current.entry && current.entry != null,
      listener: (context, state) {
        final entry = state.entry;
        if (entry != null) {
          _initFromData(entry);
          context.documentFileCubit.setRemoteFile(entry.fileName);
        }
      },
      buildWhen: (previous, current) =>
          previous.entry != current.entry && current.entry != null,
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
                        _isUpdate
                            ? 'Cập nhật văn bản pháp lý'
                            : 'Tạo văn bản pháp lý',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Form(
                        key: _formKey,
                        child: Column(
                          spacing: 10,
                          children: [
                            _generalInformation(),
                            _timeInformation(),
                            NoteWidget(
                              icon: Icons.warning_amber_outlined,
                              note:
                                  'Ngày ban hành bắt buộc. Ngày hiệu lực bắt buộc và >= ngày ban hành. Ngày hết hiệu lực không chọn là ngày hiệu lực vĩnh viễn',
                              color: Colors.deepOrangeAccent,
                            ),
                            LegalDocumentImportFile(),
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
            BlocSelector<LegalDocumentBloc, LegalDocumentState, bool>(
              selector: (state) => state.isLoading,
              builder: (context, isLoading) => BottomFormActions(
                isLoading: isLoading,
                key: _bottomBarKey,
                onCancel: () => context.pop(),
                onSave: () => _onSave(context),
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
          Row(
            spacing: 5,
            children: [
              const Icon(
                Icons.info_outlined,
                size: 20,
                color: Color(0xFF2563EB),
              ),
              const Text(
                'Thông tin chung',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          CustomInput(
            controller: _codeController,
            lable: Text('Mã văn bản'),
            hintText: 'Ví dụ: VBN-1,...',
            validator: (p0) =>
                p0 == null || p0.isEmpty ? 'Vui lòng nhập mã văn bản' : null,
          ),
          CustomInput(
            controller: _nameController,
            lable: Text('Tên văn bản'),
            hintText: 'Ví dụ: Văn bản...',
            validator: (p0) =>
                p0 == null || p0.isEmpty ? 'Vui lòng nhập tên văn bản' : null,
          ),
          CustomDropdownButton(
            value: _type,
            lable: Text('Loại văn bản'),
            hint: '---',
            items: [
              DropdownMenuItem(value: 'Luật', child: Text('Luật')),
              DropdownMenuItem(value: 'Nghị định', child: Text('Nghị định')),
              DropdownMenuItem(value: 'Thông tư', child: Text('Thông tư')),
              DropdownMenuItem(value: 'Khác', child: Text('Khác')),
            ],
            onChanged: (value) {
              setState(() => _type = value);
            },
            validator: (p0) =>
                p0 == null || p0.isEmpty ? 'Vui lòng chọn loại văn bản' : null,
          ),
          CustomInput(
            controller: _descriptionController,
            lable: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Mô tả văn bản'),
                Text('Tùy chọn', style: TextStyle(color: Colors.grey)),
              ],
            ),
            hintText: 'Nhập mô tả về văn bản này...',
            minLines: 5,
            maxLines: 5,
          ),
        ],
      ),
    );
  }

  Widget _timeInformation() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Row(
            spacing: 5,
            children: [
              const Icon(
                Icons.timer_outlined,
                size: 20,
                color: Color(0xFF2563EB),
              ),
              const Text(
                'Thời gian',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          CustomDatePicker(
            label: 'Ngày ban hành',
            initialDate: _issueDate,
            onChanged: (value) => _issueDate = value,
          ),
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: CustomDatePicker(
                  icon: Icons.event_available,
                  label: 'Ngày hiệu lực',
                  initialDate: _effectiveDate,
                  onChanged: (value) => _effectiveDate = value,
                ),
              ),
              Expanded(
                child: CustomDatePicker(
                  icon: Icons.event_busy,
                  label: 'Ngày hết hiệu lực',
                  initialDate: _expiryDate,
                  onChanged: (value) => _expiryDate = value,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _onSave(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    if (_issueDate == null) {
      context.notificationCubit.warning('Vui lọc nhập ngày phát hành');
      return;
    }
    if (_effectiveDate == null) {
      context.notificationCubit.warning('Vui lọc nhập ngày hiệu lực');
      return;
    }
    if (_effectiveDate != null && _effectiveDate!.isBefore(_issueDate!)) {
      context.notificationCubit.warning(
        'Ngày hiệu lực phải lớn hơn hoặc bằng ngày phát hành',
      );
      return;
    }
    if (_expiryDate != null &&
        _expiryDate!.isBefore(_effectiveDate!.add(const Duration(days: 1)))) {
      context.notificationCubit.warning(
        'Ngày hết hiệu lực phải sau ngày hiệu lực',
      );
      return;
    }
    if (_isUpdate) {
      final data = LegalDocumentEntry(
        id: _entry!.id,
        code: _entry?.code == _codeController.text
            ? _codeController.text
            : _entry?.code,
        title: _entry?.title == _nameController.text
            ? _nameController.text
            : _entry?.title,
        type: _type ?? _entry?.type,
        issueDate: _issueDate ?? _entry?.issueDate,
        effectiveDate: _effectiveDate ?? _entry?.effectiveDate,
        expiryDate: _expiryDate ?? _entry?.expiryDate,
        description: _entry?.description == _descriptionController.text
            ? _descriptionController.text
            : _entry?.description,
        fileName: _entry?.fileName,
        fileUrl: _entry?.fileUrl,
      );
      context.legalDocumentBloc.add(
        LegalDocumentEvent.update(
          entry: data,
          file: context.documentFileCubit.state.file,
        ),
      );
    } else {
      final data = LegalDocumentEntry(
        code: _codeController.text,
        title: _nameController.text,
        type: _type!,
        issueDate: _issueDate,
        effectiveDate: _effectiveDate,
        expiryDate: _expiryDate,
        description: _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : null,
      );
      context.legalDocumentBloc.add(
        LegalDocumentEvent.create(
          entry: data,
          file: context.documentFileCubit.state.file,
        ),
      );
    }
    context.pop();
  }
}
