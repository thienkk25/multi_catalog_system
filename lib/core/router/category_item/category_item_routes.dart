import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/config/di/injection.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/core/utils/extensions/auth_permission_extension.dart';
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
          path: RouterPaths.categoryItem,
          name: RouterNames.categoryItem,
          builder: (context, state) => const CategoryItemPage(),
        ),

        GoRoute(
          path: RouterPaths.categoryItemDetail,
          name: RouterNames.categoryItemDetail,
          builder: (context, state) {
            final id = state.pathParameters['id']!;

            context.read<CategoryItemBloc>().add(
              CategoryItemEvent.getById(id: id),
            );

            return CategoryItemDetailPage();
          },
        ),

        GoRoute(
          path: RouterPaths.categoryItemFormCreate,
          name: RouterNames.categoryItemFormCreate,
          builder: (context, state) {
            return const CategoryItemFormPage();
          },
        ),

        GoRoute(
          path: RouterPaths.categoryItemFormAddLegalDocuments,
          name: RouterNames.categoryItemFormAddLegalDocuments,
          builder: (context, state) {
            return BlocProvider(
              create: (_) => getIt<LegalDocumentBloc>(),
              child: const CategoryItemAddLegalDocumentsPage(),
            );
          },
        ),

        GoRoute(
          path: RouterPaths.categoryItemFormUpdate,
          name: RouterNames.categoryItemFormUpdate,
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            final isAdmin = context.hasRole('admin');

            if (isAdmin) {
              context.read<CategoryItemBloc>().add(
                CategoryItemEvent.getById(id: id),
              );
            } else {
              context.read<CategoryItemVersionBloc>().add(
                CategoryItemVersionEvent.getById(id: id),
              );
            }

            return const CategoryItemFormPage();
          },
        ),
      ],
    ),
  ];
}
