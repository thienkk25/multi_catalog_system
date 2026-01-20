import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/api_key_management/domain/entities/api_key_entry.dart';
import 'package:multi_catalog_system/features/api_key_management/presentation/presentation.dart';
import 'package:multi_catalog_system/features/api_key_management/presentation/widgets/api_key_management_permission_field_widget.dart';

enum ApiKeyManagementFormPageType { detail, create, update }

class ApiKeyManagementFormPage extends StatefulWidget {
  const ApiKeyManagementFormPage({super.key, required this.type, this.entry});

  final ApiKeyManagementFormPageType type;
  final ApiKeyEntry? entry;

  @override
  State<ApiKeyManagementFormPage> createState() =>
      _ApiKeyManagementFormPageState();
}

class _ApiKeyManagementFormPageState extends State<ApiKeyManagementFormPage> {
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _systemNameController = TextEditingController();
  String? _selectedAction;
  List<String> _allowedDomains = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey _bottomBarKey = GlobalKey();
  double _bottomBarHeight = 0;

  bool get _isDetail => widget.type == ApiKeyManagementFormPageType.detail;
  bool get _isUpdate => widget.type == ApiKeyManagementFormPageType.update;

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _keyController.text = widget.entry!.key!;
      _systemNameController.text = widget.entry!.systemName!;
      _selectedAction = widget.entry!.status;
      _allowedDomains = List<String>.from(widget.entry?.allowedDomains ?? []);
    }
  }

  @override
  void dispose() {
    _keyController.dispose();
    _systemNameController.dispose();
    _formKey.currentState?.dispose();
    _bottomBarKey.currentState?.dispose();
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          _isDetail
              ? 'Chi tiết API Key'
              : _isUpdate
              ? 'Chỉnh sửa API Key'
              : 'Thêm API Key mới',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                        child: CustomCard(
                          child: Column(
                            spacing: 20,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomInput(
                                controller: _systemNameController,
                                enabled: !_isDetail,
                                lable: _requiredLabel('Tên API Key / Mô tả'),
                                hintText:
                                    'Nhập tên hoặc mô tả mục đích sử dụng...',
                                validator: (p0) => p0 == null || p0.isEmpty
                                    ? 'Bắt buộc'
                                    : null,
                              ),
                              CustomDropdownButton<String>(
                                value: _selectedAction,
                                lable: _requiredLabel('Trạng thái'),
                                items: [
                                  DropdownMenuItem(
                                    value: 'active',
                                    child: Text('Hoạt động'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'revoked',
                                    child: Text('Thu hồi'),
                                  ),
                                ],

                                onChanged: _isDetail
                                    ? null
                                    : (value) {
                                        setState(() {
                                          _selectedAction = value;
                                        });
                                      },
                                validator: (p0) =>
                                    p0 == null ? 'Bắt buộc' : null,
                              ),
                              ApiKeyManagementPermissionFieldWidget(
                                fields: _allowedDomains,
                                isView: _isDetail,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (!_isDetail)
                        NoteWidget(
                          icon: Icons.info,
                          note: 'Key sẽ được hệ thống tạo tự động sau khi tạo',
                          color: Colors.blueAccent,
                        )
                      else
                        GestureDetector(
                          onTap: () =>
                              _copyToClipboard(context, _keyController.text),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: CustomButton(
                              colorBackground: Colors.blue,
                              textButton: Text(
                                'Sao chép API Key',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ]),
                  ),
                ),

                if (!_isDetail)
                  SliverPadding(
                    padding: EdgeInsets.only(bottom: _bottomBarHeight),
                  ),
              ],
            ),

            if (!_isDetail)
              BlocSelector<ApiKeyBloc, ApiKeyState, bool>(
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

  Future<void> _copyToClipboard(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    context.read<NotificationCubit>().success('Sao chép API Key thành công');
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
      final entry = ApiKeyEntry(
        id: widget.entry!.id,
        systemName: widget.entry?.systemName != _systemNameController.text
            ? _systemNameController.text
            : widget.entry?.systemName,
        status: _selectedAction,
        allowedDomains: _allowedDomains,
      );
      context.read<ApiKeyBloc>().add(ApiKeyEvent.update(entry: entry));
    } else {
      final entry = ApiKeyEntry(
        systemName: _systemNameController.text.isNotEmpty
            ? _systemNameController.text
            : 'SYS_${Random().nextInt(9999999)}',
        status: _selectedAction,
        allowedDomains: _allowedDomains,
      );
      context.read<ApiKeyBloc>().add(ApiKeyEvent.create(entry: entry));
    }
    context.pop();
  }
}
