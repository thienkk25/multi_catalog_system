import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/system_history_management/presentation/bloc/system_history_bloc.dart';
import 'package:multi_catalog_system/features/system_history_management/presentation/pages/system_history_page.dart';

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
  ];
}
