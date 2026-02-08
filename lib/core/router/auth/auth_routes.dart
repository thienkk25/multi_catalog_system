import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/auth/presentation/presentation.dart';

class AuthRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      path: '/login',
      name: RouterNames.login,
      builder: (_, state) => LoginPage(),
      redirect: (context, state) {
        getIt<AuthBloc>().add(const AuthEvent.checkAuthenticated());
        final authState = context.read<AuthBloc>().state;
        if (authState.maybeMap(
          authenticated: (_) => true,
          orElse: () => false,
        )) {
          return '/';
        }
        return null;
      },
    ),
  ];
}
