import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:multi_catalog_system/features/auth/presentation/bloc/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoleBasedWidget extends StatelessWidget {
  final List<String> permission;
  final Widget child;

  const RoleBasedWidget({
    super.key,
    required this.permission,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) => current.maybeMap(
        orElse: () => false,
        authenticated: (_) => true,
        unauthenticated: (_) => true,
      ),
      builder: (context, state) => FutureBuilder<bool>(
        future: _hasPermission(permission),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == false) {
            return const SizedBox.shrink();
          }
          return child;
        },
      ),
    );
  }

  Future<bool> _hasPermission(List<String> permission) async {
    final pref = await SharedPreferences.getInstance();
    final userRoleString = pref.getString('CACHED_USER_ROLE');
    if (userRoleString == null) return false;

    final userRoleJson = jsonDecode(userRoleString);
    final userRole = userRoleJson['code'];

    return userRole != null && permission.contains(userRole);
  }
}
