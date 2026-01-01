class RouterNames {
  // Core
  static const String home = 'home';
  static const String login = 'login';
  static const String profile = 'profile';

  // Import
  static const String importFile = 'importFile';

  // Domain
  static const String domains = 'domains';
  static const String domainCreate = 'domainCreate';
  static const String domainDetail = 'domainDetail';
  static const String domainUpdate = 'domainEdit';
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
  static const String domainCreate = '/domains/create';
  static const String domainDetail = '/domains/:id';
  static const String domainUpdate = '/domains/:id/update';
}
