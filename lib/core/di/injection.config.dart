// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:luna_arc_sync/core/api/api_client.dart' as _i423;
import 'package:luna_arc_sync/core/api/auth_interceptor.dart' as _i119;
import 'package:luna_arc_sync/core/di/register_module.dart' as _i742;
import 'package:luna_arc_sync/core/storage/secure_storage_service.dart'
    as _i972;
import 'package:luna_arc_sync/data/repositories/auth_repository.dart' as _i125;
import 'package:luna_arc_sync/data/repositories/document_repository.dart'
    as _i393;
import 'package:luna_arc_sync/data/repositories/job_repository.dart' as _i757;
import 'package:luna_arc_sync/data/repositories/page_repository.dart' as _i431;
import 'package:luna_arc_sync/data/repositories/user_repository.dart' as _i655;
import 'package:luna_arc_sync/presentation/auth/cubit/auth_cubit.dart' as _i887;
import 'package:luna_arc_sync/presentation/documents/cubit/document_detail_cubit.dart'
    as _i614;
import 'package:luna_arc_sync/presentation/documents/cubit/document_list_cubit.dart'
    as _i921;
import 'package:luna_arc_sync/presentation/overview/cubit/overview_cubit.dart'
    as _i287;
import 'package:luna_arc_sync/presentation/pages/cubit/page_detail_cubit.dart'
    as _i464;
import 'package:luna_arc_sync/presentation/pages/cubit/page_list_cubit.dart'
    as _i576;
import 'package:luna_arc_sync/presentation/pages/cubit/version_history_cubit.dart'
    as _i47;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i972.SecureStorageService>(
      () => _i972.SecureStorageService(),
    );
    gh.factory<_i119.AuthInterceptor>(
      () => _i119.AuthInterceptor(gh<_i972.SecureStorageService>()),
    );
    await gh.lazySingletonAsync<_i423.ApiClient>(
      () => registerModule.apiClient(
        gh<_i972.SecureStorageService>(),
        gh<_i119.AuthInterceptor>(),
      ),
      preResolve: true,
    );
    gh.lazySingleton<_i125.IAuthRepository>(
      () => _i125.AuthRepository(
        gh<_i423.ApiClient>(),
        gh<_i972.SecureStorageService>(),
      ),
    );
    gh.lazySingleton<_i431.IPageRepository>(
      () => _i431.PageRepository(gh<_i423.ApiClient>()),
    );
    gh.factory<_i887.AuthCubit>(
      () => _i887.AuthCubit(
        gh<_i125.IAuthRepository>(),
        gh<_i972.SecureStorageService>(),
      ),
    );
    gh.lazySingleton<_i757.IJobRepository>(
      () => _i757.JobRepository(gh<_i423.ApiClient>()),
    );
    gh.lazySingleton<_i393.IDocumentRepository>(
      () => _i393.DocumentRepository(gh<_i423.ApiClient>()),
    );
    gh.lazySingleton<_i655.IUserRepository>(
      () => _i655.UserRepository(gh<_i423.ApiClient>()),
    );
    gh.factory<_i921.DocumentListCubit>(
      () => _i921.DocumentListCubit(gh<_i393.IDocumentRepository>()),
    );
    gh.factory<_i464.PageDetailCubit>(
      () => _i464.PageDetailCubit(
        gh<_i431.IPageRepository>(),
        gh<_i757.IJobRepository>(),
      ),
    );
    gh.factory<_i576.PageListCubit>(
      () => _i576.PageListCubit(gh<_i431.IPageRepository>()),
    );
    gh.factory<_i47.VersionHistoryCubit>(
      () => _i47.VersionHistoryCubit(gh<_i431.IPageRepository>()),
    );
    gh.factory<_i287.OverviewCubit>(
      () => _i287.OverviewCubit(
        gh<_i655.IUserRepository>(),
        gh<_i393.IDocumentRepository>(),
      ),
    );
    gh.factory<_i614.DocumentDetailCubit>(
      () => _i614.DocumentDetailCubit(
        gh<_i393.IDocumentRepository>(),
        gh<_i431.IPageRepository>(),
        gh<_i757.IJobRepository>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i742.RegisterModule {}
