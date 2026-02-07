import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:multi_catalog_system/features/auth/presentation/bloc/auth_state.dart';

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
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return state.maybeMap(
          authenticated: (s) {
            final roleCode = s.entry.role?.code;

            if (roleCode == null || !permission.contains(roleCode)) {
              return const SizedBox.shrink();
            }

            return child;
          },
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }
}
