import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/features/features.dart';
import 'router_names.dart';

class AppRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(path: RouterNames.home, builder: (_, state) => HomePage()),
      GoRoute(
        path: RouterNames.login,
        builder: (_, state) => LoginPage(),
        redirect: (context, state) {
          context.read<AuthBloc>().add(const AuthEvent.checkAuthenticated());
          final authState = context.read<AuthBloc>().state;
          if (authState.maybeMap(
            authenticated: (_) => true,
            orElse: () => false,
          )) {
            return RouterNames.home;
          }
          return null;
        },
      ),
    ],
    errorBuilder: (_, state) => const NotFoundPage(),
  );
}
