import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luna_arc_sync/core/api/api_client.dart';
import 'package:luna_arc_sync/core/di/injection.dart';
import 'package:luna_arc_sync/core/storage/secure_storage_service.dart';
import 'package:luna_arc_sync/core/storage/server_cache_service.dart';
import 'package:luna_arc_sync/core/services/server_status_service.dart';
import 'package:luna_arc_sync/data/models/about_models.dart';
import 'package:luna_arc_sync/l10n/app_localizations.dart';
import 'package:luna_arc_sync/presentation/auth/cubit/auth_cubit.dart';
import 'package:luna_arc_sync/presentation/auth/cubit/auth_state.dart';
import 'package:luna_arc_sync/presentation/auth/view/register_Page.dart';
import 'package:luna_arc_sync/presentation/auth/widgets/server_card.dart';
import 'package:luna_arc_sync/presentation/widgets/custom_animated_logo_banner.dart';
import 'package:luna_arc_sync/core/animations/animated_page_content.dart';
import 'package:luna_arc_sync/core/animations/animated_list_item.dart';
import 'package:luna_arc_sync/core/animations/animated_button.dart';
import 'package:luna_arc_sync/core/animations/expandable_card.dart';

class LoginPage extends StatefulWidget {
  final String? initialServerUrl;
  
  const LoginPage({super.key, this.initialServerUrl});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _serverUrlController = TextEditingController();
  
  // 控制可折叠卡片的展开状态 - 当没有缓存服务器时默认展开
  bool _isExpanded = false;
  
  // 缓存的服务器列表
  List<CachedServerInfo> _cachedServers = [];
  
  // 服务器状态映射 (serverId -> ServerStatus)
  Map<String, ServerStatus> _serverStatuses = {};
  
  // 登录成功状态
  bool _showLoginSuccess = false;

  // Get instances from GetIt
  final _storageService = getIt<SecureStorageService>();
  final _apiClient = getIt<ApiClient>();
  final _serverCacheService = getIt<ServerCacheService>();
  final _serverStatusService = getIt<ServerStatusService>();

  @override
  void initState() {
    super.initState();
    _loadServerUrl();
    _loadCachedServers();
  }

  Future<void> _loadServerUrl() async {
    if (widget.initialServerUrl != null) {
      setState(() {
        _serverUrlController.text = _extractIpPort(widget.initialServerUrl!);
      });
    } else {
      final storedUrl = await _storageService.getServerUrl();
      if (storedUrl != null) {
        setState(() {
          _serverUrlController.text = _extractIpPort(storedUrl);
        });
      }
    }
  }

  Future<void> _loadCachedServers() async {
    try {
      final servers = await _serverCacheService.getAllFullServerInfo();
      setState(() {
        _cachedServers = servers;
        // 当没有缓存服务器时默认展开卡片
        _isExpanded = servers.isEmpty;
        // 初始化所有服务器状态为检查中
        _serverStatuses = {
          for (var server in servers)
            _getServerId(server): ServerStatus.checking,
        };
      });
      
      // 异步检查服务器状态
      if (servers.isNotEmpty) {
        _checkServersStatus(servers);
      }
    } catch (e) {
      debugPrint('🔍 加载缓存服务器失败: $e');
    }
  }
  
  // 检查服务器状态
  Future<void> _checkServersStatus(List<CachedServerInfo> servers) async {
    try {
      debugPrint('🔍 开始检查 ${servers.length} 个服务器的状态');
      final statusMap = await _serverStatusService.checkMultipleServers(servers);
      
      if (mounted) {
        setState(() {
          _serverStatuses = {
            for (var entry in statusMap.entries)
              entry.key: entry.value.status,
          };
        });
      }
      
      debugPrint('🔍 服务器状态检查完成');
    } catch (e) {
      debugPrint('🔍 检查服务器状态失败: $e');
    }
  }
  
  // 获取服务器ID
  String _getServerId(CachedServerInfo serverInfo) {
    return serverInfo.serverUrl != null
        ? ServerCacheService.getServerId(serverInfo.about, serverInfo.serverUrl!)
        : (serverInfo.about.serverId ?? serverInfo.about.serverName.hashCode.toString());
  }

  Future<void> _selectServer(CachedServerInfo serverInfo) async {
    debugPrint('🔍 选择服务器: ${serverInfo.about.serverName}');
    if (serverInfo.serverUrl != null) {
      setState(() {
        _serverUrlController.text = _extractIpPort(serverInfo.serverUrl!);
      });
      debugPrint('🔍 已设置服务器地址: ${_serverUrlController.text}');
      
      // 自动尝试登录
      await _handleAutoLogin(serverInfo.serverUrl!);
    } else {
      debugPrint('🔍 服务器URL为空');
    }
  }

