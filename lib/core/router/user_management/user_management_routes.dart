import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/config/di/injection.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/features/user_management/domain/entities/user_management_entry.dart';
import 'package:multi_catalog_system/features/user_management/presentation/presentation.dart';

class UserManagementRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      path: RouterPaths.userManagement,
      name: RouterNames.userManagement,
      builder: (context, state) => const UserManagementPage(),
    ),
    GoRoute(
      path: RouterPaths.userManagementForm,
      name: RouterNames.userManagementForm,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return BlocProvider.value(
          value: data['bloc'] as UserManagementBloc,
          child: UserManagementFormPage(
            entry: data['entry'] as UserManagementEntry?,
          ),
        );
      },
    ),
    GoRoute(
      path: RouterPaths.userManagementDetail,
      name: RouterNames.userManagementDetail,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return BlocProvider(
          create: (_) =>
              getIt<UserManagementBloc>()
                ..add(UserManagementEvent.getById(id: id)),
          child: const UserManagementDetailPage(),
        );
      },
    ),
  ];
}
