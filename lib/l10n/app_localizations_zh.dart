// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get settingsPageTitle => '设置';

  @override
  String get languageSettingTitle => '语言';

  @override
  String get languageSettingSubtitle => '中文';

  @override
  String get importDatabaseTitle => '导入数据库';

  @override
  String get exportDatabaseTitle => '导出数据库';

  @override
  String get darkModeTitle => '深色模式';

  @override
  String get notificationsTitle => '通知';

  @override
  String get clearCacheTitle => '清除缓存';

  @override
  String get aboutTitle => '关于';

  @override
  String get appVersion => '1.0.0';

  @override
  String get appLegalese => '© 2025 你的公司';

  @override
  String get appInfoPlaceholder => '这是应用程序信息的占位符。';

  @override
  String get overviewAppBarTitle => '概览';

  @override
  String get overviewRecentActivity => '最近活动';

  @override
  String get logoutButtonTooltip => '登出';
}
