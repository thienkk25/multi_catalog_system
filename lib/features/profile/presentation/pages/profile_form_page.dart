import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/widgets/custom_button.dart';
import 'package:multi_catalog_system/core/widgets/custom_input.dart';
import 'package:multi_catalog_system/features/profile/domain/entities/user_entry.dart';
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

  final String _regPhone = r'^(?:\+84|0084|0)(?:1|2|3|5|7|8|9)[0-9]{8,9}$';

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
    return Scaffold(
      appBar: AppBar(title: const Text('Hồ sơ cá nhân'), centerTitle: true),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: Colors.green,
              ),
            );
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
                    enabled: false,
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

                      final regExp = RegExp(_regPhone);

                      if (!regExp.hasMatch(phone)) {
                        return 'Số điện thoại không hợp lệ';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 10),

                  CustomButton(
                    textButton: Text(
                      'Lưu thay đổi',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      if (!_formKey.currentState!.validate()) return;

                      final updated = UserEntry(
                        fullName: _fullNameController.text.isNotEmpty
                            ? _fullNameController.text
                            : null,
                        phone: _phoneController.text.isNotEmpty
                            ? _phoneController.text
                            : null,
                      );
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) =>
                            Center(child: const CircularProgressIndicator()),
                      );
                      context.read<ProfileBloc>().add(
                        ProfileEvent.updateProfile(entry: updated),
                      );
                      Future.delayed(const Duration(seconds: 1), () {
                        if (!context.mounted) return;
                        context.pop();
                      });
                    },
                    colorBackground: Colors.blue,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
