import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/config/constants/app_constant.dart';
import 'package:multi_catalog_system/core/utils/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/widgets/button_back_widget.dart';
import 'package:multi_catalog_system/core/widgets/custom_button.dart';
import 'package:multi_catalog_system/core/widgets/custom_circular_progress.dart';
import 'package:multi_catalog_system/core/widgets/custom_input.dart';
import 'package:multi_catalog_system/core/domain/entities/auth/user_entry.dart';
import 'package:multi_catalog_system/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:multi_catalog_system/features/profile/presentation/bloc/profile_event.dart';
import 'package:multi_catalog_system/features/profile/presentation/bloc/profile_state.dart';

class ProfileFormPage extends StatefulWidget {
  const ProfileFormPage({super.key});

  @override
  State<ProfileFormPage> createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends State<ProfileFormPage> {
  UserEntry? _entry;

  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _didInit = false;

  @override
  void initState() {
    super.initState();
    context.profileBloc.add(const ProfileEvent.getProfile());
  }

  void _initFromData(UserEntry entry) {
    if (_didInit) return;

    _entry = entry;
    _fullNameController.text = entry.fullName ?? '';
    _emailController.text = entry.email ?? '';
    _phoneController.text = entry.phone ?? '';

    _didInit = true;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.error != null) {
          context.notificationCubit.error(state.error!);
        }

        if (state.successMessage != null) {
          context.notificationCubit.success(state.successMessage!);
        }
        if (state.entry != null) {
          _initFromData(state.entry!);
        }
      },
      builder: (context, state) => SafeArea(
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
                        _entry?.fullName?[0].toUpperCase() ?? '?',
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
      fullName: _entry?.fullName != _fullNameController.text
          ? _fullNameController.text
          : null,
      phone: _entry?.phone != _phoneController.text
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
