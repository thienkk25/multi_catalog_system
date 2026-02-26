import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/api_key_management/domain/entities/api_key_entry.dart';
import 'package:multi_catalog_system/features/api_key_management/presentation/presentation.dart';
import 'package:multi_catalog_system/features/api_key_management/presentation/widgets/api_key_management_permission_field_widget.dart';

enum ApiKeyManagementFormType { create, update }

class ApiKeyManagementFormPage extends StatefulWidget {
  final ApiKeyManagementFormType mode;
  final String? id;
  const ApiKeyManagementFormPage({super.key, required this.mode, this.id});

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

  ApiKeyEntry? _entry;

  bool get _isUpdate => widget.mode == ApiKeyManagementFormType.update;

  bool _didInit = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    switch (widget.mode) {
      case ApiKeyManagementFormType.create:
        break;
      case ApiKeyManagementFormType.update:
        context.apiKeyBloc.add(ApiKeyEvent.getById(id: widget.id!));
        break;
    }
  }

  void _initFromData(ApiKeyEntry entry) {
    if (_didInit) return;
    _entry = entry;
    _keyController.text = entry.key!;
    _systemNameController.text = entry.systemName!;
    _selectedAction = entry.status;
    _allowedDomains = List<String>.from(entry.allowedDomains ?? []);
    _didInit = true;
    setState(() {});
  }

  @override
  void dispose() {
    _keyController.dispose();
    _systemNameController.dispose();
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
    return BlocConsumer<ApiKeyBloc, ApiKeyState>(
      listener: (context, state) {
        final entry = state.entry;
        if (entry != null) {
          _initFromData(entry);
        }
      },
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
                        _isUpdate ? 'Chỉnh sửa API Key' : 'Thêm API Key mới',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        child: CustomCard(
                          child: Column(
                            spacing: 20,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomInput(
                                controller: _systemNameController,
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

                                onChanged: (value) {
                                  _selectedAction = value;
                                },
                                validator: (p0) =>
                                    p0 == null ? 'Bắt buộc' : null,
                              ),
                              ApiKeyManagementPermissionFieldWidget(
                                fields: _allowedDomains,
                                isDetail: false,
                                onSelected: (value) {
                                  setState(() {
                                    _allowedDomains = value
                                        .map((e) => e.code!)
                                        .toList();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (!_isUpdate)
                        NoteWidget(
                          icon: Icons.info,
                          note: 'Key sẽ được hệ thống tạo tự động sau khi tạo',
                          color: Colors.blueAccent,
                        ),
                    ]),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(bottom: _bottomBarHeight),
                ),
              ],
            ),

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
        id: _entry!.id,
        systemName: _entry?.systemName != _systemNameController.text
            ? _systemNameController.text
            : _entry?.systemName,
        status: _selectedAction,
        allowedDomains: _allowedDomains,
      );
      context.apiKeyBloc.add(ApiKeyEvent.update(entry: entry));
    } else {
      final entry = ApiKeyEntry(
        systemName: _systemNameController.text.isNotEmpty
            ? _systemNameController.text
            : 'SYS_${Random().nextInt(9999999)}',
        status: _selectedAction,
        allowedDomains: _allowedDomains,
      );
      context.apiKeyBloc.add(ApiKeyEvent.create(entry: entry));
    }
    context.pop();
  }
}
