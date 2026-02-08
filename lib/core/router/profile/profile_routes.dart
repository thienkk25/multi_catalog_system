import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/config/di/injection.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/core/domain/entities/auth/user_entry.dart';
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
            context.read<ProfileBloc>().add(const ProfileEvent.getProfile());
            return ProfilePage();
          },
          routes: [
            GoRoute(
              path: '/form',
              name: RouterNames.profileForm,
              builder: (context, state) {
                final data = state.extra as Map<String, dynamic>;
                return ProfileFormPage(entry: data['entry'] as UserEntry);
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
