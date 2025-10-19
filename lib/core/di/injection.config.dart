// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:luna_arc_sync/core/api/api_client.dart' as _i423;
import 'package:luna_arc_sync/core/api/auth_interceptor.dart' as _i119;
import 'package:luna_arc_sync/core/api/error_handler_interceptor.dart' as _i824;
import 'package:luna_arc_sync/core/di/network_module.dart' as _i1016;
import 'package:luna_arc_sync/core/di/register_module.dart' as _i742;
import 'package:luna_arc_sync/core/scanner/scanner_config_service.dart'
    as _i454;
import 'package:luna_arc_sync/core/scanner/scanner_manager.dart' as _i511;
import 'package:luna_arc_sync/core/services/auto_login_service.dart' as _i728;
import 'package:luna_arc_sync/core/services/global_error_handler.dart' as _i690;
import 'package:luna_arc_sync/core/services/multi_account_service.dart'
    as _i1027;
import 'package:luna_arc_sync/core/services/network_status_service.dart'
    as _i378;
import 'package:luna_arc_sync/core/services/server_status_service.dart'
    as _i1067;
import 'package:luna_arc_sync/core/storage/image_cache_service.dart' as _i347;
import 'package:luna_arc_sync/core/storage/job_history_service.dart' as _i541;
import 'package:luna_arc_sync/core/storage/secure_storage_service.dart'
    as _i972;
import 'package:luna_arc_sync/core/storage/server_cache_service.dart' as _i142;
import 'package:luna_arc_sync/core/theme/background_image_notifier.dart'
    as _i562;
import 'package:luna_arc_sync/core/theme/font_notifier.dart' as _i402;
import 'package:luna_arc_sync/core/theme/glassmorphic_performance_notifier.dart'
    as _i962;
import 'package:luna_arc_sync/core/theme/theme_color_notifier.dart' as _i73;
import 'package:luna_arc_sync/data/repositories/about_repository.dart'
    as _i1061;
import 'package:luna_arc_sync/data/repositories/auth_repository.dart' as _i125;
import 'package:luna_arc_sync/data/repositories/data_transfer_repository.dart'
    as _i630;
import 'package:luna_arc_sync/data/repositories/document_repository.dart'
    as _i393;
import 'package:luna_arc_sync/data/repositories/job_repository.dart' as _i757;
import 'package:luna_arc_sync/data/repositories/page_repository.dart' as _i431;
import 'package:luna_arc_sync/data/repositories/search_repository.dart'
    as _i693;
import 'package:luna_arc_sync/data/repositories/user_repository.dart' as _i655;
import 'package:luna_arc_sync/presentation/about/cubit/about_cubit.dart'
    as _i630;
import 'package:luna_arc_sync/presentation/auth/cubit/auth_cubit.dart' as _i887;
import 'package:luna_arc_sync/presentation/documents/cubit/document_detail_cubit.dart'
    as _i614;
import 'package:luna_arc_sync/presentation/documents/cubit/document_list_cubit.dart'
    as _i921;
import 'package:luna_arc_sync/presentation/jobs/cubit/jobs_cubit.dart' as _i685;
import 'package:luna_arc_sync/presentation/overview/cubit/overview_cubit.dart'
    as _i287;
import 'package:luna_arc_sync/presentation/pages/cubit/page_detail_cubit.dart'
    as _i464;
import 'package:luna_arc_sync/presentation/pages/cubit/page_list_cubit.dart'
    as _i576;
import 'package:luna_arc_sync/presentation/pages/cubit/version_history_cubit.dart'
    as _i47;
import 'package:luna_arc_sync/presentation/scanner/cubit/scanner_management_cubit.dart'
    as _i307;
import 'package:luna_arc_sync/presentation/search/cubit/search_cubit.dart'
    as _i235;
import 'package:luna_arc_sync/presentation/settings/cubit/data_transfer_cubit.dart'
    as _i199;
import 'package:luna_arc_sync/presentation/settings/notifiers/grid_settings_notifier.dart'
    as _i22;
import 'package:luna_arc_sync/presentation/settings/notifiers/precaching_settings_notifier.dart'
    as _i751;
