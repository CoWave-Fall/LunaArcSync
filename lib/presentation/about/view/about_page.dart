import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luna_arc_sync/core/api/api_client.dart';
import 'package:luna_arc_sync/core/di/injection.dart';
import 'package:luna_arc_sync/core/storage/server_cache_service.dart';
import 'package:luna_arc_sync/data/models/about_models.dart';
import 'package:luna_arc_sync/l10n/app_localizations.dart';
import 'package:luna_arc_sync/presentation/about/cubit/about_cubit.dart';
import 'package:luna_arc_sync/presentation/auth/cubit/auth_cubit.dart';
import 'package:luna_arc_sync/presentation/auth/cubit/auth_state.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:luna_arc_sync/core/animations/animated_page_content.dart';
import 'package:provider/provider.dart';
import 'package:luna_arc_sync/core/theme/background_image_notifier.dart';
import 'package:luna_arc_sync/presentation/widgets/glassmorphic_container.dart';
import 'package:luna_arc_sync/core/theme/no_overscroll_behavior.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String _currentTitle = '';
  Timer? _titleTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 在didChangeDependencies中调用，确保InheritedWidget已经可用
    _updateTitle();
    _startTitleTimer();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _titleTimer?.cancel();
    super.dispose();
  }

  void _updateTitle() {
    final now = DateTime.now();
    final hour = now.hour;
    final l10n = AppLocalizations.of(context)!;
    
    String greeting;
    if (hour < 12) {
      greeting = l10n.goodMorning;
    } else if (hour < 18) {
      greeting = l10n.goodAfternoon;
    } else {
      greeting = l10n.goodEvening;
    }
    
    // 先淡出，然后更新标题，再淡入
    _animationController.reverse().then((_) {
      setState(() {
        _currentTitle = greeting;
      });
      _animationController.forward();
    });
  }

  void _startTitleTimer() {
    _titleTimer = Timer(const Duration(seconds: 3), () {
      final l10n = AppLocalizations.of(context)!;
      // 先淡出，然后更新标题，再淡入
      _animationController.reverse().then((_) {
        setState(() {
          _currentTitle = l10n.aboutAppBarTitle;
        });
        _animationController.forward();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasCustomBackground = context.watch<BackgroundImageNotifier>().hasCustomBackground;
    
    return BlocProvider(
      create: (context) => getIt<AboutCubit>()..loadAbout(),
      child: Scaffold(
        backgroundColor: hasCustomBackground ? Colors.transparent : null,
        body: ScrollConfiguration(
          behavior: hasCustomBackground 
              ? const GlassmorphicScrollBehavior() 
              : ScrollConfiguration.of(context).copyWith(),
          child: CustomScrollView(
            slivers: [
              SliverAppBar.large(
                backgroundColor: hasCustomBackground ? Colors.transparent : null,
                title: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(_currentTitle),
                  );
                },
              ),
            ),
            BlocBuilder<AboutCubit, AboutState>(
              builder: (context, state) {
                return state.when(
                  initial: () => const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  loading: () => const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  loaded: (about) => _buildAboutContent(context, about),
                  error: (message, isConnectionError, isAuthError) => SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isConnectionError 
                                  ? Icons.cloud_off 
                                  : isAuthError 
                                      ? Icons.lock_outline 
                                      : Icons.error_outline,
                              size: 64,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              isConnectionError 
                                  ? l10n.connectionErrorTitle
                                  : isAuthError 
                                      ? l10n.authErrorTitle
                                      : l10n.errorLoadingAbout,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              message,
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // 重试按钮
                                ElevatedButton.icon(
                                  onPressed: () => context.read<AboutCubit>().loadAbout(),
                                  icon: const Icon(Icons.refresh),
                                  label: Text(l10n.retryButton),
                                ),
                                const SizedBox(width: 16),
                                // 返回登录页按钮（连接错误或认证错误时显示）
                                if (isConnectionError || isAuthError)
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      // 清除会话并登出
                                      context.read<AuthCubit>().logout(clearCredentials: false);
                                    },
                                    icon: const Icon(Icons.login),
                                    label: Text(l10n.backToLogin),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildAboutContent(BuildContext context, AboutResponse about) {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          AnimatedPageContent(
            delay: const Duration(milliseconds: 100),
            duration: const Duration(milliseconds: 500),
            child: _buildServerInfoCard(context, about),
          ),
          const SizedBox(height: 16),
          AnimatedPageContent(
            delay: const Duration(milliseconds: 250),
            duration: const Duration(milliseconds: 500),
            child: _buildUserAccountCard(context),
          ),
          const SizedBox(height: 16),
          AnimatedPageContent(
            delay: const Duration(milliseconds: 400),
            duration: const Duration(milliseconds: 500),
            child: _buildClientInfoCard(context, about),
          ),
        ]),
      ),
    );
  }

  Widget _buildServerInfoCard(BuildContext context, AboutResponse about) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return GlassmorphicCard(
      blur: 15.0,
      opacity: 0.2,
      padding: const EdgeInsets.all(20.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.aboutServerInfo,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: theme.colorScheme.primaryContainer,
                  ),
                  child: about.serverIcon.isNotEmpty
                      ? FutureBuilder<String?>(
                          future: _getCachedServerIcon(about.serverIcon),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.dns, color: theme.colorScheme.primary),
                                ),
                              );
                            } else {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  _buildServerIconUrl(about.serverIcon),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.dns, color: theme.colorScheme.primary),
                                ),
                              );
                            }
                          },
                        )
                      : Icon(Icons.dns, color: theme.colorScheme.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        about.serverName,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        about.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              Icons.link,
              l10n.aboutContact,
              about.contact,
              isLink: true,
            ),
          ],
        ),
      );
  }

  Widget _buildUserAccountCard(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return GlassmorphicCard(
      blur: 15.0,
      opacity: 0.2,
      padding: const EdgeInsets.all(20.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.aboutUserAccount,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return state.when(
                      initial: () => const SizedBox.shrink(),
                      authenticated: (userId) => IconButton(
                        icon: const Icon(Icons.logout),
                        tooltip: l10n.logoutButtonTooltip,
                        onPressed: () {
                          context.read<AuthCubit>().logout();
                        },
                      ),
                      unauthenticated: (isLoading, error) => const SizedBox.shrink(),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return state.when(
                  initial: () => _buildInfoRow(
                    context,
                    Icons.person,
                    l10n.aboutLoginStatus,
                    l10n.aboutChecking,
                  ),
                  authenticated: (userId) => Column(
                    children: [
                      _buildInfoRow(
                        context,
                        Icons.person,
                        l10n.aboutLoginStatus,
                        l10n.aboutLoggedIn,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        context,
                        Icons.badge,
                        l10n.aboutUserId,
                        userId,
                      ),
                    ],
                  ),
                  unauthenticated: (isLoading, error) => _buildInfoRow(
                    context,
                    Icons.person_off,
                    l10n.aboutLoginStatus,
                    l10n.aboutNotLoggedIn,
                  ),
                );
              },
            ),
          ],
        ),
      );
    
  }

  Widget _buildClientInfoCard(BuildContext context, AboutResponse about) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return GlassmorphicCard(
      blur: 15.0,
      opacity: 0.2,
      padding: const EdgeInsets.all(20.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.aboutClientInfo,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final packageInfo = snapshot.data!;
                  return Column(
                    children: [
                      _buildInfoRow(
                        context,
                        Icons.apps,
                        l10n.aboutAppName,
                        about.appName,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        context,
                        Icons.info_outline,
                        l10n.aboutVersion,
                        '${packageInfo.version} (${packageInfo.buildNumber})',
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        context,
                        Icons.code,
                        l10n.aboutPackageName,
                        packageInfo.packageName,
                      ),
                      const SizedBox(height: 12),
                      FutureBuilder<Map<String, String>>(
                        future: _getDeviceInfo(),
                        builder: (context, deviceSnapshot) {
                          if (deviceSnapshot.hasData) {
                            final deviceInfo = deviceSnapshot.data!;
                            return Column(
                              children: [
                                _buildInfoRow(
                                  context,
                                  Icons.phone_android,
                                  l10n.aboutDeviceModel,
                                  deviceInfo['model'] ?? l10n.aboutUnknown,
                                ),
                                const SizedBox(height: 12),
                                _buildInfoRow(
                                  context,
                                  Icons.memory,
                                  l10n.aboutDeviceOS,
                                  deviceInfo['os'] ?? l10n.aboutUnknown,
                                ),
                              ],
                            );
                          }
                          return _buildInfoRow(
                            context,
                            Icons.phone_android,
                            l10n.aboutDeviceInfo,
                            l10n.aboutLoading,
                          );
                        },
                      ),
                    ],
                  );
                }
                return _buildInfoRow(
                  context,
                  Icons.info_outline,
                  l10n.aboutAppInfo,
                  l10n.aboutLoading,
                );
              },
            ),
          ],
        ),
      );
    
  }

  Future<Map<String, String>> _getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    final Map<String, String> info = {};
    
    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        info['model'] = '${androidInfo.brand} ${androidInfo.model}';
        info['os'] = 'Android ${androidInfo.version.release}';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        info['model'] = '${iosInfo.name} ${iosInfo.model}';
        info['os'] = 'iOS ${iosInfo.systemVersion}';
      } else if (Platform.isWindows) {
        final windowsInfo = await deviceInfo.windowsInfo;
        info['model'] = windowsInfo.computerName;
        info['os'] = 'Windows ${windowsInfo.displayVersion}';
      } else if (Platform.isMacOS) {
        final macInfo = await deviceInfo.macOsInfo;
        info['model'] = macInfo.computerName;
        info['os'] = 'macOS ${macInfo.osRelease}';
      } else if (Platform.isLinux) {
        final linuxInfo = await deviceInfo.linuxInfo;
        info['model'] = linuxInfo.name;
        info['os'] = 'Linux ${linuxInfo.version}';
      }
    } catch (e) {
      info['model'] = 'Unknown';
      info['os'] = 'Unknown';
    }
    
    return info;
  }

  String _buildServerIconUrl(String serverIcon) {
    // 如果 serverIcon 已经是完整的 URL，直接返回
    if (serverIcon.startsWith('http://') || serverIcon.startsWith('https://')) {
      debugPrint('🔍 服务器图标调试 - 完整URL: $serverIcon');
      return serverIcon;
    }
    
    // 获取当前 API 客户端的基础 URL
    final apiClient = getIt<ApiClient>();
    final baseUrl = apiClient.getBaseUrl();
    
    debugPrint('🔍 服务器图标调试 - 原始serverIcon: $serverIcon');
    debugPrint('🔍 服务器图标调试 - 当前baseUrl: $baseUrl');
    
    if (baseUrl.isEmpty) {
      debugPrint('🔍 服务器图标调试 - baseUrl为空，返回原始值: $serverIcon');
      return serverIcon; // 如果没有基础 URL，返回原始值
    }
    
    // 构建完整的图标 URL
    // 服务器图标路径：https://ip:port/images/...
    final normalizedBaseUrl = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
    final normalizedServerIcon = serverIcon.startsWith('/') ? serverIcon.substring(1) : serverIcon;
    
    // 如果 serverIcon 已经是 /images/... 格式，直接拼接
    // 如果 serverIcon 是相对路径，需要添加 /images/ 前缀
    String finalPath;
    if (normalizedServerIcon.startsWith('images/')) {
      finalPath = normalizedServerIcon;
    } else {
      finalPath = 'images/$normalizedServerIcon';
    }
    
    final finalUrl = '$normalizedBaseUrl$finalPath';
    debugPrint('🔍 服务器图标调试 - 最终请求路径: $finalUrl');
    
    return finalUrl;
  }

  // 获取缓存的服务器图标
  Future<String?> _getCachedServerIcon(String serverIcon) async {
    try {
      final serverCacheService = getIt<ServerCacheService>();
      final apiClient = getIt<ApiClient>();
      final baseUrl = apiClient.getBaseUrl();
      
      if (baseUrl.isEmpty) return null;
      
      // 从baseUrl中提取服务器标识符
      final uri = Uri.parse(baseUrl);
      final serverId = '${uri.host}:${uri.port}';
      
      // 获取缓存的服务器信息
      final cachedAbout = await serverCacheService.getCachedServerInfo(serverId);
      if (cachedAbout != null && cachedAbout.serverIcon.isNotEmpty) {
        return _buildServerIconUrl(cachedAbout.serverIcon);
      }
    } catch (e) {
      debugPrint('🔍 获取缓存服务器图标失败: $e');
    }
    return null;
  }


  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    bool isLink = false,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              if (isLink)
                GestureDetector(
                  onTap: () {
                    // Handle link tap - you might want to use url_launcher
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Opening: $value')),
                    );
                  },
                  child: Text(
                    value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              else
                Text(
                  value,
                  style: theme.textTheme.bodyMedium,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
