import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luna_arc_sync/core/api/api_client.dart';
import 'package:luna_arc_sync/core/di/injection.dart';
import 'package:luna_arc_sync/core/storage/secure_storage_service.dart';
import 'package:luna_arc_sync/core/storage/server_cache_service.dart';
import 'package:luna_arc_sync/data/models/about_models.dart';
import 'package:luna_arc_sync/l10n/app_localizations.dart';
import 'package:luna_arc_sync/presentation/auth/cubit/auth_cubit.dart';
import 'package:luna_arc_sync/presentation/auth/cubit/auth_state.dart';
import 'package:luna_arc_sync/presentation/auth/view/register_Page.dart';
import 'package:luna_arc_sync/presentation/auth/widgets/server_card.dart';
import 'package:luna_arc_sync/presentation/widgets/custom_animated_logo_banner.dart';

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

  // Get instances from GetIt
  final _storageService = getIt<SecureStorageService>();
  final _apiClient = getIt<ApiClient>();
  final _serverCacheService = getIt<ServerCacheService>();

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
      });
    } catch (e) {
      debugPrint('🔍 加载缓存服务器失败: $e');
    }
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
      // 1. 构建完整的服务器 URL
      debugPrint('🔍 自动登录 - 服务器URL: $serverUrl');

      // 2. Save the server URL
      await _storageService.saveServerUrl(serverUrl);

      // 3. Update the ApiClient's base URL in real-time
      _apiClient.setBaseUrl(serverUrl);

      // 4. 获取存储的凭据
      final email = await _storageService.getEmail();
      final password = await _storageService.getPassword();

      debugPrint('🔍 自动登录 - 获取到的凭据: email=${email != null ? "有" : "无"}, password=${password != null ? "有" : "无"}');

      if (email == null || password == null) {
        debugPrint('🔍 自动登录失败 - 没有存储的凭据');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.loginManualLoginRequired),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // 5. 获取服务器信息并缓存
      try {
        final aboutResponse = await _apiClient.dio.get('/api/about');
        final about = AboutResponse.fromJson(aboutResponse.data);
        
        // 缓存服务器信息，包含服务器URL
        final serverId = about.serverId ?? about.serverName.hashCode.toString();
        await _serverCacheService.cacheServerInfo(serverId, about, serverUrl: serverUrl);
        
        // 重新加载服务器列表
        await _loadCachedServers();
      } catch (e) {
        debugPrint('🔍 获取服务器信息失败: $e');
      }

      // 6. 自动填充表单
      setState(() {
        _emailController.text = email;
        _passwordController.text = password;
      });

      // 7. Trigger the login process
      if (mounted) {
        context.read<AuthCubit>().login(email, password);
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
      }
    }
  }

  Future<void> _deleteServer(CachedServerInfo serverInfo) async {
    final serverId = serverInfo.about.serverId ?? serverInfo.about.serverName.hashCode.toString();
    
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
      debugPrint('🔍 登录调试 - 用户输入: $ipPort');
      debugPrint('🔍 登录调试 - 构建的完整URL: $serverUrl');

      // 2. Save the server URL
      await _storageService.saveServerUrl(serverUrl);

      // 3. Update the ApiClient's base URL in real-time
      _apiClient.setBaseUrl(serverUrl);

      // 4. 获取服务器信息并缓存
      try {
        final aboutResponse = await _apiClient.dio.get('/api/about');
        final about = AboutResponse.fromJson(aboutResponse.data);
        
        // 缓存服务器信息，包含服务器URL
        final serverId = about.serverId ?? about.serverName.hashCode.toString();
        await _serverCacheService.cacheServerInfo(serverId, about, serverUrl: serverUrl);
        
        // 重新加载服务器列表
        await _loadCachedServers();
      } catch (e) {
        debugPrint('🔍 获取服务器信息失败: $e');
      }

      // 5. 保存登录凭据
      await _storageService.saveEmail(email);
      await _storageService.savePassword(password);

      // 6. Trigger the login process
      if (mounted) {
        context.read<AuthCubit>().login(email, password);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          state.whenOrNull(
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
    );
  }

  Widget _buildLoginForm() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 自定义动画Logo横幅 - 无背景logo + 蓝色分割符 + 泠月案阁文字
              const CustomAnimatedLogoBanner(
                height: 120,
                animationDuration: Duration(milliseconds: 1200),
                delayBetweenSteps: Duration(milliseconds: 400),
              ),
              const SizedBox(height: 40),
              
              // 缓存的服务器列表
              if (_cachedServers.isNotEmpty) ...[
                Text(
                  AppLocalizations.of(context)!.loginSelectServer,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ...(_cachedServers.map((server) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ServerCard(
                    serverInfo: server,
                    onTap: () => _selectServer(server),
                    onLongPress: () => _deleteServer(server),
                  ),
                ))),
                const SizedBox(height: 24),
              ],
              
              // 可折叠的登录信息卡片
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // 卡片头部 - 可点击展开/收起
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.settings,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              AppLocalizations.of(context)!.loginAddServer,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            AnimatedRotation(
                              turns: _isExpanded ? 0.5 : 0,
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // 可折叠的内容区域
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      height: _isExpanded ? null : 0,
                      child: _isExpanded
                          ? Form(
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

                                        return ElevatedButton(
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
                                    TextButton(
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
                            )
                          : const SizedBox.shrink(),
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
}
