import 'package:flutter/material.dart';
import 'package:luna_arc_sync/l10n/app_localizations.dart';
import 'package:luna_arc_sync/core/localization/locale_notifier.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final bool _isDarkMode = false; // Placeholder for theme state
  bool _notificationsEnabled = true; // Placeholder for notifications state

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeNotifier = context.watch<LocaleNotifier>();
    // final themeNotifier = context.watch<ThemeNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.settingsPageTitle ?? ''),
      ),
      body: ListView(
        children: [
          // Language Setting
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n?.languageSettingTitle ?? ''),
            subtitle: Text((localeNotifier.locale?.languageCode ?? 'en') == 'en' ? 'English' : '中文'),
            onTap: () {
              _showLanguagePickerDialog(context, localeNotifier);
            },
          ),
          const Divider(),

          // Database Import/Export
          ListTile(
            leading: const Icon(Icons.cloud_upload),
            title: Text(l10n?.importDatabaseTitle ?? ''),
            onTap: () {
              // TODO: Implement database import
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Database import not yet implemented')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.cloud_download),
            title: Text(l10n?.exportDatabaseTitle ?? ''),
            onTap: () {
              // TODO: Implement database export
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Database export not yet implemented')),
              );
            },
          ),
          const Divider(),

          // Theme Setting (Dark Mode)
          //SwitchListTile(
           // secondary: const Icon(Icons.brightness_4),
           // title: Text(l10n?.darkModeTitle ?? ''),
            //value: themeNotifier.themeMode == ThemeMode.dark,
            //onChanged: (bool value) {
              //themeNotifier.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
           // },
          //),
          const Divider(),

          // Notifications Setting
          SwitchListTile(
            secondary: const Icon(Icons.notifications),
            title: Text(l10n?.notificationsTitle ?? ''),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
                // TODO: Implement actual notification settings logic
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Notifications ${value ? 'enabled' : 'disabled'}')),
                );
              });
            },
          ),
          const Divider(),

          // Clear Cache
          ListTile(
            leading: const Icon(Icons.cleaning_services),
            title: Text(l10n?.clearCacheTitle ?? ''),
            onTap: () {
              // TODO: Implement cache clearing logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared (placeholder)')),
              );
            },
          ),
          const Divider(),

          // About
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(l10n?.aboutTitle ?? ''),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'LunaArcSync',
                applicationVersion: l10n?.appVersion ?? '', // Placeholder version
                applicationLegalese: l10n?.appLegalese ?? '', // Placeholder copyright
                children: [
                  Text(l10n?.appInfoPlaceholder ?? ''),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void _showLanguagePickerDialog(BuildContext context, LocaleNotifier localeNotifier) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)?.languageSettingTitle ?? ''),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('English'),
                onTap: () {
                  localeNotifier.setLocale(const Locale('en'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('中文'),
                onTap: () {
                  localeNotifier.setLocale(const Locale('zh'));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}