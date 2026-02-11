import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/config/constants/app_constant.dart';
import 'package:multi_catalog_system/core/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/widgets/button_back_widget.dart';
import 'package:multi_catalog_system/core/widgets/custom_button.dart';
import 'package:multi_catalog_system/core/widgets/custom_circular_progress.dart';
import 'package:multi_catalog_system/core/widgets/custom_input.dart';
import 'package:multi_catalog_system/core/domain/entities/auth/user_entry.dart';
import 'package:multi_catalog_system/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:multi_catalog_system/features/profile/presentation/bloc/profile_event.dart';
import 'package:multi_catalog_system/features/profile/presentation/bloc/profile_state.dart';

class ProfileFormPage extends StatefulWidget {
  final UserEntry entry;
  const ProfileFormPage({super.key, required this.entry});

  @override
  State<ProfileFormPage> createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends State<ProfileFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.entry.email ?? '';
    _fullNameController.text = widget.entry.fullName ?? '';
    _phoneController.text = widget.entry.phone ?? '';
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.error != null) {
          context.notificationCubit.error(state.error!);
        }

        if (state.successMessage != null) {
          context.notificationCubit.success(state.successMessage!);
        }
      },
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 10,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Color(0xff16d9e3),
                            Color(0xff30c7ec),
                            Color(0xff46aef7),
                          ],
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.entry.fullName?[0].toUpperCase() ?? '?',
                        style: TextStyle(
                          fontSize: 48,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blue.shade900,
                      child: IconButton(
                        icon: const Icon(
                          Icons.camera_alt_outlined,
                          size: 18,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                CustomInput(
                  controller: _fullNameController,
                  lable: Text('Họ và tên'),
                  hintText: 'Nhập họ và tên',
                  prefixIcon: Icon(Icons.person_outline),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Không được để trống'
                      : null,
                ),
                CustomInput(
                  controller: _emailController,
                  lable: Text('Email'),
                  prefixIcon: Icon(Icons.email_outlined),
                  suffixIcon: Icon(Icons.lock, color: Colors.blue),
                  readOnly: true,
                ),
                CustomInput(
                  controller: _phoneController,
                  lable: Text('Số điện thoại'),
                  hintText: 'Nhập số điện thoại',
                  prefixIcon: Icon(Icons.phone_outlined),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Không được để trống';
                    }

                    final phone = value.trim();

                    final regExp = RegExp(AppConstant.regPhone);

                    if (!regExp.hasMatch(phone)) {
                      return 'Số điện thoại không hợp lệ';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 10),

                Row(
                  spacing: 5,
                  children: [
                    Expanded(child: ButtonBackWidget()),
                    Expanded(
                      child: BlocSelector<ProfileBloc, ProfileState, bool>(
                        selector: (state) => state.isLoading,
                        builder: (context, isLoading) => CustomButton(
                          textButton: isLoading
                              ? const CustomCircularProgressButton()
                              : const Text(
                                  'Lưu thay đổi',
                                  style: TextStyle(color: Colors.white),
                                ),
                          onTap: isLoading ? null : () => _onSave(context),
                          colorBackground: isLoading
                              ? Colors.grey
                              : Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSave(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final updated = UserEntry(
      fullName: widget.entry.fullName != _fullNameController.text
          ? _fullNameController.text
          : null,
      phone: widget.entry.phone != _phoneController.text
          ? _phoneController.text
          : null,
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: const CustomCircularProgressScreen()),
    );
    context.profileBloc.add(ProfileEvent.updateProfile(entry: updated));
    Future.delayed(const Duration(seconds: 1), () {
      if (!context.mounted) return;
      context.pop();
    });
  }
}
