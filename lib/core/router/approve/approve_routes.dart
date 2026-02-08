import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/config/di/injection.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/features/approve/presentation/presentation.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_bloc.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_event.dart';

class ApproveRoutes {
  static List<RouteBase> routes = [
    ShellRoute(
      builder: (context, state, child) {
        return BlocProvider(
          create: (_) => getIt<CategoryItemVersionBloc>(),
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/approve',
          name: RouterNames.approve,
          builder: (context, state) {
            context.read<CategoryItemVersionBloc>().add(
              const CategoryItemVersionEvent.getAll(),
            );
            return const ApprovePage();
          },
          routes: [
            GoRoute(
              path: '/id/:id',
              name: RouterNames.approveDetail,
              builder: (context, state) => const ApprovePage(),
            ),
          ],
        ),
      ],
    ),
  ];
}
