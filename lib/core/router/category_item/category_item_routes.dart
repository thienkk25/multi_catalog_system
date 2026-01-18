import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/config/di/injection.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/features/category_item/domain/entities/category_item_entry.dart';
import 'package:multi_catalog_system/features/category_item/presentation/presentation.dart';
import 'package:multi_catalog_system/features/legal_document/presentation/bloc/legal_document_bloc.dart';

class CategoryItemRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      path: RouterPaths.categoryItem,
      name: RouterNames.categoryItem,
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<CategoryItemBloc>(),
        child: const CategoryItemPage(),
      ),
    ),
    GoRoute(
      path: RouterPaths.categoryItemForm,
      name: RouterNames.categoryItemForm,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return BlocProvider.value(
          value: data['bloc'] as CategoryItemBloc,
          child: CategoryItemFormPage(
            entry: data['entry'] as CategoryItemEntry?,
          ),
        );
      },
    ),
    GoRoute(
      path: RouterPaths.categoryItemAddLegalDocuments,
      name: RouterNames.categoryItemAddLegalDocuments,
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<LegalDocumentBloc>(),
        child: const CategoryItemAddLegalDocumentsPage(),
      ),
    ),
    GoRoute(
      path: RouterPaths.categoryItemDetail,
      name: RouterNames.categoryItemDetail,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return BlocProvider.value(
          value: data['bloc'] as CategoryItemBloc,
          child: CategoryItemDetailPage(
            entry: data['entry'] as CategoryItemEntry,
          ),
        );
      },
    ),
  ];
}
