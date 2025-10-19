import 'dart:io';
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
import 'package:luna_arc_sync/core/theme/theme_color_notifier.dart';
import 'package:luna_arc_sync/core/theme/background_image_notifier.dart';
import 'package:luna_arc_sync/core/theme/font_notifier.dart';
import 'package:luna_arc_sync/presentation/settings/cubit/data_transfer_cubit.dart';
import 'package:luna_arc_sync/presentation/settings/cubit/data_transfer_state.dart';
import 'package:luna_arc_sync/presentation/settings/view/pdf_background_settings_page.dart';
import 'package:luna_arc_sync/presentation/settings/notifiers/grid_settings_notifier.dart';
import 'package:luna_arc_sync/core/cache/pdf_cache_service.dart';
import 'package:luna_arc_sync/core/cache/image_cache_service_enhanced.dart';
import 'package:luna_arc_sync/core/config/pdf_render_backend.dart';
import 'package:luna_arc_sync/core/services/dark_mode_image_processor.dart';
import 'package:provider/provider.dart';
import 'package:luna_arc_sync/core/animations/animated_list_item.dart';
import 'package:luna_arc_sync/presentation/widgets/optimized_glassmorphic_container.dart';
import 'package:luna_arc_sync/core/theme/glassmorphic_performance_notifier.dart';
import 'package:luna_arc_sync/core/theme/no_overscroll_behavior.dart';
import 'package:luna_arc_sync/presentation/settings/view/glassmorphic_performance_settings_page.dart';
import 'package:luna_arc_sync/core/cache/glassmorphic_cache.dart';
import 'package:luna_arc_sync/core/config/glassmorphic_presets.dart';
import 'package:luna_arc_sync/core/services/page_preload_service.dart';
import 'package:luna_arc_sync/presentation/scanner/view/scanner_settings_page.dart';

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
  int _preloadCount = 2;
  late JobHistoryService _jobHistoryService;
  PdfRenderBackend _pdfRenderBackend = PdfRenderBackend.pdfjs;
  final PagePreloadService _preloadService = PagePreloadService();

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
    final preloadCount = await _preloadService.getPreloadCount();
    setState(() {
      _maxJobHistoryRecords = maxRecords;
      _jobPollingInterval = pollingInterval;
      _pdfRenderBackend = pdfBackend;
      _preloadCount = preloadCount;
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

  Future<void> _updatePreloadCount(int newValue) async {
    await _preloadService.setPreloadCount(newValue);
    setState(() {
      _preloadCount = newValue;
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
    final themeColorNotifier = context.watch<ThemeColorNotifier>();
    final backgroundImageNotifier = context.watch<BackgroundImageNotifier>();
    final fontNotifier = context.watch<FontNotifier>();

    return BlocListener<DataTransferCubit, DataTransferState>(
      listener: (context, state) {
        state.whenOrNull(
          exportSuccess: (data) async {
            try {
              final timestamp = DateTime.now().millisecondsSinceEpoch;
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
            backgroundColor: backgroundImageNotifier.hasCustomBackground ? Colors.transparent : null,
            appBar: AppBar(
              backgroundColor: backgroundImageNotifier.hasCustomBackground ? Colors.transparent : null,
              title: Text(l10n.settingsPageTitle),
            ),
            body: ScrollConfiguration(
              behavior: backgroundImageNotifier.hasCustomBackground 
                  ? const GlassmorphicScrollBehavior() 
                  : ScrollConfiguration.of(context).copyWith(),
              child: ListView(
                children: [
                // 外观设置
                AnimatedListItem(
                  index: 0,
                  delay: const Duration(milliseconds: 50),
                  animationType: AnimationType.fadeSlideUp,
                  child: _buildSectionHeader(AppLocalizations.of(context)!.settingsAppearanceSettings),
                ),
                AnimatedListItem(
                  index: 1,
                  delay: const Duration(milliseconds: 50),
                  animationType: AnimationType.fadeSlideUp,
                  child: ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(l10n.languageSettingTitle),
                    subtitle: Text((localeNotifier.locale?.languageCode ?? 'en') == 'en' ? l10n.english : l10n.chinese),
                    onTap: () => _showLanguagePickerDialog(context, localeNotifier),
                  ),
                ),
                AnimatedListItem(
                  index: 2,
                  delay: const Duration(milliseconds: 50),
                  animationType: AnimationType.fadeSlideUp,
                  child: ListTile(
                    leading: const Icon(Icons.palette),
                    title: Text(AppLocalizations.of(context)!.settingsThemeSettings),
                    subtitle: Text(_getThemeModeText(themeNotifier.themeMode)),
                    onTap: () => _showThemePickerDialog(context, themeNotifier),
                  ),
                ),
                AnimatedListItem(
                  index: 3,
                  delay: const Duration(milliseconds: 50),
                  animationType: AnimationType.fadeSlideUp,
                  child: SwitchListTile(
                    secondary: const Icon(Icons.auto_awesome),
                    title: const Text('自动主题切换'),
                    subtitle: Text(backgroundImageNotifier.hasCustomBackground
                        ? '根据背景图片亮度自动切换深色/浅色模式'
                        : '需要先设置自定义背景图片'),
                    value: backgroundImageNotifier.autoThemeSwitchEnabled,
                    onChanged: backgroundImageNotifier.hasCustomBackground
                        ? (value) => backgroundImageNotifier.toggleAutoThemeSwitch(value)
                        : null,
                  ),
                ),
                AnimatedListItem(
                  index: 4,
                  delay: const Duration(milliseconds: 50),
                  animationType: AnimationType.fadeSlideUp,
                  child: ListTile(
                    leading: Icon(Icons.color_lens, color: themeColorNotifier.themeColor),
                    title: Text(AppLocalizations.of(context)!.settingsThemeColor),
                    subtitle: Text(themeColorNotifier.getColorName()),
                    onTap: () => _showThemeColorPickerDialog(context, themeColorNotifier),
                  ),
                ),
                AnimatedListItem(
                  index: 5,
                  delay: const Duration(milliseconds: 50),
                  animationType: AnimationType.fadeSlideUp,
                  child: ListTile(
                    leading: const Icon(Icons.image_outlined),
                    title: Text(AppLocalizations.of(context)!.settingsBackgroundImage),
                    subtitle: Text(
                      backgroundImageNotifier.hasCustomBackground 
                        ? AppLocalizations.of(context)!.settingsBackgroundImageEnabled
                        : AppLocalizations.of(context)!.settingsBackgroundImageDisabled
                    ),
                    onTap: () => _showBackgroundImageDialog(context, backgroundImageNotifier),
                  ),
                ),
                AnimatedListItem(
                  index: 5,
                  delay: const Duration(milliseconds: 50),
                  animationType: AnimationType.fadeSlideUp,
                  child: ListTile(
                    leading: const Icon(Icons.font_download),
                    title: Text(AppLocalizations.of(context)!.fontSettingsTitle),
                    subtitle: Text(fontNotifier.getFontDisplayName()),
                    onTap: () => _showFontPickerDialog(context, fontNotifier),
                  ),
                ),
                const Divider(),
                
                // 设备设置
                AnimatedListItem(
                  index: 6,
                  delay: const Duration(milliseconds: 50),
                  animationType: AnimationType.fadeSlideUp,
                  child: _buildSectionHeader('设备设置'),
                ),
                AnimatedListItem(
                  index: 6,
                  delay: const Duration(milliseconds: 50),
                  animationType: AnimationType.fadeSlideUp,
                  child: ListTile(
                    leading: const Icon(Icons.scanner),
                    title: const Text('打印机/扫描仪'),
                    subtitle: const Text('配置和管理打印机与扫描仪设备'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ScannerSettingsPage(),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(),
                
                // 显示设置
                AnimatedListItem(
                  index: 7,
                  delay: const Duration(milliseconds: 50),
                  animationType: AnimationType.fadeSlideUp,
                  child: _buildSectionHeader(AppLocalizations.of(context)!.settingsDisplaySettings),
                ),
                AnimatedListItem(
                  index: 7,
                  delay: const Duration(milliseconds: 50),
                  animationType: AnimationType.fadeSlideUp,
                  child: Consumer<GridSettingsNotifier>(
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
                ),
                // Default View Mode Setting
                AnimatedListItem(
                  index: 8,
                  delay: const Duration(milliseconds: 50),
                  animationType: AnimationType.fadeSlideUp,
                  child: Consumer<GridSettingsNotifier>(
                    builder: (context, notifier, child) {
                      return ListTile(
                        leading: const Icon(Icons.view_module),
                        title: Text(l10n.defaultViewMode),
                        subtitle: Text(notifier.defaultViewMode == 'list' 
                            ? l10n.listView 
                            : l10n.gridView),
                        onTap: () => _showViewModeDialog(context, notifier),
                      );
                    },
                  ),
                ),
                // Dark Mode Image Processing Settings
                AnimatedListItem(
                  index: 9,
                  delay: const Duration(milliseconds: 50),
                  animationType: AnimationType.fadeSlideUp,
                  child: ListTile(
                    leading: const Icon(Icons.dark_mode),
                    title: Text(l10n.darkModeImageProcessing),
                    subtitle: Text(l10n.darkModeImageProcessingSubtitle),
                    onTap: () => _showDarkModeSettingsDialog(context),
                  ),
                ),
                // PDF渲染后端设置
                AnimatedListItem(
                  index: 10,
                  delay: const Duration(milliseconds: 50),
                  animationType: AnimationType.fadeSlideUp,
                  child: ListTile(
                    leading: const Icon(Icons.picture_as_pdf),
                    title: const Text('PDF渲染引擎'),
                    subtitle: Text(PdfRenderBackendService.getBackendDisplayName(_pdfRenderBackend)),
                    onTap: () => _showPdfBackendPickerDialog(context),
                  ),
                ),
                // 毛玻璃性能设置
                AnimatedListItem(
                  index: 11,
                  delay: const Duration(milliseconds: 50),
                  animationType: AnimationType.fadeSlideUp,
                  child: ListTile(
                    leading: const Icon(Icons.blur_on),
                    title: const Text('毛玻璃性能设置'),
                    subtitle: const Text('调整毛玻璃效果的性能和视觉效果'),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GlassmorphicPerformanceSettingsPage(),
                      ),
                    ),
                  ),
                ),
                const Divider(),
                
                // 任务设置
                AnimatedListItem(
                  index: 12,
                  delay: const Duration(milliseconds: 50),
                  animationType: AnimationType.fadeSlideUp,
                  child: _buildSectionHeader(AppLocalizations.of(context)!.settingsJobSettings),
                ),
                AnimatedListItem(
                  index: 13,
                  delay: const Duration(milliseconds: 50),
                  animationType: AnimationType.fadeSlideUp,
                  child: ListTile(
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
                ),
                AnimatedListItem(
                  index: 14,
                  delay: const Duration(milliseconds: 50),
                  animationType: AnimationType.fadeSlideUp,
                  child: ListTile(
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
                ),
                AnimatedListItem(
                  index: 15,
                  delay: const Duration(milliseconds: 50),
                  animationType: AnimationType.fadeSlideUp,
                  child: ListTile(
                    leading: const Icon(Icons.download),
                    title: const Text('页面预加载设置'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('预加载前后 $_preloadCount 页'),
                        Slider(
                          value: _preloadCount.toDouble(),
                          min: 0,
                          max: 5,
                          divisions: 5,
                          label: '$_preloadCount 页',
                          onChanged: (value) => _updatePreloadCount(value.toInt()),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedListItem(
                  index: 16,
                  delay: const Duration(milliseconds: 50),
                  animationType: AnimationType.fadeSlideUp,
                  child: ListTile(
                    leading: const Icon(Icons.color_lens),
                    title: const Text('PDF背景颜色'),
                    subtitle: const Text('自定义PDF渲染的背景颜色'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PdfBackgroundSettingsPage(),
                        ),
                      );
                    },
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

  void _showViewModeDialog(BuildContext context, GridSettingsNotifier notifier) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.defaultViewMode),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.listView),
                subtitle: Text(AppLocalizations.of(context)!.defaultViewModeDescription),
                leading: const Icon(Icons.view_list),
                selected: notifier.defaultViewMode == 'list',
                onTap: () {
                  notifier.updateDefaultViewMode('list');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.gridView),
                subtitle: Text(AppLocalizations.of(context)!.defaultViewModeDescription),
                leading: const Icon(Icons.view_module),
                selected: notifier.defaultViewMode == 'grid',
                onTap: () {
                  notifier.updateDefaultViewMode('grid');
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

  void _showBackgroundImageDialog(BuildContext context, BackgroundImageNotifier backgroundImageNotifier) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.settingsBackgroundImage),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 预览当前背景
                if (backgroundImageNotifier.backgroundImageBytes != null)
                  Container(
                    height: 200,
                    width: double.maxFinite,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        backgroundImageNotifier.backgroundImageBytes!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                
                Text(
                  AppLocalizations.of(context)!.settingsBackgroundImageDescription,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                
                // 启用/禁用背景
                if (backgroundImageNotifier.backgroundImageBytes != null)
                  SwitchListTile(
                    title: Text(AppLocalizations.of(context)!.settingsBackgroundImageEnable),
                    value: backgroundImageNotifier.isCustomBackgroundEnabled,
                    onChanged: (bool value) async {
                      await backgroundImageNotifier.toggleBackgroundEnabled(value);
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                  ),
              ],
            ),
          ),
          actions: [
            if (backgroundImageNotifier.backgroundImageBytes != null)
              TextButton.icon(
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: Text(AppLocalizations.of(context)!.settingsBackgroundImageRemove),
                      content: Text(AppLocalizations.of(context)!.settingsBackgroundImageRemoveConfirm),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext, false),
                          child: Text(AppLocalizations.of(context)!.cancel),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(dialogContext, true),
                          child: Text(AppLocalizations.of(context)!.delete),
                        ),
                      ],
                    ),
                  );
                  
                  if (confirmed == true) {
                    await backgroundImageNotifier.removeBackgroundImage();
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                icon: const Icon(Icons.delete_outline),
                label: Text(AppLocalizations.of(context)!.settingsBackgroundImageRemove),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.close),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                await _pickBackgroundImage(context, backgroundImageNotifier);
              },
              icon: const Icon(Icons.add_photo_alternate),
              label: Text(AppLocalizations.of(context)!.settingsBackgroundImageSelect),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickBackgroundImage(BuildContext context, BackgroundImageNotifier backgroundImageNotifier) async {
    try {
      debugPrint('Starting image picker...');
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true, // 确保在Android上加载数据
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        debugPrint('File picked: ${file.name}, size: ${file.size}');
        
        Uint8List? imageBytes;
        
        // Android上优先使用bytes，如果为null则从path读取
        if (file.bytes != null) {
          debugPrint('Using bytes from picker');
          imageBytes = file.bytes;
        } else if (file.path != null) {
          debugPrint('Bytes is null, reading from path: ${file.path}');
          final imageFile = File(file.path!);
          if (await imageFile.exists()) {
            imageBytes = await imageFile.readAsBytes();
            debugPrint('Read ${imageBytes.length} bytes from path');
          }
        }
        
        if (imageBytes != null) {
          debugPrint('Setting background image with ${imageBytes.length} bytes');
          
          // 显示加载提示
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 16),
                    Text('正在设置背景图片...'),
                  ],
                ),
                duration: Duration(seconds: 2),
              ),
            );
          }
          
          final success = await backgroundImageNotifier.setBackgroundImage(imageBytes);
          
          if (context.mounted) {
            if (success) {
              debugPrint('Background image set successfully');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.settingsBackgroundImageSet),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              debugPrint('Failed to set background image');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('背景图片设置失败，请重试'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        } else {
          debugPrint('Error: imageBytes is null');
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('无法读取图片数据，请重试'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } else {
        debugPrint('No file selected');
      }
    } catch (e, stackTrace) {
      debugPrint('Error picking background image: $e');
      debugPrint('Stack trace: $stackTrace');
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.settingsBackgroundImageError(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showThemeColorPickerDialog(BuildContext context, ThemeColorNotifier themeColorNotifier) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.settingsThemeColor),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: ThemeColorNotifier.availableColors.length,
              itemBuilder: (context, index) {
                final colorOption = ThemeColorNotifier.availableColors[index];
                final isSelected = themeColorNotifier.themeColor.value == colorOption.color.value;
                
                return InkWell(
                  onTap: () {
                    themeColorNotifier.setThemeColor(colorOption.color);
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorOption.color,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected 
                            ? Theme.of(context).colorScheme.outline 
                            : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 32,
                          )
                        : null,
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.close),
            ),
          ],
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
      
      // Clear PDF cache files
      if (_clearPdfCache) {
        await PdfCacheService.clearAllCache();
        await ImageCacheServiceEnhanced.clearAllCache();
      }
      
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
      
      // Clear PDF cache files
      await PdfCacheService.clearAllCache();
      await ImageCacheServiceEnhanced.clearAllCache();
      
      // Clear PDF cache preferences
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
    final hasCustomBackground = context.watch<BackgroundImageNotifier>().hasCustomBackground;
    
    final aboutContent = Column(
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
      );

    // 如果有自定义背景，使用优化的毛玻璃卡片
    if (hasCustomBackground) {
      return Consumer<GlassmorphicPerformanceNotifier>(
        builder: (context, performanceNotifier, child) {
          final config = performanceNotifier.config;
          // 使用设置页面卡片预设
          final blur = config.getActualBlur(GlassmorphicPresets.settingsCardBlur);
          final opacity = config.getActualOpacity(GlassmorphicPresets.settingsCardOpacity);
          
          return OptimizedGlassmorphicCard(
            blur: blur,
            opacity: opacity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(vertical: 8),
            useSharedBlur: false,  // 使用独立模糊，因为没有父组件提供共享模糊
            blurGroup: 'settings',
            blurMethod: config.blurMethod,
            kawaseConfig: config.blurMethod == BlurMethod.kawase ? config.getKawaseConfig() : null,
            child: aboutContent,
          );
        },
      );
    }

    // 没有自定义背景时，使用普通样式
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
      child: aboutContent,
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
