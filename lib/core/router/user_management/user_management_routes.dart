import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/config/di/injection.dart';
import 'package:multi_catalog_system/core/domain/entities/auth/user_entry.dart';
import 'package:multi_catalog_system/core/domain/entities/domain/domain_ref_entry.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
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
          child: UserManagementFormPage(entry: data['entry'] as UserEntry?),
        );
      },
    ),
    GoRoute(
      path: RouterPaths.userManagementAddDomains,
      name: RouterNames.userManagementAddDomains,
      builder: (context, state) {
        final fields = (state.extra as List?)?.cast<DomainRefEntry>() ?? [];

        return UserManagementAddDomainsPage(fields: fields);
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
