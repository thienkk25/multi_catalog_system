import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_catalog_system/features/legal_document/domain/entries/legal_document_entry.dart';

class LegalDocumentFormPage extends StatefulWidget {
  final LegalDocumentEntry? initialData;

  const LegalDocumentFormPage({super.key, this.initialData});

  @override
  State<LegalDocumentFormPage> createState() => _LegalDocumentFormPageState();
}

class _LegalDocumentFormPageState extends State<LegalDocumentFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _codeCtrl;
  late final TextEditingController _titleCtrl;
  late final TextEditingController _issuedByCtrl;
  late final TextEditingController _descriptionCtrl;

  String _type = 'Thông tư';
  String _status = 'active';

  DateTime? _issueDate;
  DateTime? _effectiveDate;
  DateTime? _expiryDate;

  @override
  void initState() {
    super.initState();
    final e = widget.initialData;

    _codeCtrl = TextEditingController(text: e?.code ?? '');
    _titleCtrl = TextEditingController(text: e?.title ?? '');
    _issuedByCtrl = TextEditingController(text: e?.issuedBy ?? '');
    _descriptionCtrl = TextEditingController(text: e?.description ?? '');

    _type = e?.type ?? 'Thông tư';
    _status = e?.status ?? 'active';

    _issueDate = e?.issueDate;
    _effectiveDate = e?.effectiveDate;
    _expiryDate = e?.expiryDate;
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _titleCtrl.dispose();
    _issuedByCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  bool get _isUpdate => widget.initialData != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isUpdate ? 'Cập nhật văn bản pháp lý' : 'Tạo văn bản pháp lý',
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _sectionTitle('Thông tin chung'),
                _twoColumn(
                  _textField(
                    controller: _codeCtrl,
                    label: 'Mã văn bản',
                    required: true,
                  ),
                  _dropdown(
                    label: 'Loại văn bản',
                    value: _type,
                    items: const ['Luật', 'Nghị định', 'Thông tư'],
                    onChanged: (v) => setState(() => _type = v!),
                  ),
                ),
                _textField(
                  controller: _titleCtrl,
                  label: 'Tên văn bản',
                  required: true,
                ),
                _dropdown(
                  label: 'Trạng thái',
                  value: _status,
                  items: const ['active', 'inactive'],
                  onChanged: (v) => setState(() => _status = v!),
                ),

                const SizedBox(height: 24),
                _sectionTitle('Thời gian'),
                _twoColumn(
                  _dateField(
                    label: 'Ngày ban hành',
                    value: _issueDate,
                    onPick: (v) => setState(() => _issueDate = v),
                  ),
                  _dateField(
                    label: 'Ngày hiệu lực',
                    value: _effectiveDate,
                    onPick: (v) => setState(() => _effectiveDate = v),
                  ),
                ),
                _dateField(
                  label: 'Ngày hết hiệu lực',
                  value: _expiryDate,
                  onPick: (v) => setState(() => _expiryDate = v),
                  optional: true,
                ),

                const SizedBox(height: 24),
                _sectionTitle('Thông tin khác'),
                _textField(
                  controller: _issuedByCtrl,
                  label: 'Cơ quan ban hành',
                ),
                _textField(
                  controller: _descriptionCtrl,
                  label: 'Mô tả',
                  maxLines: 4,
                ),

                const SizedBox(height: 24),
                _sectionTitle('Tệp đính kèm'),
                _filePicker(),

                const SizedBox(height: 32),
                _actions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===== UI PARTS =====

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _twoColumn(Widget left, Widget right) {
    return LayoutBuilder(
      builder: (context, c) {
        if (c.maxWidth < 600) {
          return Column(children: [left, const SizedBox(height: 12), right]);
        }
        return Row(
          children: [
            Expanded(child: left),
            const SizedBox(width: 16),
            Expanded(child: right),
          ],
        );
      },
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    bool required = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: required
            ? (v) => v == null || v.isEmpty ? 'Không được để trống' : null
            : null,
      ),
    );
  }

  Widget _dropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _dateField({
    required String label,
    required DateTime? value,
    required ValueChanged<DateTime?> onPick,
    bool optional = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: value ?? DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
          if (picked != null) onPick(picked);
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          child: Text(
            value != null
                ? DateFormat('dd/MM/yyyy').format(value)
                : (optional ? 'Vĩnh viễn' : 'Chọn ngày'),
            style: TextStyle(
              color: value != null ? Colors.black : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _filePicker() {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.attach_file),
      label: const Text('Chọn tệp (PDF)'),
    );
  }

  Widget _actions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // TODO: submit
            }
          },
          child: Text(_isUpdate ? 'Lưu thay đổi' : 'Tạo mới'),
        ),
      ],
    );
  }
}
