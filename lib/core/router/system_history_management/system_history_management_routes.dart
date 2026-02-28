import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/config/di/injection.dart';
import 'package:multi_catalog_system/core/utils/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/features/system_history_management/presentation/presentation.dart';

class SystemHistoryManagementRoutes {
  static List<RouteBase> routes = [
    ShellRoute(
      builder: (context, state, child) {
        return BlocProvider(
          create: (_) => getIt<SystemHistoryBloc>(),
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/system-history-management',
          name: RouterNames.systemHistoryManagement,
          builder: (context, state) {
            return const SystemHistoryManagementPage();
          },
          routes: [
            GoRoute(
              path: 'id/:id',
              name: RouterNames.systemHistoryManagementDetail,
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                context.systemHistoryBloc.add(
                  SystemHistoryEvent.getById(id: id),
                );
                return SystemHistoryManagementDetailPage();
              },
            ),
          ],
        ),
      ],
    ),
  ];
}
