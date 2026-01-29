import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/config/constants/app_constant.dart';
import 'package:multi_catalog_system/core/domain/entities/auth/user_profile_entry.dart';
import 'package:multi_catalog_system/core/widgets/custom_button.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/core/widgets/custom_input.dart';
import 'package:multi_catalog_system/core/widgets/note_widget.dart';
import 'package:multi_catalog_system/features/user_management/presentation/bloc/user_management_bloc.dart';
import 'package:multi_catalog_system/features/user_management/presentation/bloc/user_management_event.dart';
import 'package:multi_catalog_system/features/user_management/presentation/bloc/user_management_state.dart';

class UserManagementFormPage extends StatefulWidget {
  final UserProfileEntry? entry;

  const UserManagementFormPage({super.key, this.entry});

  @override
  State<UserManagementFormPage> createState() => _UserManagementFormPageState();
}

class _UserManagementFormPageState extends State<UserManagementFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _emailCtrl;
  late final TextEditingController _fullNameCtrl;
  late final TextEditingController _phoneCtrl;
  final TextEditingController _passwordCtrl = TextEditingController();

  bool get _isUpdate => widget.entry != null;

  @override
  void initState() {
    super.initState();

    _emailCtrl = TextEditingController(text: widget.entry?.email);
    _fullNameCtrl = TextEditingController(text: widget.entry?.fullName);
    _phoneCtrl = TextEditingController(text: widget.entry?.phone);
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _fullNameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isUpdate ? 'Cập nhật người dùng' : 'Tạo người dùng'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: CustomCard(
              child: Column(
                children: [
                  CustomInput(
                    controller: _emailCtrl,
                    readOnly: _isUpdate,
                    lable: const Row(
                      children: [
                        Text('Email'),
                        Text('*', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                    hintText: 'Nhập email của người dùng',
                    validator: (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return 'Vui lồng nhập email người dùng';
                      } else if (!RegExp(AppConstant.regEmail).hasMatch(p0)) {
                        return 'Email không hợp lệ';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  CustomInput(
                    controller: _fullNameCtrl,
                    lable: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Họ và tên'),
                        Text('Tùy chọn', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    hintText: 'Nhập họ và tên người dùng',
                  ),
                  SizedBox(height: 16),
                  CustomInput(
                    controller: _phoneCtrl,
                    lable: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Số điện thoại'),
                        Text('Tùy chọn', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    hintText: 'Nhập số điện thoại người dùng',
                    validator: (p0) {
                      if (p0!.isNotEmpty &&
                          !RegExp(AppConstant.regPhone).hasMatch(p0)) {
                        return 'Số điện thoại không hợp lệ';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  CustomInput(
                    controller: _passwordCtrl,
                    lable: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Mật khẩu'),
                        Text('Tùy chọn', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    hintText: _isUpdate
                        ? 'Để trống nếu không muốn thay đổi mật khẩu'
                        : 'Nhập mật khẩu người dùng',
                  ),
                  SizedBox(height: 16),
                  if (!_isUpdate)
                    NoteWidget(
                      icon: Icons.info,
                      note: 'Nếu mật khẩu để trống mặc định là "12345678"',
                      color: Colors.blue,
                    )
                  else
                    NoteWidget(
                      icon: Icons.info,
                      note:
                          'Nhập mật khẩu mới để thay đổi, hoặc để trống để giữ nguyên mật khẩu hiện tại',
                      color: Colors.blue,
                    ),

                  SizedBox(height: 32),
                  BlocSelector<UserManagementBloc, UserManagementState, bool>(
                    selector: (state) => state.isLoading,
                    builder: (context, isLoading) => CustomButton(
                      onTap: isLoading ? null : () => _onSubmit(context),
                      colorBackground: isLoading ? Colors.grey : Colors.blue,
                      textButton: Text(
                        _isUpdate ? 'Cập nhật' : 'Tạo',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    if (_isUpdate) {
      final entry = UserProfileEntry(
        id: widget.entry!.id,
        fullName: widget.entry!.fullName != _fullNameCtrl.text
            ? _fullNameCtrl.text
            : null,
        phone: widget.entry!.phone != _phoneCtrl.text ? _phoneCtrl.text : null,
      );

      context.read<UserManagementBloc>().add(
        UserManagementEvent.update(entry: entry, id: entry.id!),
      );
    } else {
      final entry = UserProfileEntry(
        email: _emailCtrl.text,
        fullName: _fullNameCtrl.text.isNotEmpty ? _fullNameCtrl.text : null,
        phone: _phoneCtrl.text.isNotEmpty ? _phoneCtrl.text : null,
        password: _passwordCtrl.text.isNotEmpty ? _passwordCtrl.text : null,
      );
      context.read<UserManagementBloc>().add(
        UserManagementEvent.create(entry: entry),
      );
    }
    context.pop();
  }
}
