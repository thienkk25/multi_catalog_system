import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/auth/presentation/presentation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode passFocusNode = FocusNode();

  @override
  void dispose() {
    formKey.currentState?.dispose();
    emailController.dispose();
    passwordController.dispose();
    passFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              spacing: 20,
              children: [
                Text(
                  'Đăng nhập',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight(600)),
                ),
                CustomInput(
                  lable: Text('Email'),
                  controller: emailController,
                  prefixIcon: Icon(Icons.email_outlined),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(passFocusNode),
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Vui lòng nhập email';
                    } else if (!RegExp(
                      AppConstant.regEmail,
                    ).hasMatch(emailController.text)) {
                      return 'Email không đúng định dạng';
                    }
                    return null;
                  },
                ),
                PasswordFieldWidget(
                  label: Text('Mật khẩu'),
                  controller: passwordController,
                  focusNode: passFocusNode,
                  validator: (p0) => (p0 == null || p0.isEmpty)
                      ? 'Vui lòng nhập mật khẩu'
                      : null,
                ),
                SizedBox(height: 5),
                BlocListener<AuthBloc, AuthState>(
                  listenWhen: (previous, current) {
                    final wasAuth = previous.maybeMap(
                      authenticated: (_) => true,
                      error: (_) => true,
                      orElse: () => false,
                    );

                    final isAuth = current.maybeMap(
                      authenticated: (_) => true,
                      error: (_) => true,
                      orElse: () => false,
                    );

                    return wasAuth != isAuth;
                  },
                  listener: (context, state) {
                    state.mapOrNull(
                      authenticated: (_) {
                        context.read<NotificationCubit>().success(
                          'Đăng nhập thành công',
                        );
                        context.go(RouterPaths.home);
                      },
                      error: (state) {
                        context.read<NotificationCubit>().error(state.message);
                      },
                    );
                  },
                  child: SizedBox(
                    width: size.width / 2,
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final isLoading = state.maybeMap(
                          loading: (_) => true,
                          orElse: () => false,
                        );

                        return CustomButton(
                          onTap: isLoading
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<AuthBloc>().add(
                                      AuthEvent.login(
                                        email: emailController.text,
                                        pass: passwordController.text,
                                      ),
                                    );
                                  }
                                },
                          colorBackground: Colors.blue,
                          textButton: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Đăng nhập',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                ),

                SizedBox(
                  width: size.width / 2,
                  child: CustomButton(
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                        return;
                      }
                      context.go(RouterPaths.home);
                    },
                    colorBackground: Colors.transparent,
                    colorBorder: Colors.blue,
                    textButton: Text(
                      'Quay lại',
                      style: TextStyle(fontWeight: FontWeight(600)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
