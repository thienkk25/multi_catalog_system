class RouterNames {
  // Core
  static const String home = 'home';
  static const String login = 'login';
  static const String profile = 'profile';

  // Import
  static const String importFile = 'importFile';

  // Domain
  static const String domains = 'domains';
  static const String domainForm = 'domainForm';
  static const String domainDetail = 'domainDetail';

  // Category-group
  static const String categoryGroups = 'categoryGroups';
  static const String categoryGroupForm = 'categoryGroupForm';
  static const String categoryGroupDetail = 'categoryGroupDetail';

  // system_history_management
  static const String systemHistoryManagement = 'systemHistoryManagement';
  static const String systemHistoryManagementDetail =
      'systemHistoryManagementDetail';

  // api_key_management
  static const String apiKeyManagement = 'apiKeyManagement';
  static const String apiKeyForm = 'apiKeyForm';
  static const String apiKeyDetail = 'apiKeyDetail';
}

class RouterPaths {
  // Core
  static const String home = '/';
  static const String login = '/login';
  static const String profile = '/profile';

  // Import
  static const String importFile = '/import-file';

  // Domain
  static const String domains = '/domains';
  static const String domainForm = '/domains/form';
  static const String domainDetail = '/domains/:id';

  // Category-group
  static const String categoryGroups = '/category-groups';
  static const String categoryGroupForm = '/category-groups/form';
  static const String categoryGroupDetail = '/category-groups/:id';

  // system_history_management
  static const String systemHistoryManagement = '/system-history-management';
  static const String systemHistoryManagementDetail =
      '/system-history-management/:id';

  // api_key_management
  static const String apiKeyManagement = '/api-key-management';
  static const String apiKeyForm = '/api-key-management/form';
  static const String apiKeyDetail = '/api-key-management/:id';
}
