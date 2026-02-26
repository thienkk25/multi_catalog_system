import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/api_key_management/domain/entities/api_key_entry.dart';
import 'package:multi_catalog_system/features/api_key_management/presentation/presentation.dart';
import 'package:multi_catalog_system/features/api_key_management/presentation/widgets/api_key_management_permission_field_widget.dart';

class ApiKeyManagementFormPage extends StatefulWidget {
  const ApiKeyManagementFormPage({super.key});

  @override
  State<ApiKeyManagementFormPage> createState() =>
      _ApiKeyManagementFormPageState();
}

class _ApiKeyManagementFormPageState extends State<ApiKeyManagementFormPage> {
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _systemNameController = TextEditingController();
  List<String> _allowedDomains = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey _bottomBarKey = GlobalKey();
  double _bottomBarHeight = 0;

  @override
  void initState() {
    super.initState();
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
    return SafeArea(
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(10),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const Text(
                      'Thêm API Key mới',
                      style: TextStyle(
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
                              validator: (p0) =>
                                  p0 == null || p0.isEmpty ? 'Bắt buộc' : null,
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
                    NoteWidget(
                      icon: Icons.info,
                      note: 'Key sẽ được hệ thống tạo tự động sau khi tạo',
                      color: Colors.blueAccent,
                    ),
                  ]),
                ),
              ),
              SliverPadding(padding: EdgeInsets.only(bottom: _bottomBarHeight)),
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
    if (_allowedDomains.isEmpty) {
      context.notificationCubit.warning(
        'Vui lòng cấp quyền lĩnh vực cho API Key',
      );
      return;
    }
    final entry = ApiKeyEntry(
      systemName: _systemNameController.text.isNotEmpty
          ? _systemNameController.text
          : 'SYS_${Random().nextInt(9999999)}',
      allowedDomains: _allowedDomains,
    );
    context.apiKeyBloc.add(ApiKeyEvent.create(entry: entry));
    context.pop();
  }
}
