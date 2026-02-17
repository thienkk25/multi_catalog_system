import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/config/di/injection.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/features/profile/presentation/presentation.dart';

class ProfileRoutes {
  static List<RouteBase> routes = [
    ShellRoute(
      builder: (context, state, child) {
        return BlocProvider(create: (_) => getIt<ProfileBloc>(), child: child);
      },
      routes: [
        GoRoute(
          path: '/profile',
          name: RouterNames.profile,
          builder: (context, state) {
            return ProfilePage();
          },
          routes: [
            GoRoute(
              path: '/form',
              name: RouterNames.profileForm,
              builder: (context, state) {
                return ProfileFormPage();
              },
            ),
            GoRoute(
              path: '/change-password',
              name: RouterNames.changePassword,
              builder: (context, state) {
                return ProfileChangePasswordPage();
              },
            ),
          ],
        ),
      ],
    ),
  ];
}
