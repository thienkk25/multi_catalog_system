import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_catalog_system/core/config/di/injection.dart';
import 'package:multi_catalog_system/core/router/router_names.dart';
import 'package:multi_catalog_system/features/api_key_management/domain/entries/api_key_entry.dart';
import 'package:multi_catalog_system/features/api_key_management/presentation/presentation.dart';

class ApiKeyManagementRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      path: RouterPaths.apiKeyManagement,
      name: RouterNames.apiKeyManagement,
      builder: (context, state) => const ApiKeyManagementPage(),
    ),

    GoRoute(
      path: RouterPaths.apiKeyForm,
      name: RouterNames.apiKeyForm,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return BlocProvider.value(
          value: data['bloc'] as ApiKeyBloc,
          child: ApiKeyManagementFormPage(
            type: data['type'] as ApiKeyManagementFormPageType,
            entry: data['entry'] as ApiKeyEntry?,
          ),
        );
      },
    ),

    GoRoute(
      path: RouterPaths.apiKeyDetail,
      name: RouterNames.apiKeyDetail,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final entry = state.extra as ApiKeyEntry;
        return BlocProvider(
          create: (_) => getIt<ApiKeyBloc>()..add(ApiKeyEvent.getById(id: id)),
          child: ApiKeyManagementFormPage(
            type: ApiKeyManagementFormPageType.detail,
            entry: entry,
          ),
        );
      },
    ),
  ];
}
