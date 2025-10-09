import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:luna_arc_sync/core/di/injection.dart';
import 'package:luna_arc_sync/l10n/app_localizations.dart';
import 'package:luna_arc_sync/core/localization/locale_notifier.dart';
import 'package:luna_arc_sync/core/storage/job_history_service.dart';
import 'package:luna_arc_sync/core/theme/theme_notifier.dart';
import 'package:luna_arc_sync/core/theme/font_notifier.dart';
import 'package:luna_arc_sync/presentation/settings/cubit/data_transfer_cubit.dart';
import 'package:luna_arc_sync/presentation/settings/cubit/data_transfer_state.dart';
import 'package:luna_arc_sync/presentation/settings/notifiers/grid_settings_notifier.dart';
import 'package:luna_arc_sync/presentation/pages/view/page_detail_page.dart';
import 'package:luna_arc_sync/core/config/pdf_render_backend.dart';
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
  int _maxJobHistoryRecords = 100;
  int _jobPollingInterval = 5;
  late JobHistoryService _jobHistoryService;
  PdfRenderBackend _pdfRenderBackend = PdfRenderBackend.pdfjs;

  @override
  void initState() {
    super.initState();
    _jobHistoryService = getIt<JobHistoryService>();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final maxRecords = await _jobHistoryService.getMaxRecords();
    final pollingInterval = await _jobHistoryService.getPollingInterval();
    final pdfBackend = await PdfRenderBackendService.getBackend();
    setState(() {
      _maxJobHistoryRecords = maxRecords;
      _jobPollingInterval = pollingInterval;
      _pdfRenderBackend = pdfBackend;
    });
  }

  Future<void> _updateMaxRecords(int newValue) async {
    await _jobHistoryService.setMaxRecords(newValue);
    setState(() {
      _maxJobHistoryRecords = newValue;
    });
  }

  Future<void> _updatePollingInterval(int newValue) async {
    await _jobHistoryService.setPollingInterval(newValue);
    setState(() {
      _jobPollingInterval = newValue;
    });
  }

  Future<void> _handleExport(BuildContext context) async {
    // 显示确认对话框
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.settingsExportDatabase),
            content: Text(
              '${AppLocalizations.of(context)!.settingsExportDatabaseDescription}${AppLocalizations.of(context)!.settingsExportConfirmMessage}'
            ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(AppLocalizations.of(context)!.settingsExportDatabase),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      if (mounted) {
        // ignore: use_build_context_synchronously
        context.read<DataTransferCubit>().exportData();
      }
    }
  }

  Future<void> _handleImport(BuildContext context) async {
    // 显示导入说明对话框
    final proceed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.settingsImportDatabase),
          content: Text(
            AppLocalizations.of(context)!.settingsImportDatabaseDescription +
            AppLocalizations.of(context)!.settingsImportDatabaseAdditionalInfo
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(AppLocalizations.of(context)!.settingsImportDatabase),
            ),
          ],
        );
      },
    );

    if (proceed != true) return;

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.bytes != null) {
          // 验证文件大小
          final fileSize = file.bytes!.length;
          if (fileSize > 100 * 1024 * 1024) { // 100MB limit
            if (mounted) {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  // ignore: use_build_context_synchronously
                  content: Text(AppLocalizations.of(context)!.settingsFileTooLarge),
                  backgroundColor: Colors.red,
                ),
              );
            }
            return;
          }
          
          if (mounted) {
            // ignore: use_build_context_synchronously
            context.read<DataTransferCubit>().importData(file);
          }
        } else {
          if (mounted) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                // ignore: use_build_context_synchronously
                content: Text(AppLocalizations.of(context)!.settingsFileCorrupted),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } else {
        // User canceled the picker
        if (mounted) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            // ignore: use_build_context_synchronously
            SnackBar(content: Text(AppLocalizations.of(context)!.settingsNoFileSelected)),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            // ignore: use_build_context_synchronously
            content: Text(AppLocalizations.of(context)!.settingsFileSelectionError(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeNotifier = context.watch<LocaleNotifier>();
    final themeNotifier = context.watch<ThemeNotifier>();
    final fontNotifier = context.watch<FontNotifier>();

    return BlocListener<DataTransferCubit, DataTransferState>(
      listener: (context, state) {
        state.whenOrNull(
          exportSuccess: (data) async {
            try {
              final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').replaceAll('.', '-');
              final fileName = 'LunaArcSync_MyData_Export_$timestamp.zip';
              
              // 使用 FilePicker 让用户选择保存位置
              final filePath = await FilePicker.platform.saveFile(
                // ignore: use_build_context_synchronously
                dialogTitle: AppLocalizations.of(context)!.settingsSaveExportFile,
                fileName: fileName,
                type: FileType.custom,
                allowedExtensions: ['zip'],
                bytes: data,
              );
              
              if (filePath != null) {
                // 显示成功信息，包含文件大小
                final fileSize = (data.length / 1024 / 1024).toStringAsFixed(2);
                if (mounted) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      // ignore: use_build_context_synchronously
                      content: Text(AppLocalizations.of(context)!.settingsExportSuccess(fileName, fileSize)),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 5),
                      action: SnackBarAction(
                        // ignore: use_build_context_synchronously
                        label: AppLocalizations.of(context)!.confirm,
                        textColor: Colors.white,
                        onPressed: () {},
                      ),
                    ),
                  );
                }
              } else {
                // 用户取消了保存
                if (mounted) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      // ignore: use_build_context_synchronously
                      content: Text(AppLocalizations.of(context)!.settingsSaveCancelled),
                    ),
                  );
                }
              }
            } catch (e) {
              if (mounted) {
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    // ignore: use_build_context_synchronously
                    content: Text(AppLocalizations.of(context)!.settingsSaveFileFailed(e.toString())),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            } finally {
              if (mounted) {
                // ignore: use_build_context_synchronously
                context.read<DataTransferCubit>().reset();
              }
            }
          },
          importSuccess: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) {
                return AlertDialog(
                  title: Text(AppLocalizations.of(context)!.settingsImportSuccess),
                  content: Text(
                    AppLocalizations.of(context)!.settingsImportSuccessDescription +
                    AppLocalizations.of(context)!.settingsImportSuccessAdditionalInfo
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        // 在移动平台上，可以尝试退出应用
                        // 在Web平台上，显示提示信息
                        if (kIsWeb) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(AppLocalizations.of(context)!.settingsRefreshPageToCompleteImport),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 5),
                            ),
                          );
                        } else {
                          // 在移动平台上，可以尝试退出应用
                          SystemNavigator.pop();
                        }
                      },
                      child: Text(AppLocalizations.of(context)!.confirm),
                    ),
                  ],
                );
              },
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
                // 外观设置
                _buildSectionHeader(AppLocalizations.of(context)!.settingsAppearanceSettings),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(l10n.languageSettingTitle),
                  subtitle: Text((localeNotifier.locale?.languageCode ?? 'en') == 'en' ? l10n.english : l10n.chinese),
                  onTap: () => _showLanguagePickerDialog(context, localeNotifier),
                ),
                ListTile(
                  leading: const Icon(Icons.palette),
                  title: Text(AppLocalizations.of(context)!.settingsThemeSettings),
                  subtitle: Text(_getThemeModeText(themeNotifier.themeMode)),
                  onTap: () => _showThemePickerDialog(context, themeNotifier),
                ),
                ListTile(
                  leading: const Icon(Icons.font_download),
                  title: Text(AppLocalizations.of(context)!.fontSettingsTitle),
                  subtitle: Text(fontNotifier.getFontDisplayName()),
                  onTap: () => _showFontPickerDialog(context, fontNotifier),
                ),
                const Divider(),
                
                // 显示设置
                _buildSectionHeader(AppLocalizations.of(context)!.settingsDisplaySettings),
                Consumer<GridSettingsNotifier>(
                  builder: (context, notifier, child) {
                    return ListTile(
                      leading: const Icon(Icons.grid_view),
                      title: Text(l10n.gridColumns),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${l10n.columns}: ${notifier.crossAxisCount}'),
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
                // Dark Mode Image Processing Settings
                ListTile(
                  leading: const Icon(Icons.dark_mode),
                  title: Text(l10n.darkModeImageProcessing),
                  subtitle: Text(l10n.darkModeImageProcessingSubtitle),
                  onTap: () => _showDarkModeSettingsDialog(context),
                ),
                // PDF渲染后端设置
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf),
                  title: const Text('PDF渲染引擎'),
                  subtitle: Text(PdfRenderBackendService.getBackendDisplayName(_pdfRenderBackend)),
                  onTap: () => _showPdfBackendPickerDialog(context),
                ),
                const Divider(),
                
                // 任务设置
                _buildSectionHeader(AppLocalizations.of(context)!.settingsJobSettings),
                ListTile(
                  leading: const Icon(Icons.work_history),
                  title: Text(AppLocalizations.of(context)!.settingsJobHistory),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context)!.settingsMaxJobHistoryRecords(_maxJobHistoryRecords.toString())),
                      Slider(
                        value: _maxJobHistoryRecords.toDouble(),
                        min: 10,
                        max: 500,
                        divisions: 49,
                        label: _maxJobHistoryRecords.toString(),
                        onChanged: (value) => _updateMaxRecords(value.toInt()),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.timer),
                  title: Text(AppLocalizations.of(context)!.settingsPollingInterval),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context)!.settingsPollingIntervalValue(_jobPollingInterval.toString())),
                      Slider(
                        value: _jobPollingInterval.toDouble(),
                        min: 1,
                        max: 60,
                        divisions: 59,
                        label: '$_jobPollingInterval${AppLocalizations.of(context)!.settingsPollingIntervalLabel}',
                        onChanged: (value) => _updatePollingInterval(value.toInt()),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                
                // 通知设置
                _buildSectionHeader(AppLocalizations.of(context)!.settingsNotificationSettings),
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
                
                // 数据管理
                _buildSectionHeader(AppLocalizations.of(context)!.settingsDataManagement),
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
                ListTile(
                  leading: const Icon(Icons.cleaning_services),
                  title: Text(l10n.clearCacheTitle),
                  onTap: () => _showClearCacheDialog(context),
                ),
                const Divider(),
                
                // 关于
                _buildSectionHeader(AppLocalizations.of(context)!.settingsAbout),
                _buildAboutSection(context),
              ],
            ),
          ),
          // Loading overlay
          BlocBuilder<DataTransferCubit, DataTransferState>(
            builder: (context, state) {
              return state.maybeWhen(
                loading: (message) => Container(
                  color: Colors.black.withValues(alpha: 0.5),
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
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.languageSettingTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(l10n.chinese),
                onTap: () {
                  localeNotifier.setLocale(const Locale('zh'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(l10n.english),
                onTap: () {
                  localeNotifier.setLocale(const Locale('en'));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showThemePickerDialog(BuildContext context, ThemeNotifier themeNotifier) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.settingsThemeSettings),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.settingsFollowSystem),
                subtitle: Text(AppLocalizations.of(context)!.settingsFollowSystemDescription),
                leading: const Icon(Icons.brightness_auto),
                onTap: () {
                  themeNotifier.setThemeMode(ThemeMode.system);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.settingsLightTheme),
                subtitle: Text(AppLocalizations.of(context)!.settingsLightThemeDescription),
                leading: const Icon(Icons.light_mode),
                onTap: () {
                  themeNotifier.setThemeMode(ThemeMode.light);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.settingsDarkTheme),
                subtitle: Text(AppLocalizations.of(context)!.settingsDarkThemeDescription),
                leading: const Icon(Icons.dark_mode),
                onTap: () {
                  themeNotifier.setThemeMode(ThemeMode.dark);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFontPickerDialog(BuildContext context, FontNotifier fontNotifier) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.fontSettingsTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: FontNotifier.availableFonts.map((font) {
              return ListTile(
                title: Text(font.displayName),
                subtitle: Text(font.name),
                leading: Icon(
                  Icons.font_download,
                  color: fontNotifier.selectedFont == font.name 
                      ? Theme.of(context).colorScheme.primary 
                      : null,
                ),
                trailing: fontNotifier.selectedFont == font.name 
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () {
                  fontNotifier.setFont(font.name);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showPdfBackendPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('选择PDF渲染引擎'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: PdfRenderBackend.values.map((backend) {
              final isSelected = _pdfRenderBackend == backend;
              
              // 为每个后端选择合适的图标
              IconData backendIcon;
              switch (backend) {
                case PdfRenderBackend.pdfx:
                  backendIcon = Icons.high_quality;
                  break;
                case PdfRenderBackend.pdfrx:
                  backendIcon = Icons.touch_app;
                  break;
                case PdfRenderBackend.pdfjs:
                  backendIcon = Icons.text_fields;
                  break;
              }
              
              return ListTile(
                title: Text(PdfRenderBackendService.getBackendDisplayName(backend)),
                subtitle: Text(
                  PdfRenderBackendService.getBackendDescription(backend),
                  style: const TextStyle(fontSize: 12),
                ),
                leading: Icon(
                  backendIcon,
                  color: isSelected ? Theme.of(context).colorScheme.primary : null,
                ),
                trailing: isSelected 
                    ? Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () async {
                  await PdfRenderBackendService.setBackend(backend);
                  setState(() {
                    _pdfRenderBackend = backend;
                  });
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '已切换到 ${PdfRenderBackendService.getBackendDisplayName(backend)}\n重新打开PDF页面后生效',
                        ),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  String _getThemeModeText(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return AppLocalizations.of(context)!.themeModeSystem;
      case ThemeMode.light:
        return AppLocalizations.of(context)!.themeModeLight;
      case ThemeMode.dark:
        return AppLocalizations.of(context)!.themeModeDark;
    }
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showLicensesDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.description,
                        color: theme.colorScheme.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.licensesTitle,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Content
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.settingsOpenSourceThanks,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // All dependencies from pubspec.yaml
                          _buildLicenseItem(context, 'Flutter', 'BSD-3-Clause', 'Google', 'https://flutter.dev'),
                          _buildLicenseItem(context, 'cupertino_icons', 'MIT', 'Flutter Team', 'https://pub.dev/packages/cupertino_icons'),
                          _buildLicenseItem(context, 'flutter_bloc', 'MIT', 'Felix Angelov', 'https://pub.dev/packages/flutter_bloc'),
                          _buildLicenseItem(context, 'dio', 'MIT', 'Flutter China', 'https://pub.dev/packages/dio'),
                          _buildLicenseItem(context, 'get_it', 'MIT', 'Thomas Burkhart', 'https://pub.dev/packages/get_it'),
                          _buildLicenseItem(context, 'injectable', 'MIT', 'Thomas Burkhart', 'https://pub.dev/packages/injectable'),
                          _buildLicenseItem(context, 'freezed_annotation', 'MIT', 'Remi Rousselet', 'https://pub.dev/packages/freezed_annotation'),
                          _buildLicenseItem(context, 'json_annotation', 'MIT', 'Dart Team', 'https://pub.dev/packages/json_annotation'),
                          _buildLicenseItem(context, 'flutter_secure_storage', 'MIT', 'Mogol', 'https://pub.dev/packages/flutter_secure_storage'),
                          _buildLicenseItem(context, 'file_picker', 'MIT', 'Miguel Ruivo', 'https://pub.dev/packages/file_picker'),
                          _buildLicenseItem(context, 'intl', 'BSD-3-Clause', 'Dart Team', 'https://pub.dev/packages/intl'),
                          _buildLicenseItem(context, 'flutter_localizations', 'BSD-3-Clause', 'Flutter Team', 'https://flutter.dev'),
                          _buildLicenseItem(context, 'go_router', 'BSD-3-Clause', 'Flutter Team', 'https://pub.dev/packages/go_router'),
                          _buildLicenseItem(context, 'material_tag_editor', 'MIT', 'Community', 'https://pub.dev/packages/material_tag_editor'),
                          _buildLicenseItem(context, 'shared_preferences', 'BSD-3-Clause', 'Flutter Team', 'https://pub.dev/packages/shared_preferences'),
                          _buildLicenseItem(context, 'provider', 'MIT', 'Remi Rousselet', 'https://pub.dev/packages/provider'),
                          _buildLicenseItem(context, 'file_saver', 'MIT', 'Community', 'https://pub.dev/packages/file_saver'),
                          _buildLicenseItem(context, 'image_cropper', 'MIT', 'Yalantis', 'https://pub.dev/packages/image_cropper'),
                          _buildLicenseItem(context, 'image', 'MIT', 'Dart Team', 'https://pub.dev/packages/image'),
                          _buildLicenseItem(context, 'cunning_document_scanner', 'MIT', 'Community', 'https://pub.dev/packages/cunning_document_scanner'),
                          _buildLicenseItem(context, 'path_provider', 'BSD-3-Clause', 'Flutter Team', 'https://pub.dev/packages/path_provider'),
                          _buildLicenseItem(context, 'image_cropper_platform_interface', 'MIT', 'Yalantis', 'https://pub.dev/packages/image_cropper_platform_interface'),
                          _buildLicenseItem(context, 'pdfx', 'MIT', 'David PHAM-VAN', 'https://pub.dev/packages/pdfx'),
                          _buildLicenseItem(context, 'pdfrx', 'MIT', 'Espresso3389', 'https://pub.dev/packages/pdfrx'),
                          _buildLicenseItem(context, 'path', 'BSD-3-Clause', 'Dart Team', 'https://pub.dev/packages/path'),
                          _buildLicenseItem(context, 'bloc', 'MIT', 'Felix Angelov', 'https://pub.dev/packages/bloc'),
                          _buildLicenseItem(context, 'device_info_plus', 'MIT', 'Flutter Community', 'https://pub.dev/packages/device_info_plus'),
                          _buildLicenseItem(context, 'package_info_plus', 'MIT', 'Flutter Community', 'https://pub.dev/packages/package_info_plus'),
                          _buildLicenseItem(context, 'flutter_svg', 'MIT', 'Dan Field', 'https://pub.dev/packages/flutter_svg'),
                          _buildLicenseItem(context, 'url_launcher', 'BSD-3-Clause', 'Flutter Team', 'https://pub.dev/packages/url_launcher'),
                          
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.settingsOtherDependencies,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Actions
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                        label: Text(l10n.close),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLicenseItem(BuildContext context, String name, String license, String author, String url) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () => _launchUrl(url),
              child: Text(
                name,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () => _showLicenseContent(context, name, license),
              child: Text(
                license,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontFamily: 'monospace',
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              author,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showLicenseContent(BuildContext context, String packageName, String licenseType) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.description,
                      color: theme.colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '$packageName ${AppLocalizations.of(context)!.settingsLicenseTitle}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Text(
                      _getLicenseContent(licenseType),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ),
              ),
              
              // Actions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      label: Text(AppLocalizations.of(context)!.close),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLicenseContent(String licenseType) {
    switch (licenseType) {
      case 'MIT':
        return '''MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.''';
      case 'BSD-3-Clause':
        return '''BSD 3-Clause License

Copyright (c) [year] [fullname]

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.''';
      default:
        return AppLocalizations.of(context)!.settingsLicenseUnavailable(licenseType);
    }
  }

  void _showDarkModeSettingsDialog(BuildContext context) {
    // Initialize dark mode settings
    DarkModeImageProcessor.initialize();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.darkModeSettingsTitle),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Black Threshold
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.darkModeSettingsDarkTextThreshold,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              AppLocalizations.of(context)!.darkModeSettingsDarkTextThresholdDescription(DarkModeImageProcessor.blackThreshold.toString()),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            Slider(
                              value: DarkModeImageProcessor.blackThreshold.toDouble(),
                              min: 0,
                              max: 255,
                              divisions: 255,
                              onChanged: (value) {
                                setState(() {
                                  DarkModeImageProcessor.setBlackThreshold(value.toInt());
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // White Threshold
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.darkModeSettingsWhiteThreshold,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              AppLocalizations.of(context)!.darkModeSettingsWhiteThresholdDescription(DarkModeImageProcessor.whiteThreshold.toString()),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            Slider(
                              value: DarkModeImageProcessor.whiteThreshold.toDouble(),
                              min: 0,
                              max: 255,
                              divisions: 255,
                              onChanged: (value) {
                                setState(() {
                                  DarkModeImageProcessor.setWhiteThreshold(value.toInt());
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Darken Factor
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.darkModeSettingsDarkenFactor,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              AppLocalizations.of(context)!.darkModeSettingsDarkenFactorDescription((DarkModeImageProcessor.darkenFactor * 100).toStringAsFixed(0)),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            Slider(
                              value: DarkModeImageProcessor.darkenFactor,
                              min: 0.0,
                              max: 1.0,
                              divisions: 100,
                              onChanged: (value) {
                                setState(() {
                                  DarkModeImageProcessor.setDarkenFactor(value);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Lighten Factor
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.darkModeSettingsLightenFactor,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              AppLocalizations.of(context)!.darkModeSettingsLightenFactorDescription((DarkModeImageProcessor.lightenFactor * 100).toStringAsFixed(0)),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            Slider(
                              value: DarkModeImageProcessor.lightenFactor,
                              min: 0.0,
                              max: 1.0,
                              divisions: 100,
                              onChanged: (value) {
                                setState(() {
                                  DarkModeImageProcessor.setLightenFactor(value);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.darkModeSettingsNote,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Reset to defaults
                    DarkModeImageProcessor.setBlackThreshold(180);
                    DarkModeImageProcessor.setWhiteThreshold(15);
                    DarkModeImageProcessor.setDarkenFactor(0.7);
                    DarkModeImageProcessor.setLightenFactor(0.3);
                    setState(() {});
                  },
                  child: Text(AppLocalizations.of(context)!.darkModeSettingsResetDefaults),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.darkModeSettingsClose),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    // Reset cache selection state
    _clearPdfCache = true;
    _clearSettingsCache = true;
    _clearJobCache = false;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.clearCacheTitle),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.clearCacheSelectTypes),
                    const SizedBox(height: 16),
                    FutureBuilder<Map<String, dynamic>>(
                      future: _getCacheInfo(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final cacheInfo = snapshot.data!;
                          return Column(
                            children: [
                              _buildCacheItem(
                                AppLocalizations.of(context)!.clearCachePdfImages,
                                cacheInfo['pdfCount'] ?? 0,
                                cacheInfo['pdfSize'] ?? 0,
                                _clearPdfCache,
                                (value) {
                                  setState(() {
                                    _clearPdfCache = value;
                                  });
                                },
                              ),
                              _buildCacheItem(
                                AppLocalizations.of(context)!.clearCacheDarkModeSettings,
                                cacheInfo['settingsCount'] ?? 0,
                                cacheInfo['settingsSize'] ?? 0,
                                _clearSettingsCache,
                                (value) {
                                  setState(() {
                                    _clearSettingsCache = value;
                                  });
                                },
                              ),
                              _buildCacheItem(
                                AppLocalizations.of(context)!.clearCacheJobHistory,
                                cacheInfo['jobCount'] ?? 0,
                                cacheInfo['jobSize'] ?? 0,
                                _clearJobCache,
                                (value) {
                                  setState(() {
                                    _clearJobCache = value;
                                  });
                                },
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(AppLocalizations.of(context)!.clearCacheTotalSize),
                                  Text(
                                    _formatBytes(cacheInfo['totalSize'] ?? 0),
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await _clearSelectedCaches();
                    if (mounted) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          // ignore: use_build_context_synchronously
                          content: Text(AppLocalizations.of(context)!.clearCacheSuccess),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.clearCacheClearSelected),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await _clearAllCaches();
                    if (mounted) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          // ignore: use_build_context_synchronously
                          content: Text(AppLocalizations.of(context)!.clearCacheAllSuccess),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.clearCacheClearAll),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Cache selection state
  bool _clearPdfCache = true;
  bool _clearSettingsCache = true;
  bool _clearJobCache = false;

  Future<Map<String, dynamic>> _getCacheInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      
      int pdfCount = 0;
      int pdfSize = 0;
      int settingsCount = 0;
      int settingsSize = 0;
      int jobCount = 0;
      int jobSize = 0;
      
      for (final key in keys) {
        if (key.startsWith('pdf_cache_')) {
          pdfCount++;
          try {
            final value = prefs.getString(key);
            if (value != null) {
              pdfSize += value.length;
            }
          } catch (e) {
            // Skip if can't read as string
          }
        } else if (key.startsWith('dark_mode_')) {
          settingsCount++;
          // Estimate size based on key type
          if (key.contains('threshold')) {
            settingsSize += 3; // int values like "180"
          } else if (key.contains('factor')) {
            settingsSize += 4; // double values like "0.7"
          } else {
            settingsSize += 10; // estimated for other settings
          }
        } else if (key.startsWith('job_') || key.startsWith('max_records') || key.startsWith('polling_interval')) {
          jobCount++;
          // Estimate size based on key type
          if (key.contains('history')) {
            jobSize += 50; // estimated for job history lists
          } else if (key.contains('interval') || key.contains('records')) {
            jobSize += 3; // int values
          } else {
            jobSize += 20; // estimated for other job settings
          }
        }
      }
      
      return {
        'pdfCount': pdfCount,
        'pdfSize': pdfSize,
        'settingsCount': settingsCount,
        'settingsSize': settingsSize,
        'jobCount': jobCount,
        'jobSize': jobSize,
        'totalSize': pdfSize + settingsSize + jobSize,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error getting cache info: $e');
      }
      return {
        'pdfCount': 0,
        'pdfSize': 0,
        'settingsCount': 0,
        'settingsSize': 0,
        'jobCount': 0,
        'jobSize': 0,
        'totalSize': 0,
      };
    }
  }

  Widget _buildCacheItem(String title, int count, int size, bool selected, Function(bool) onChanged) {
    return CheckboxListTile(
      title: Text(title),
      subtitle: Text('$count items, ${_formatBytes(size)}'),
      value: selected,
      onChanged: (value) {
        onChanged(value ?? false);
      },
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  Future<void> _clearSelectedCaches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      
      for (final key in keys) {
        bool shouldRemove = false;
        
        if (_clearPdfCache && (key.startsWith('pdf_cache_') || key.startsWith('pdf_timestamp_'))) {
          shouldRemove = true;
        } else if (_clearSettingsCache && key.startsWith('dark_mode_')) {
          shouldRemove = true;
        } else if (_clearJobCache && (key.startsWith('job_') || key.startsWith('max_records') || key.startsWith('polling_interval'))) {
          shouldRemove = true;
        }
        
        if (shouldRemove) {
          await prefs.remove(key);
        }
      }
      
      // Reset dark mode processor to defaults if settings were cleared
      if (_clearSettingsCache) {
        DarkModeImageProcessor.setBlackThreshold(180);
        DarkModeImageProcessor.setWhiteThreshold(15);
        DarkModeImageProcessor.setDarkenFactor(0.7);
        DarkModeImageProcessor.setLightenFactor(0.3);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing selected caches: $e');
      }
    }
  }

  Future<void> _clearAllCaches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Clear PDF cache
      final keys = prefs.getKeys().where((key) => key.startsWith('pdf_cache_')).toList();
      for (final key in keys) {
        await prefs.remove(key);
      }
      
      // Clear dark mode settings
      await prefs.remove('dark_mode_black_threshold');
      await prefs.remove('dark_mode_white_threshold');
      await prefs.remove('dark_mode_darken_factor');
      await prefs.remove('dark_mode_lighten_factor');
      
      // Clear job history settings
      await prefs.remove('max_records');
      await prefs.remove('polling_interval');
      
      // Reset dark mode processor to defaults
      DarkModeImageProcessor.setBlackThreshold(180);
      DarkModeImageProcessor.setWhiteThreshold(15);
      DarkModeImageProcessor.setDarkenFactor(0.7);
      DarkModeImageProcessor.setLightenFactor(0.3);
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing cache: $e');
      }
    }
  }


  Widget _buildAboutSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App Info
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '${AppLocalizations.of(context)!.settingsAppName} v${l10n.appVersion}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // App Description
          Text(
            l10n.appLegalese,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          

          
          // Contributors Section (GPLv3 compliant)
          _buildAboutSubSection(
            context,
            AppLocalizations.of(context)!.settingsProgramContributors,
            [
              'CoWave-Fall',
            ],
          ),
          const SizedBox(height: 16),
          
          // AI Content Notice
          _buildAboutSubSection(
            context,
            AppLocalizations.of(context)!.settingsAiContentNotice,
            [
              l10n.aiContentNotice,
              '',
              l10n.trademarkNotice,
              l10n.trademarkGemini,
              l10n.trademarkClaude,
              l10n.trademarkDeepSeek,
              l10n.trademarkDisclaimer,
            ],
          ),
          const SizedBox(height: 16),
          
          // Technical Info
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final packageInfo = snapshot.data!;
                return _buildAboutSubSection(
                  context,
                  AppLocalizations.of(context)!.settingsTechnicalInfo,
                  [
                    '${AppLocalizations.of(context)!.settingsPackageName}: ${packageInfo.packageName}',
                    '${AppLocalizations.of(context)!.settingsVersion}: ${packageInfo.version}',
                    '${AppLocalizations.of(context)!.settingsBuildNumber}: ${packageInfo.buildNumber}',
                    '${AppLocalizations.of(context)!.settingsProjectUrl}: https://github.com/CoWave-Fall/LunaArcSync',
                    '${AppLocalizations.of(context)!.settingsAuthorUrl}: https://github.com/CoWave-Fall/',
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 12),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showLicensesDialog(context),
                  icon: const Icon(Icons.description, size: 16),
                  label: Text(l10n.viewLicenses),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSubSection(BuildContext context, String title, List<String> items) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 6),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 1),
          child: Text(
            item,
            style: theme.textTheme.bodySmall?.copyWith(
              height: 1.4,
              color: item.isEmpty ? Colors.transparent : null,
            ),
          ),
        )),
      ],
    );
  }

}