import 'package:luna_arc_sync/presentation/user/cubit/user_cubit.dart' as _i943;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    final networkModule = _$NetworkModule();
    gh.factory<_i824.ErrorHandlerInterceptor>(
      () => _i824.ErrorHandlerInterceptor(),
    );
    gh.factory<_i562.BackgroundImageNotifier>(
      () => _i562.BackgroundImageNotifier(),
    );
    gh.factory<_i402.FontNotifier>(() => _i402.FontNotifier());
    gh.factory<_i73.ThemeColorNotifier>(() => _i73.ThemeColorNotifier());
    await gh.singletonAsync<_i22.GridSettingsNotifier>(
      () => registerModule.gridSettingsNotifier(),
      preResolve: true,
    );
    await gh.singletonAsync<_i751.PrecachingSettingsNotifier>(
      () => registerModule.precachingSettingsNotifier(),
      preResolve: true,
    );
    await gh.singletonAsync<_i962.GlassmorphicPerformanceNotifier>(
      () => registerModule.glassmorphicPerformanceNotifier(),
      preResolve: true,
    );
    gh.lazySingleton<_i895.Connectivity>(() => networkModule.connectivity);
    await gh.lazySingletonAsync<_i347.ImageCacheService>(
      () => registerModule.imageCacheService(),
      preResolve: true,
    );
    gh.lazySingleton<_i511.ScannerManager>(
      () => registerModule.scannerManager(),
    );
    await gh.lazySingletonAsync<_i454.ScannerConfigService>(
      () => registerModule.scannerConfigService(),
      preResolve: true,
    );
    gh.lazySingleton<_i690.GlobalErrorHandler>(
      () => _i690.GlobalErrorHandler(),
    );
    gh.lazySingleton<_i1067.ServerStatusService>(
      () => _i1067.ServerStatusService(),
    );
    gh.lazySingleton<_i541.JobHistoryService>(() => _i541.JobHistoryService());
    gh.lazySingleton<_i972.SecureStorageService>(
      () => _i972.SecureStorageService(),
    );
    gh.lazySingleton<_i142.ServerCacheService>(
      () => _i142.ServerCacheService(),
    );
    gh.factory<_i307.ScannerManagementCubit>(
      () => _i307.ScannerManagementCubit(
        gh<_i511.ScannerManager>(),
        gh<_i454.ScannerConfigService>(),
      ),
    );
    gh.lazySingleton<_i378.NetworkStatusService>(
      () => _i378.NetworkStatusService(gh<_i895.Connectivity>()),
    );
    gh.lazySingleton<_i1027.MultiAccountService>(
      () => _i1027.MultiAccountService(gh<_i972.SecureStorageService>()),
    );
    gh.factory<_i119.AuthInterceptor>(
      () => _i119.AuthInterceptor(gh<_i972.SecureStorageService>()),
    );
    await gh.lazySingletonAsync<_i423.ApiClient>(
      () => registerModule.apiClient(
        gh<_i972.SecureStorageService>(),
        gh<_i119.AuthInterceptor>(),
        gh<_i824.ErrorHandlerInterceptor>(),
      ),
      preResolve: true,
    );
    gh.lazySingleton<_i125.IAuthRepository>(
      () => _i125.AuthRepository(
        gh<_i423.ApiClient>(),
        gh<_i972.SecureStorageService>(),
      ),
    );
    gh.lazySingleton<_i630.IDataTransferRepository>(
      () => _i630.DataTransferRepository(gh<_i423.ApiClient>()),
    );
    gh.lazySingleton<_i431.IPageRepository>(
      () => _i431.PageRepository(gh<_i423.ApiClient>()),
    );
    gh.lazySingleton<_i757.IJobRepository>(
      () => _i757.JobRepository(gh<_i423.ApiClient>()),
    );
    gh.lazySingleton<_i393.IDocumentRepository>(
      () => _i393.DocumentRepository(gh<_i423.ApiClient>()),
    );
    gh.factory<_i614.DocumentDetailCubit>(
      () => _i614.DocumentDetailCubit(
        gh<_i393.IDocumentRepository>(),
        gh<_i431.IPageRepository>(),
      ),
    );
    gh.lazySingleton<_i655.IUserRepository>(
      () => _i655.UserRepository(gh<_i423.ApiClient>()),
    );
    gh.factory<_i199.DataTransferCubit>(
      () => _i199.DataTransferCubit(gh<_i630.IDataTransferRepository>()),
    );
    gh.lazySingleton<_i1061.IAboutRepository>(
      () => _i1061.AboutRepository(gh<_i423.ApiClient>()),
    );
    gh.lazySingleton<_i693.ISearchRepository>(
      () => _i693.SearchRepository(gh<_i423.ApiClient>()),
    );
    gh.factory<_i235.SearchCubit>(
      () => _i235.SearchCubit(gh<_i693.ISearchRepository>()),
    );
    gh.factory<_i464.PageDetailCubit>(
      () => _i464.PageDetailCubit(
        gh<_i431.IPageRepository>(),
        gh<_i757.IJobRepository>(),
      ),
    );
    gh.lazySingleton<_i728.AutoLoginService>(
      () => _i728.AutoLoginService(
        gh<_i972.SecureStorageService>(),
        gh<_i125.IAuthRepository>(),
      ),
    );
    gh.factory<_i576.PageListCubit>(
      () => _i576.PageListCubit(gh<_i431.IPageRepository>()),
    );
    gh.factory<_i47.VersionHistoryCubit>(
      () => _i47.VersionHistoryCubit(gh<_i431.IPageRepository>()),
    );
    gh.factory<_i685.JobsCubit>(
      () => _i685.JobsCubit(
        gh<_i757.IJobRepository>(),
        gh<_i541.JobHistoryService>(),
        gh<_i972.SecureStorageService>(),
      ),
    );
    gh.factory<_i287.OverviewCubit>(
      () => _i287.OverviewCubit(
        gh<_i655.IUserRepository>(),
        gh<_i393.IDocumentRepository>(),
      ),
    );
    gh.lazySingleton<_i943.UserCubit>(
      () => _i943.UserCubit(gh<_i655.IUserRepository>()),
    );
    gh.factory<_i921.DocumentListCubit>(
      () => _i921.DocumentListCubit(
        gh<_i393.IDocumentRepository>(),
        gh<_i655.IUserRepository>(),
        gh<_i972.SecureStorageService>(),
      ),
    );
    gh.lazySingleton<_i887.AuthCubit>(
      () => _i887.AuthCubit(
        gh<_i125.IAuthRepository>(),
        gh<_i728.AutoLoginService>(),
        gh<_i142.ServerCacheService>(),
        gh<_i972.SecureStorageService>(),
        gh<_i423.ApiClient>(),
      ),
    );
    gh.factory<_i630.AboutCubit>(
      () => _i630.AboutCubit(gh<_i1061.IAboutRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i742.RegisterModule {}

class _$NetworkModule extends _i1016.NetworkModule {}
