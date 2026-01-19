import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/config/di/injection.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/core/domain/entities/auth/user_entry.dart';
import 'package:multi_catalog_system/features/profile/presentation/presentation.dart';

class ProfileRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      path: RouterPaths.profile,
      name: RouterNames.profile,
      builder: (context, state) => BlocProvider(
        create: (_) =>
            getIt<ProfileBloc>()..add(const ProfileEvent.getProfile()),
        child: ProfilePage(),
      ),
    ),
    GoRoute(
      path: RouterPaths.profileForm,
      name: RouterNames.profileForm,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return BlocProvider.value(
          value: data['bloc'] as ProfileBloc,
          child: ProfileFormPage(entry: data['entry'] as UserEntry),
        );
      },
    ),
    GoRoute(
      path: RouterPaths.changePassword,
      name: RouterNames.changePassword,
      builder: (context, state) {
        final bloc = state.extra as ProfileBloc;
        return BlocProvider.value(
          value: bloc,
          child: ProfileChangePasswordPage(),
        );
      },
    ),
  ];
}
