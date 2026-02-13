import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/config/di/injection.dart';
import 'package:multi_catalog_system/core/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/features/category_group/presentation/presentation.dart';

class CategoryGroupRoutes {
  static List<RouteBase> get routes => [
    ShellRoute(
      builder: (context, state, child) {
        return BlocProvider(
          create: (_) => getIt<CategoryGroupBloc>(),
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/category-groups',
          name: RouterNames.categoryGroups,
          builder: (context, state) => const CategoryGroupPage(),
          routes: [
            GoRoute(
              path: '/id/:id',
              name: RouterNames.categoryGroupDetail,
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                context.groupBloc.add(CategoryGroupEvent.getById(id: id));
                return CategoryGroupDetailPage();
              },
            ),
            GoRoute(
              path: '/form',
              name: RouterNames.categoryGroupForm,
              builder: (context, state) {
                final mode = state.uri.queryParameters['mode']!;
                final id = state.uri.queryParameters['id'];
                return CategoryGroupFormPage(
                  mode: CategoryGroupFormType.values.byName(mode),
                  id: id,
                );
              },
            ),
          ],
        ),
      ],
    ),
  ];
}
