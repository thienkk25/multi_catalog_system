import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/utils/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/widgets/button_back_widget.dart';
import 'package:multi_catalog_system/core/widgets/custom_button.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/core/widgets/custom_circular_progress.dart';
import 'package:multi_catalog_system/core/widgets/password_field_widget.dart';
import 'package:multi_catalog_system/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:multi_catalog_system/features/profile/presentation/bloc/profile_event.dart';
import 'package:multi_catalog_system/features/profile/presentation/bloc/profile_state.dart';
import 'package:multi_catalog_system/features/profile/presentation/widgets/profile_password_rules_widget.dart';

class ProfileChangePasswordPage extends StatefulWidget {
  const ProfileChangePasswordPage({super.key});

  @override
  State<ProfileChangePasswordPage> createState() =>
      _ProfileChangePasswordPageState();
}

class _ProfileChangePasswordPageState extends State<ProfileChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _focusNodeConfirmPassword = FocusNode();

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _focusNodeConfirmPassword.dispose();
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
          context.pop();
        }
      },
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: CustomCard(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.lock_outline, size: 64, color: Colors.blue),
                  const SizedBox(height: 12),
                  Text(
                    'Cập nhật mật khẩu',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 24),

                  PasswordFieldWidget(
                    controller: _newPasswordController,
                    label: Text('Mật khẩu mới'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) =>
                        _focusNodeConfirmPassword.requestFocus(),
                    validator: (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return 'Vui lòng nhập mật khẩu mới';
                      } else if (_newPasswordController.text.length >= 8 &&
                          RegExp(
                            r'[A-Z]',
                          ).hasMatch(_newPasswordController.text) &&
                          RegExp(r'\d').hasMatch(_newPasswordController.text)) {
                        return null;
                      } else {
                        return 'Mật khẩu mới phải đúng quy tắc dưới đây';
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  if (_newPasswordController.text.isNotEmpty)
                    ProfilePasswordRulesWidget(
                      password: _newPasswordController.text,
                    ),
                  const SizedBox(height: 16),
                  PasswordFieldWidget(
                    controller: _confirmPasswordController,
                    label: Text('Xác nhận mật khẩu mới'),
                    focusNode: _focusNodeConfirmPassword,
                    textInputAction: TextInputAction.done,
                    validator: (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return 'Vui lòng nhập xác nhận mật khẩu';
                      } else if (p0 != _newPasswordController.text) {
                        return 'Mật khẩu xác nhận không khớp';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  Row(
                    spacing: 5,
                    children: [
                      Expanded(child: ButtonBackWidget()),
                      Expanded(
                        child: BlocSelector<ProfileBloc, ProfileState, bool>(
                          selector: (state) => state.isLoading,
                          builder: (context, isLoading) => CustomButton(
                            onTap: isLoading
                                ? null
                                : () {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }
                                    context.profileBloc.add(
                                      ProfileEvent.changePassword(
                                        newPassword:
                                            _newPasswordController.text,
                                      ),
                                    );
                                  },
                            colorBackground: isLoading
                                ? Colors.grey
                                : Colors.blue,
                            textButton: isLoading
                                ? const CustomCircularProgressButton()
                                : const Text(
                                    'Đổi mật khẩu',
                                    style: TextStyle(color: Colors.white),
                                  ),
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
      ),
    );
  }
}
