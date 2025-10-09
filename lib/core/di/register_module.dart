import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/core/api/api_client.dart';
import 'package:luna_arc_sync/core/api/auth_interceptor.dart';
import 'package:luna_arc_sync/core/storage/secure_storage_service.dart';
import 'package:luna_arc_sync/core/storage/image_cache_service.dart';
import 'package:luna_arc_sync/presentation/settings/notifiers/grid_settings_notifier.dart';

@module
abstract class RegisterModule {
  @preResolve
  @lazySingleton
  Future<ApiClient> apiClient(
    SecureStorageService storageService,
    AuthInterceptor authInterceptor,
  ) async {
    final apiClient = ApiClient(authInterceptor);
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
  @lazySingleton
  Future<ImageCacheService> imageCacheService() async {
    final service = ImageCacheService();
    await service.init();
    return service;
  }
}
