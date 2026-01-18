class RouterNames {
  // Core
  static const String home = 'home';
  static const String login = 'login';

  // Profile
  static const String profile = 'profile';
  static const String profileForm = 'profileForm';
  static const String changePassword = 'changePassword';

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
  static const String apiKeyAddDomains = 'apiKeyAddDomains';

  // legal_document
  static const String legalDocument = 'legalDocument';
  static const String legalDocumentForm = 'legalDocumentForm';
  static const String legalDocumentDetail = 'legalDocumentDetail';

  // category_item
  static const String categoryItem = 'categoryItem';
  static const String categoryItemForm = 'categoryItemForm';
  static const String categoryItemDetail = 'categoryItemDetail';
  static const String categoryItemAddLegalDocuments =
      'categoryItemAddLegalDocuments';

  // user_management
  static const String userManagement = 'userManagement';
  static const String userManagementForm = 'userManagementForm';
  static const String userManagementDetail = 'userManagementDetail';
}

class RouterPaths {
  // Core
  static const String home = '/';
  static const String login = '/login';

  // Profile
  static const String profile = '/profile';
  static const String profileForm = '/profile/form';
  static const String changePassword = '/profile/change-password';

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
  static const String apiKeyAddDomains = '/api-key-management/add-domains';

  // legal_document
  static const String legalDocument = '/legal-document';
  static const String legalDocumentForm = '/legal-document/form';
  static const String legalDocumentDetail = '/legal-document/:id';

  // category_item
  static const String categoryItem = '/category-item';
  static const String categoryItemForm = '/category-item/form';
  static const String categoryItemDetail = '/category-item/:id';
  static const String categoryItemAddLegalDocuments =
      '/category-item/add-legal-documents';

  // user_management
  static const String userManagement = '/user-management';
  static const String userManagementForm = '/user-management/form';
  static const String userManagementDetail = '/user-management/:id';
}
