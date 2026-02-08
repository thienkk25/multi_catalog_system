import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/config/di/injection.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/features/api_key_management/domain/entities/api_key_entry.dart';
import 'package:multi_catalog_system/features/api_key_management/presentation/presentation.dart';

class ApiKeyManagementRoutes {
  static List<RouteBase> routes = [
    ShellRoute(
      builder: (context, state, child) {
        return BlocProvider(create: (_) => getIt<ApiKeyBloc>(), child: child);
      },
      routes: [
        GoRoute(
          path: '/api-keys',
          name: RouterNames.apiKeyManagement,
          builder: (context, state) => const ApiKeyManagementPage(),
          routes: [
            GoRoute(
              path: '/:id',
              name: RouterNames.apiKeyDetail,
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                context.read<ApiKeyBloc>().add(ApiKeyEvent.getById(id: id));
                return ApiKeyManagementDetailPage();
              },
            ),
            GoRoute(
              path: '/form',
              name: RouterNames.apiKeyForm,
              builder: (context, state) {
                final data = state.extra as Map<String, dynamic>;
                return ApiKeyManagementFormPage(
                  entry: data['entry'] as ApiKeyEntry?,
                );
              },
              routes: [
                GoRoute(
                  path: '/add-domains',
                  name: RouterNames.apiKeyAddDomains,
                  builder: (context, state) {
                    final fields = state.extra as List<String>;
                    return ApiKeyManagementAddDomainsPage(fields: fields);
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ];
}
