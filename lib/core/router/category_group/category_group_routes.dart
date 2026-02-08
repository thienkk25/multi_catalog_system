import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/config/di/injection.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/features/category_group/domain/entities/category_group_entry.dart';
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
                context.read<CategoryGroupBloc>().add(
                  CategoryGroupEvent.getById(id: id),
                );
                return CategoryGroupDetailPage();
              },
            ),
            GoRoute(
              path: '/form',
              name: RouterNames.categoryGroupForm,
              builder: (context, state) {
                final data = state.extra as Map<String, dynamic>;
                return CategoryGroupFormPage(
                  entry: data['entry'] as CategoryGroupEntry?,
                );
              },
            ),
          ],
        ),
      ],
    ),
  ];
}
