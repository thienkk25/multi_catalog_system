import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/config/di/injection.dart';
import 'package:multi_catalog_system/core/domain/entities/auth/user_entry.dart';
import 'package:multi_catalog_system/core/domain/entities/domain/domain_ref_entry.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/features/user_management/presentation/presentation.dart';

class UserManagementRoutes {
  static List<RouteBase> routes = [
    ShellRoute(
      builder: (context, state, child) {
        return BlocProvider(
          create: (_) => getIt<UserManagementBloc>(),
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/user-management',
          name: RouterNames.userManagement,
          builder: (context, state) => const UserManagementPage(),
          routes: [
            GoRoute(
              path: '/:id',
              name: RouterNames.userManagementDetail,
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                context.read<UserManagementBloc>().add(
                  UserManagementEvent.getById(id: id),
                );
                return const UserManagementDetailPage();
              },
            ),
            GoRoute(
              path: '/form',
              name: RouterNames.userManagementForm,
              builder: (context, state) {
                final data = state.extra as Map<String, dynamic>;
                return UserManagementFormPage(
                  entry: data['entry'] as UserEntry?,
                );
              },
            ),
            GoRoute(
              path: '/add-domains',
              name: RouterNames.userManagementAddDomains,
              builder: (context, state) {
                final fields =
                    (state.extra as List?)?.cast<DomainRefEntry>() ?? [];

                return UserManagementAddDomainsPage(fields: fields);
              },
            ),
          ],
        ),
      ],
    ),
  ];
}
