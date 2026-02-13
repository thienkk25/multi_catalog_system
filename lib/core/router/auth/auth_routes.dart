import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/config/di/injection.dart';
import 'package:multi_catalog_system/core/utils/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/features/auth/presentation/presentation.dart';

class AuthRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      path: '/login',
      name: RouterNames.login,
      builder: (_, state) => LoginPage(),
      redirect: (context, state) {
        getIt<AuthBloc>().add(const AuthEvent.checkAuthenticated());
        final authState = context.authBloc.state;
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
