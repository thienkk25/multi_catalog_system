import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/legal_document/domain/entities/legal_document_entry.dart';
import 'package:multi_catalog_system/features/legal_document/presentation/bloc/document_file_cubit.dart';
import 'package:multi_catalog_system/features/legal_document/presentation/bloc/legal_document_bloc.dart';
import 'package:multi_catalog_system/features/legal_document/presentation/bloc/legal_document_event.dart';
import 'package:multi_catalog_system/features/legal_document/presentation/bloc/legal_document_state.dart';
import 'package:multi_catalog_system/features/legal_document/presentation/widgets/legal_document_import_file.dart';

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
  DateTime? _issueDate;
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
      _codeController.text = widget.entry!.code ?? '';
      _nameController.text = widget.entry!.title ?? '';
      _type = widget.entry!.type;
      _descriptionController.text = widget.entry!.description ?? '';
      _issueDate = widget.entry!.issueDate;
      _effectiveDate = widget.entry!.effectiveDate;
      _expiryDate = widget.entry!.expiryDate;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DocumentFileCubit>().setRemoteFile(widget.entry?.fileName);
    });
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
            onChanged: (value) => setState(() => _issueDate = value),
          ),
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: CustomDatePicker(
                  icon: Icons.event_available,
                  label: 'Ngày hiệu lực',
                  initialDate: _effectiveDate,
                  onChanged: (value) => setState(() => _effectiveDate = value),
                ),
              ),
              Expanded(
                child: CustomDatePicker(
                  icon: Icons.event_busy,
                  label: 'Ngày hết hiệu lực',
                  initialDate: _expiryDate,
                  onChanged: (value) => setState(() => _expiryDate = value),
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
      context.read<NotificationCubit>().warning('Vui lọc nhập ngày phát hành');
      return;
    }
    if (_effectiveDate == null) {
      context.read<NotificationCubit>().warning('Vui lọc nhập ngày hiệu lực');
      return;
    }
    if (_effectiveDate != null && _effectiveDate!.isBefore(_issueDate!)) {
      context.read<NotificationCubit>().warning(
        'Ngày hiệu lực phải lớn hơn hoặc bằng ngày phát hành',
      );
      return;
    }
    if (_expiryDate != null &&
        _expiryDate!.isBefore(_effectiveDate!.add(const Duration(days: 1)))) {
      context.read<NotificationCubit>().warning(
        'Ngày hết hiệu lực phải sau ngày hiệu lực',
      );
      return;
    }
    if (_isEdit) {
      final data = LegalDocumentEntry(
        id: widget.entry!.id,
        code: _codeController.text.isNotEmpty
            ? _codeController.text
            : widget.entry?.code,
        title: _nameController.text.isNotEmpty
            ? _nameController.text
            : widget.entry?.title,
        type: _type ?? widget.entry?.type,
        issueDate: _issueDate ?? widget.entry?.issueDate,
        effectiveDate: _effectiveDate ?? widget.entry?.effectiveDate,
        expiryDate: _expiryDate ?? widget.entry?.expiryDate,
        description: _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : widget.entry?.description,
        fileName: widget.entry?.fileName,
        fileUrl: widget.entry?.fileUrl,
      );
      context.read<LegalDocumentBloc>().add(
        LegalDocumentEvent.update(
          entry: data,
          file: context.read<DocumentFileCubit>().state.file,
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
      context.read<LegalDocumentBloc>().add(
        LegalDocumentEvent.create(
          entry: data,
          file: context.read<DocumentFileCubit>().state.file,
        ),
      );
    }
    context.pop();
  }
}
