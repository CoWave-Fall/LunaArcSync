import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:luna_arc_sync/presentation/user/cubit/user_cubit.dart';
import 'package:luna_arc_sync/presentation/user/cubit/user_state.dart';
import 'package:luna_arc_sync/presentation/user/widgets/user_profile_form.dart';
import 'package:luna_arc_sync/presentation/user/widgets/user_info_card.dart';
import 'package:luna_arc_sync/presentation/user/widgets/admin_only_widget.dart';
import 'package:luna_arc_sync/presentation/widgets/optimized_glassmorphic_container.dart';
import 'package:luna_arc_sync/core/theme/background_image_notifier.dart';
import 'package:luna_arc_sync/core/theme/glassmorphic_performance_notifier.dart';
import 'package:luna_arc_sync/core/config/glassmorphic_presets.dart';
import 'package:luna_arc_sync/core/theme/no_overscroll_behavior.dart';
import 'package:luna_arc_sync/core/cache/glassmorphic_cache.dart';
import 'package:luna_arc_sync/data/models/user_models.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    // 获取当前用户信息
    context.read<UserCubit>().getCurrentUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    final hasCustomBackground = context.watch<BackgroundImageNotifier>().hasCustomBackground;
    
    return Scaffold(
      backgroundColor: hasCustomBackground ? Colors.transparent : null,
      body: ScrollConfiguration(
        behavior: hasCustomBackground 
            ? const GlassmorphicScrollBehavior() 
            : ScrollConfiguration.of(context).copyWith(),
        child: BlocConsumer<UserCubit, UserState>(
          listener: (context, state) {
            state.maybeWhen(
              error: (message) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              },
              orElse: () {},
            );
          },
          builder: (context, state) {
            return state.when(
              initial: () => const Center(child: CircularProgressIndicator()),
              loading: () => const Center(child: CircularProgressIndicator()),
              currentUserLoaded: (user) => _buildUserProfile(context, user, hasCustomBackground),
              allUsersLoaded: (users) => const Center(child: CircularProgressIndicator()),
              userDetailsLoaded: (user) => _buildUserProfile(context, user, hasCustomBackground),
              adminStatsLoaded: (stats) => const Center(child: CircularProgressIndicator()),
              dataLoaded: (currentUser, allUsers, adminStats) => _buildUserProfile(context, currentUser, hasCustomBackground),
              error: (message) => _buildErrorState(message),
            );
          },
        ),
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context, user, bool hasCustomBackground) {
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          backgroundColor: hasCustomBackground ? Colors.transparent : null,
          title: const Text('用户信息'),
          actions: [
            if (!_isEditing)
              IconButton(
                onPressed: () {
                  setState(() {
                    _isEditing = true;
                  });
                },
                icon: const Icon(Icons.edit),
                tooltip: '编辑',
              )
            else
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = false;
                      });
                    },
                    child: const Text('取消'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = false;
                      });
                    },
                    child: const Text('保存'),
                  ),
                ],
              ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // 用户信息卡片
              _buildUserInfoCard(context, user, hasCustomBackground),
              
              const SizedBox(height: 24),
              
              // 管理员功能（仅管理员可见）
              AdminOnlyWidget(
                child: _buildAdminSection(context, hasCustomBackground),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildAdminSection(BuildContext context, bool hasCustomBackground) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        final adminStats = state.maybeWhen(
          dataLoaded: (currentUser, allUsers, adminStats) => adminStats,
          adminStatsLoaded: (stats) => stats,
          orElse: () => null,
        );

        final allUsers = state.maybeWhen(
          dataLoaded: (currentUser, allUsers, adminStats) => allUsers ?? <AdminUserListDto>[],
          allUsersLoaded: (users) => users,
          orElse: () => <AdminUserListDto>[],
        );

        // 如果管理员数据还没有加载，则触发加载
        if (adminStats == null && allUsers.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<UserCubit>().getAdminStats();
            context.read<UserCubit>().getAllUsers();
          });
        }

        return Column(
          children: [
            // 管理员统计信息
            if (adminStats != null) ...[
              _buildAdminStatsCard(context, adminStats, hasCustomBackground),
              const SizedBox(height: 24),
            ],
            
            // 用户管理列表
            _buildUserManagementCard(context, allUsers, hasCustomBackground),
          ],
        );
      },
    );
  }

  Widget _buildAdminStatsCard(BuildContext context, adminStats, bool hasCustomBackground) {
    final cardContent = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                '系统统计',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  '总用户数',
                  adminStats.totalUsers.toString(),
                  Icons.people,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context,
                  '活跃用户',
                  adminStats.activeUsers.toString(),
                  Icons.person,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  '管理员',
                  adminStats.adminUsers.toString(),
                  Icons.admin_panel_settings,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context,
                  '总文档',
                  adminStats.totalDocuments.toString(),
                  Icons.description,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  '总页面',
                  adminStats.totalPages.toString(),
                  Icons.pages,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context,
                  '存储使用',
                  '${(adminStats.totalStorageUsed / 1024 / 1024).toStringAsFixed(1)} MB',
                  Icons.storage,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    // 如果有自定义背景，使用优化的毛玻璃卡片
    if (hasCustomBackground) {
      return Consumer<GlassmorphicPerformanceNotifier>(
        builder: (context, performanceNotifier, child) {
          final config = performanceNotifier.config;
          final blur = config.getActualBlur(GlassmorphicPresets.aboutCardBlur);
          final opacity = config.getActualOpacity(GlassmorphicPresets.aboutCardOpacity);
          
          return OptimizedGlassmorphicCard(
            blur: blur,
            opacity: opacity,
            padding: const EdgeInsets.all(20.0),
            useSharedBlur: false,
            blurGroup: 'admin_stats',
            blurMethod: config.blurMethod,
            kawaseConfig: config.blurMethod == BlurMethod.kawase ? config.getKawaseConfig() : null,
            child: cardContent,
          );
        },
      );
    }
    
    // 否则使用普通卡片
    return Card(
      elevation: 2,
      child: cardContent,
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUserManagementCard(BuildContext context, List<AdminUserListDto> users, bool hasCustomBackground) {
    final cardContent = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.people,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                '用户管理',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '共 ${users.length} 个用户',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // 用户列表
          if (users.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('暂无用户数据'),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: users.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final user = users[index];
                return _buildUserListItem(context, user);
              },
            ),
        ],
      ),
    );

    // 如果有自定义背景，使用优化的毛玻璃卡片
    if (hasCustomBackground) {
      return Consumer<GlassmorphicPerformanceNotifier>(
        builder: (context, performanceNotifier, child) {
          final config = performanceNotifier.config;
          final blur = config.getActualBlur(GlassmorphicPresets.aboutCardBlur);
          final opacity = config.getActualOpacity(GlassmorphicPresets.aboutCardOpacity);
          
          return OptimizedGlassmorphicCard(
            blur: blur,
            opacity: opacity,
            padding: const EdgeInsets.all(20.0),
            useSharedBlur: false,
            blurGroup: 'admin_users',
            blurMethod: config.blurMethod,
            kawaseConfig: config.blurMethod == BlurMethod.kawase ? config.getKawaseConfig() : null,
            child: cardContent,
          );
        },
      );
    }
    
    // 否则使用普通卡片
    return Card(
      elevation: 2,
      child: cardContent,
    );
  }

  Widget _buildUserListItem(BuildContext context, AdminUserListDto user) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: user.isActive 
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.outline,
        child: Text(
          user.email.substring(0, 1).toUpperCase(),
          style: TextStyle(
            color: user.isActive 
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      title: Text(user.email),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('文档: ${user.documentCount} | 页面: ${user.pageCount}'),
          Text('存储: ${(user.totalStorageUsed / 1024 / 1024).toStringAsFixed(1)} MB'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Switch(
            value: user.isAdmin,
            onChanged: (value) {
              context.read<UserCubit>().updateUserRole(
                user.id,
                UpdateUserRoleDto(
                  isAdmin: value,
                  isActive: user.isActive,
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          Switch(
            value: user.isActive,
            onChanged: (value) {
              context.read<UserCubit>().updateUserRole(
                user.id,
                UpdateUserRoleDto(
                  isAdmin: user.isAdmin,
                  isActive: value,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoCard(BuildContext context, user, bool hasCustomBackground) {
    final cardContent = _isEditing
        ? UserProfileForm(
            user: user,
            onSave: (profile) {
              context.read<UserCubit>().updateCurrentUserProfile(profile);
              setState(() {
                _isEditing = false;
              });
            },
            onCancel: () {
              setState(() {
                _isEditing = false;
              });
            },
          )
        : UserInfoCard(user: user);

    // 如果有自定义背景，使用优化的毛玻璃卡片
    if (hasCustomBackground) {
      return Consumer<GlassmorphicPerformanceNotifier>(
        builder: (context, performanceNotifier, child) {
          final config = performanceNotifier.config;
          final blur = config.getActualBlur(GlassmorphicPresets.aboutCardBlur);
          final opacity = config.getActualOpacity(GlassmorphicPresets.aboutCardOpacity);
          
          return OptimizedGlassmorphicCard(
            blur: blur,
            opacity: opacity,
            padding: const EdgeInsets.all(20.0),
            useSharedBlur: false,
            blurGroup: 'user_info',
            blurMethod: config.blurMethod,
            kawaseConfig: config.blurMethod == BlurMethod.kawase ? config.getKawaseConfig() : null,
            child: cardContent,
          );
        },
      );
    }
    
    // 否则使用普通卡片
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: cardContent,
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            '加载用户信息失败',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<UserCubit>().getCurrentUserProfile();
            },
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }
}