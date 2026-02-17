import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/config/di/injection.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/core/utils/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_bloc.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_event.dart';
import 'package:multi_catalog_system/features/category_item/presentation/pages/approve_page.dart';

class ApproveRoutes {
  static List<RouteBase> routes = [
    ShellRoute(
      builder: (context, state, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<CategoryItemVersionBloc>()),
          ],
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/approve',
          name: RouterNames.approve,
          builder: (context, state) {
            context.itemVersionBloc.add(
              const CategoryItemVersionEvent.getAll(),
            );
            return const ApprovePage();
          },
        ),
      ],
    ),
  ];
}