  Future<void> _handleAutoLogin(String serverUrl) async {
    try {
      debugPrint('🔍 选择服务器 - 准备自动登录: $serverUrl');

      // 1. 保存并设置服务器 URL
      await _storageService.saveServerUrl(serverUrl);
      _apiClient.setBaseUrl(serverUrl);

      // 2. 获取服务器信息并缓存
      try {
        final aboutResponse = await _apiClient.dio.get('/api/about');
        final about = AboutResponse.fromJson(aboutResponse.data);
        
        // 使用服务器返回的 serverId（如果有）或基于 URL 生成
        await _serverCacheService.cacheServerInfo(about, serverUrl: serverUrl);
        
        // 重新加载服务器列表
        await _loadCachedServers();
      } catch (e) {
        debugPrint('🔍 获取服务器信息失败: $e');
      }

      // 3. 检查是否有存储的凭据
      final hasCredentials = await context.read<AuthCubit>().hasStoredCredentials();
      
      if (!hasCredentials) {
        debugPrint('🔍 没有存储的凭据 - 需要手动登录');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.loginManualLoginRequired),
              backgroundColor: Colors.orange,
            ),
          );
          // 展开登录表单
          setState(() {
            _isExpanded = true;
          });
        }
        return;
      }

      // 4. 使用 AuthCubit 的自动登录功能
      if (mounted) {
        await context.read<AuthCubit>().attemptAutoLogin();
      }
    } catch (e) {
      debugPrint('🔍 自动登录失败: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.loginAutoLoginFailed(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
        // 展开登录表单让用户手动登录
        setState(() {
          _isExpanded = true;
        });
      }
    }
  }

  Future<void> _deleteServer(CachedServerInfo serverInfo) async {
    // 使用服务器信息生成 serverId
    final serverId = serverInfo.serverUrl != null
        ? ServerCacheService.getServerId(serverInfo.about, serverInfo.serverUrl!)
        : (serverInfo.about.serverId ?? serverInfo.about.serverName.hashCode.toString());
    
    // 显示确认对话框
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.loginDeleteServer),
        content: Text(AppLocalizations.of(context)!.loginDeleteServerConfirm(serverInfo.about.serverName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _serverCacheService.removeServerCache(serverId);
        await _loadCachedServers();
        debugPrint('🔍 已删除服务器: ${serverInfo.about.serverName}');
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.loginServerDeleted(serverInfo.about.serverName)),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        debugPrint('🔍 删除服务器失败: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.loginDeleteServerFailed(e.toString())),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  String _extractIpPort(String fullUrl) {
    try {
      final uri = Uri.parse(fullUrl);
      return '${uri.host}:${uri.port}';
    } catch (e) {
      return fullUrl; // 如果解析失败，返回原值
    }
  }

  String _buildFullUrl(String ipPort) {
    final trimmed = ipPort.trim();
    if (trimmed.isEmpty) return '';
    
    // 如果已经包含协议，直接返回
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    
    // 否则添加 https:// 前缀
    return 'https://$trimmed';
  }


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _serverUrlController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final ipPort = _serverUrlController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      // 1. 构建完整的服务器 URL
      final serverUrl = _buildFullUrl(ipPort);
      debugPrint('🔍 登录 - 用户输入: $ipPort');
      debugPrint('🔍 登录 - 构建的完整URL: $serverUrl');

      // 2. 保存并设置服务器 URL
      await _storageService.saveServerUrl(serverUrl);
      _apiClient.setBaseUrl(serverUrl);

      // 3. 获取服务器信息并缓存
      try {
        final aboutResponse = await _apiClient.dio.get('/api/about');
        final about = AboutResponse.fromJson(aboutResponse.data);
        
        // 使用服务器返回的 serverId（如果有）或基于 URL 生成
        await _serverCacheService.cacheServerInfo(about, serverUrl: serverUrl);
        
        // 重新加载服务器列表
        await _loadCachedServers();
      } catch (e) {
        debugPrint('🔍 获取服务器信息失败: $e');
      }

      // 4. 使用 AuthCubit 登录（会自动保存凭据）
      if (mounted) {
        context.read<AuthCubit>().login(
          email,
          password,
          saveCredentials: true, // 保存凭据以支持自动登录
        );
      }
      
      // 注：登录成功后的用户信息保存已在AuthCubit中自动处理
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              state.whenOrNull(
                authenticated: (userId, isAdmin, role) {
                  // 显示登录成功动画
                  setState(() {
                    _showLoginSuccess = true;
                  });
                },
                unauthenticated: (isLoading, error) {
                  if (error != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(error),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              );
            },
            child: _buildLoginForm(),
          ),
          // 登录成功过渡动画
          LoginSuccessTransition(
            show: _showLoginSuccess,
            message: AppLocalizations.of(context)!.loginSuccess,
            onComplete: () {
              // 动画完成后导航会自动触发（通过AuthCubit的状态改变）
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: StaggeredAnimatedColumn(
            staggerDelay: const Duration(milliseconds: 80),
            itemDuration: const Duration(milliseconds: 600),
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 自定义动画Logo横幅 - 无背景logo + 蓝色分割符 + 泠月案阁文字
              const CustomAnimatedLogoBanner(
                height: 120,
                animationDuration: Duration(milliseconds: 400),
                delayBetweenSteps: Duration(milliseconds: 200),
              ),
              const SizedBox(height: 40),
              
              // 缓存的服务器列表
              if (_cachedServers.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.loginSelectServer,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...(_cachedServers.asMap().entries.map((entry) {
                      final index = entry.key;
                      final server = entry.value;
                      final serverId = _getServerId(server);
                      final status = _serverStatuses[serverId];
                      return AnimatedListItem(
                        index: index,
                        delay: const Duration(milliseconds: 100),
                        duration: const Duration(milliseconds: 500),
                        animationType: AnimationType.fadeSlideRight,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: ServerCard(
                            serverInfo: server,
                            status: status,
                            onTap: () => _selectServer(server),
                            onLongPress: () => _deleteServer(server),
                          ),
                        ),
                      );
                    })),
                    const SizedBox(height: 24),
                  ],
                ),
              
              // 可折叠的登录信息卡片
              ExpandableCard(
                isExpanded: _isExpanded,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOutCubic,
                header: ExpandableCardHeader(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  isExpanded: _isExpanded,
                  leadingIcon: Icons.add_circle_outline,
                  title: AppLocalizations.of(context)!.loginAddServer,
                  animationDuration: const Duration(milliseconds: 400),
                ),
                content: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                                  children: [
                                    // 服务器地址输入
                                    TextFormField(
                                      controller: _serverUrlController,
                                      decoration: InputDecoration(
                                        labelText: AppLocalizations.of(context)!.loginServerAddress,
                                        hintText: AppLocalizations.of(context)!.loginServerAddressHint,
                                        helperText: AppLocalizations.of(context)!.loginServerAddressHelper,
                                        prefixIcon: const Icon(Icons.dns),
                                      ),
                                      keyboardType: TextInputType.url,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return AppLocalizations.of(context)!.loginServerAddressRequired;
                                        }
                                        // 验证 ip:port 格式
                                        final trimmed = value.trim();
                                        if (!trimmed.contains(':')) {
                                          return AppLocalizations.of(context)!.loginServerAddressInvalidFormat;
                                        }
                                        final parts = trimmed.split(':');
                                        if (parts.length != 2) {
                                          return AppLocalizations.of(context)!.loginServerAddressInvalidParts;
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    
                                    // 邮箱输入
                                    TextFormField(
                                      controller: _emailController,
                                      decoration: InputDecoration(
                                        labelText: AppLocalizations.of(context)!.loginEmail,
                                        prefixIcon: const Icon(Icons.email),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value == null || !value.contains('@')) {
                                          return AppLocalizations.of(context)!.loginEmailRequired;
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    
                                    // 密码输入
                                    TextFormField(
                                      controller: _passwordController,
                                      decoration: InputDecoration(
                                        labelText: AppLocalizations.of(context)!.loginPassword,
                                        prefixIcon: const Icon(Icons.lock),
                                      ),
                                      obscureText: true,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return AppLocalizations.of(context)!.loginPasswordRequired;
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 24),
                                    
                                    // 登录按钮
                                    BlocBuilder<AuthCubit, AuthState>(
                                      builder: (context, state) {
                                        final isLoading = state.maybeWhen(
                                          unauthenticated: (isLoading, error) => isLoading,
                                          orElse: () => false,
                                        );

                                        return AnimatedElevatedButton(
                                          onPressed: isLoading ? null : _handleLogin,
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(vertical: 16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: isLoading
                                              ? const SizedBox(
                                                  width: 24,
                                                  height: 24,
                                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                                )
                                              : Text(AppLocalizations.of(context)!.loginButton),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    
                                    // 注册按钮
                                    AnimatedTextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(MaterialPageRoute(
                                          builder: (_) => const RegisterPage(),
                                        ));
                                      },
                                      child: Text(AppLocalizations.of(context)!.loginRegisterPrompt),
                                    ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
