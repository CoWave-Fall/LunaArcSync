// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settingsPageTitle => 'Settings';

  @override
  String get languageSettingTitle => 'Language';

  @override
  String get languageSettingSubtitle => 'English';

  @override
  String get importDatabaseTitle => 'Import Database';

  @override
  String get exportDatabaseTitle => 'Export Database';

  @override
  String get darkModeTitle => 'Dark Mode';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get clearCacheTitle => 'Clear Cache';

  @override
  String get aboutTitle => 'About';

  @override
  String get appVersion => '1.0.0';

  @override
  String get appLegalese => '© 2025 Your Company';

  @override
  String get appInfoPlaceholder =>
      'This is a placeholder for application information.';

  @override
  String get overviewAppBarTitle => 'Overview';

  @override
  String get overviewRecentActivity => 'Recent Activity';
}
