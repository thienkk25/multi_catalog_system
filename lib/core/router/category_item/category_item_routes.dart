import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/config/di/injection.dart';
import 'package:multi_catalog_system/core/utils/extensions/bloc_extension.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/features/category_item/presentation/presentation.dart';
import 'package:multi_catalog_system/features/legal_document/presentation/bloc/legal_document_bloc.dart';

class CategoryItemRoutes {
  static List<RouteBase> routes = [
    ShellRoute(
      builder: (context, state, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<CategoryItemBloc>()),
            BlocProvider(create: (_) => getIt<CategoryItemVersionBloc>()),
          ],
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/category-items',
          name: RouterNames.categoryItem,
          builder: (context, state) => const CategoryItemPage(),
          routes: [
            GoRoute(
              path: '/id/:id',
              name: RouterNames.categoryItemDetail,
              builder: (context, state) {
                final id = state.pathParameters['id']!;

                context.itemBloc.add(CategoryItemEvent.getById(id: id));

                return CategoryItemDetailPage();
              },
            ),

            GoRoute(
              path: '/form',
              name: RouterNames.categoryItemForm,
              builder: (context, state) {
                final mode = state.uri.queryParameters['mode']!;
                final itemId = state.uri.queryParameters['itemId'];
                final versionId = state.uri.queryParameters['versionId'];

                return CategoryItemFormPage(
                  mode: CategoryItemFormMode.values.byName(mode),
                  itemId: itemId,
                  versionId: versionId,
                );
              },
            ),

            GoRoute(
              path: '/form/add-legal-documents',
              name: RouterNames.categoryItemFormAddLegalDocuments,
              builder: (context, state) {
                return BlocProvider(
                  create: (_) => getIt<LegalDocumentBloc>(),
                  child: const CategoryItemAddLegalDocumentsPage(),
                );
              },
            ),
          ],
        ),
      ],
    ),
  ];
}
