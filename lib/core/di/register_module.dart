import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:luna_arc_sync/core/api/api_client.dart';
import 'package:luna_arc_sync/core/api/auth_interceptor.dart';
import 'package:luna_arc_sync/core/api/error_handler_interceptor.dart';
import 'package:luna_arc_sync/core/storage/secure_storage_service.dart';
import 'package:luna_arc_sync/core/storage/image_cache_service.dart';
import 'package:luna_arc_sync/presentation/settings/notifiers/grid_settings_notifier.dart';
import 'package:luna_arc_sync/presentation/settings/notifiers/precaching_settings_notifier.dart';
import 'package:luna_arc_sync/core/theme/glassmorphic_performance_notifier.dart';
import 'package:luna_arc_sync/core/scanner/scanner_manager.dart';
import 'package:luna_arc_sync/core/scanner/scanner_config_service.dart';

@module
abstract class RegisterModule {
  @preResolve
  @lazySingleton
  Future<ApiClient> apiClient(
    SecureStorageService storageService,
    AuthInterceptor authInterceptor,
    ErrorHandlerInterceptor errorHandlerInterceptor,
  ) async {
    final apiClient = ApiClient(authInterceptor, errorHandlerInterceptor);
    final serverUrl = await storageService.getServerUrl();
    if (serverUrl != null && serverUrl.isNotEmpty) {
      apiClient.setBaseUrl(serverUrl);
    }
    // If no URL is stored, it will use the empty default from the constructor
    return apiClient;
  }

  @preResolve
  @singleton
  Future<GridSettingsNotifier> gridSettingsNotifier() async {
    final notifier = GridSettingsNotifier();
    await notifier.loadSettings();
    return notifier;
  }

  @preResolve
  @singleton
  Future<PrecachingSettingsNotifier> precachingSettingsNotifier() async {
    final notifier = PrecachingSettingsNotifier();
    await notifier.loadSettings();
    return notifier;
  }

  @preResolve
  @lazySingleton
  Future<ImageCacheService> imageCacheService() async {
    final service = ImageCacheService();
    await service.init();
    return service;
  }

  @preResolve
  @singleton
  Future<GlassmorphicPerformanceNotifier> glassmorphicPerformanceNotifier() async {
    final notifier = GlassmorphicPerformanceNotifier();
    // 预热毛玻璃缓存
    await notifier.warmupCache();
    return notifier;
  }

  @lazySingleton
  ScannerManager scannerManager() => ScannerManager();

  @preResolve
  @lazySingleton
  Future<ScannerConfigService> scannerConfigService() async {
    final prefs = await SharedPreferences.getInstance();
    return ScannerConfigService(prefs);
  }
}
