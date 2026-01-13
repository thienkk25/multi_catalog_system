import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/config/di/injection.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/features/system_history_management/domain/entities/system_history_entry.dart';
import 'package:multi_catalog_system/features/system_history_management/presentation/presentation.dart';

class SystemHistoryManagementRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      path: RouterPaths.systemHistoryManagement,
      name: RouterNames.systemHistoryManagement,
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<SystemHistoryBloc>(),
        child: const SystemHistoryPage(),
      ),
    ),
    GoRoute(
      path: RouterPaths.systemHistoryManagementDetail,
      name: RouterNames.systemHistoryManagementDetail,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final entry = state.extra as SystemHistoryEntry;
        return BlocProvider(
          create: (_) =>
              getIt<SystemHistoryBloc>()
                ..add(SystemHistoryEvent.getById(id: id)),
          child: SystemHistoryDetailView(log: entry),
        );
      },
    ),
  ];
}
