import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/notifications/notification_cubit.dart';
import 'package:multi_catalog_system/features/api_key_management/presentation/bloc/api_key_bloc.dart';
import 'package:multi_catalog_system/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:multi_catalog_system/features/category_group/presentation/bloc/category_group_bloc.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_bloc.dart';
import 'package:multi_catalog_system/features/category_item/presentation/bloc/category_item_version_bloc.dart';
import 'package:multi_catalog_system/features/domain_management/presentation/bloc/domain_management_bloc.dart';
import 'package:multi_catalog_system/features/import_file/presentation/bloc/import_file_bloc.dart';
import 'package:multi_catalog_system/features/legal_document/presentation/bloc/document_file_cubit.dart';
import 'package:multi_catalog_system/features/legal_document/presentation/bloc/legal_document_bloc.dart';
import 'package:multi_catalog_system/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:multi_catalog_system/features/system_history_management/presentation/bloc/system_history_bloc.dart';
import 'package:multi_catalog_system/features/user_management/presentation/bloc/user_management_bloc.dart';

extension BlocX on BuildContext {
  NotificationCubit get notificationCubit => read<NotificationCubit>();
  ApiKeyBloc get apiKeyBloc => read<ApiKeyBloc>();
  AuthBloc get authBloc => read<AuthBloc>();
  CategoryGroupBloc get groupBloc => read<CategoryGroupBloc>();
  CategoryItemBloc get itemBloc => read<CategoryItemBloc>();
  CategoryItemVersionBloc get itemVersionBloc =>
      read<CategoryItemVersionBloc>();
  DomainManagementBloc get domainManagementBloc => read<DomainManagementBloc>();
  ImportFileBloc get importFileBloc => read<ImportFileBloc>();
  LegalDocumentBloc get legalDocumentBloc => read<LegalDocumentBloc>();
  DocumentFileCubit get documentFileCubit => read<DocumentFileCubit>();
  ProfileBloc get profileBloc => read<ProfileBloc>();
  SystemHistoryBloc get systemHistoryBloc => read<SystemHistoryBloc>();
  UserManagementBloc get userManagementBloc => read<UserManagementBloc>();
}
