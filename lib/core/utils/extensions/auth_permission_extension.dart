import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/domain/entities/auth/user_entry.dart';
import 'package:multi_catalog_system/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:multi_catalog_system/features/auth/presentation/bloc/auth_state.dart';

extension AuthPermissionX on BuildContext {
  UserEntry? get currentUser {
    final state = read<AuthBloc>().state;
    return state.maybeMap(authenticated: (s) => s.entry, orElse: () => null);
  }

  String? get roleCode => currentUser?.role?.code;

  bool hasRole(String role) => roleCode == role;

  bool hasAnyRole(List<String> roles) =>
      roleCode != null && roles.contains(roleCode);
}
