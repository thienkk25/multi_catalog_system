import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/config/di/injection.dart';
import 'package:multi_catalog_system/core/navigation/shells/home_shell.dart';
import 'package:multi_catalog_system/core/utils/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/features/features.dart';

import 'api_key_management/api_key_management_routes.dart';
import 'approve/approve_routes.dart';
import 'auth/auth_routes.dart';
import 'category_group/category_group_routes.dart';
import 'category_item/category_item_routes.dart';
import 'domain_management/domain_management_routes.dart';
import 'import_export_file/import_file_routes.dart';
import 'legal_document/legal_document_routes.dart';
import 'profile/profile_routes.dart';
import 'system_history_management/system_history_management_routes.dart';
import 'user_management/user_management_routes.dart';

class AppRouter {
  static final router = GoRouter(
    refreshListenable: _GoRouterRefreshNotifier(getIt<AuthBloc>().stream),
    initialLocation: '/domains',
    routes: [
      ...AuthRoutes.routes,
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomeShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(routes: DomainManagementRoutes.routes),
          StatefulShellBranch(routes: CategoryGroupRoutes.routes),
          StatefulShellBranch(routes: CategoryItemRoutes.routes),
          StatefulShellBranch(routes: LegalDocumentRoutes.routes),
          StatefulShellBranch(routes: ImportFileRoutes.routes),
          StatefulShellBranch(routes: ApproveRoutes.routes),
          StatefulShellBranch(routes: UserManagementRoutes.routes),
          StatefulShellBranch(routes: ApiKeyManagementRoutes.routes),
          StatefulShellBranch(routes: SystemHistoryManagementRoutes.routes),
          StatefulShellBranch(routes: ProfileRoutes.routes),
        ],
      ),
    ],
    redirect: (context, state) {
      final authState = context.authBloc.state;

      final isLoading = authState.maybeMap(
        initial: (_) => true,
        loading: (_) => true,
        orElse: () => false,
      );

      if (isLoading) return null;

      final isLoggedIn = authState.maybeMap(
        authenticated: (_) => true,
        orElse: () => false,
      );

      final isLoginRoute = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoginRoute) {
        return '/login';
      }

      if (isLoggedIn && isLoginRoute) {
        return '/domains';
      }

      return null;
    },
    errorBuilder: (_, state) => const NotFoundPage(),
  );
}

class _GoRouterRefreshNotifier extends ChangeNotifier {
  _GoRouterRefreshNotifier(Stream<dynamic> stream) {
    _sub = stream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
