import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luna_arc_sync/core/di/injection.dart';
import 'package:luna_arc_sync/l10n/app_localizations.dart';
import 'package:luna_arc_sync/core/localization/locale_notifier.dart';
import 'package:luna_arc_sync/presentation/settings/cubit/data_transfer_cubit.dart';
import 'package:luna_arc_sync/presentation/settings/cubit/data_transfer_state.dart';
import 'package:luna_arc_sync/presentation/settings/notifiers/grid_settings_notifier.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DataTransferCubit>(),
      child: const SettingsView(),
    );
  }
}

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _notificationsEnabled = true; // Placeholder

  void _handleExport(BuildContext context) {
    context.read<DataTransferCubit>().exportData();
  }

  Future<void> _handleImport(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );

    if (result != null && result.files.single.bytes != null) {
      context.read<DataTransferCubit>().importData(result.files.single);
    } else {
      // User canceled the picker or file is invalid
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No file selected or file is invalid.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeNotifier = context.watch<LocaleNotifier>();

    return BlocListener<DataTransferCubit, DataTransferState>(
      listener: (context, state) {
        state.whenOrNull(
          exportSuccess: (data) async {
            final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').replaceAll('.', '-');
            final fileName = 'LunaArcSync_MyData_Export_$timestamp.zip';
            await FileSaver.instance.saveFile(
              name: fileName,
              bytes: data,
              mimeType: MimeType.zip,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Export successful!'), backgroundColor: Colors.green),
            );
            context.read<DataTransferCubit>().reset();
          },
          importSuccess: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Import successful! Please restart the app.'), backgroundColor: Colors.green),
            );
            context.read<DataTransferCubit>().reset();
          },
          failure: (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Operation failed: $error'), backgroundColor: Colors.red),
            );
            context.read<DataTransferCubit>().reset();
          },
        );
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text(l10n.settingsPageTitle),
            ),
            body: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(l10n.languageSettingTitle),
                  subtitle: Text((localeNotifier.locale?.languageCode ?? 'en') == 'en' ? 'English' : '中文'),
                  onTap: () => _showLanguagePickerDialog(context, localeNotifier),
                ),
                const Divider(),
                Consumer<GridSettingsNotifier>(
                  builder: (context, notifier, child) {
                    return ListTile(
                      leading: const Icon(Icons.grid_view),
                      title: const Text('Grid Columns'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Columns: ${notifier.crossAxisCount}'),
                          Slider(
                            value: notifier.crossAxisCount.toDouble(),
                            min: 2,
                            max: 5,
                            divisions: 3,
                            label: notifier.crossAxisCount.toString(),
                            onChanged: (value) => notifier.updateCrossAxisCount(value.toInt()),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.cloud_upload),
                  title: Text(l10n.importDatabaseTitle),
                  onTap: () => _handleImport(context),
                ),
                ListTile(
                  leading: const Icon(Icons.cloud_download),
                  title: Text(l10n.exportDatabaseTitle),
                  onTap: () => _handleExport(context),
                ),
                const Divider(),
                SwitchListTile(
                  secondary: const Icon(Icons.notifications),
                  title: Text(l10n.notificationsTitle),
                  value: _notificationsEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.cleaning_services),
                  title: Text(l10n.clearCacheTitle),
                  onTap: () {},
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: Text(l10n.aboutTitle),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'LunaArcSync',
                      applicationVersion: l10n.appVersion,
                      applicationLegalese: l10n.appLegalese,
                      children: [Text(l10n.appInfoPlaceholder)],
                    );
                  },
                ),
              ],
            ),
          ),
          // Loading overlay
          BlocBuilder<DataTransferCubit, DataTransferState>(
            builder: (context, state) {
              return state.maybeWhen(
                loading: (message) => Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(color: Colors.white),
                        const SizedBox(height: 16),
                        Text(message, style: const TextStyle(color: Colors.white, fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                orElse: () => const SizedBox.shrink(),
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
          title: Text(AppLocalizations.of(context)!.languageSettingTitle),
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
