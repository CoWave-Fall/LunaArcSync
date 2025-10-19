import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:luna_arc_sync/presentation/user/cubit/user_cubit.dart';
import 'package:luna_arc_sync/presentation/user/cubit/user_state.dart';
import 'package:luna_arc_sync/presentation/user/widgets/admin_user_list_item.dart';
import 'package:luna_arc_sync/presentation/user/widgets/admin_stats_card.dart';
import 'package:luna_arc_sync/presentation/widgets/optimized_glassmorphic_container.dart';
import 'package:luna_arc_sync/core/theme/background_image_notifier.dart';
import 'package:luna_arc_sync/core/theme/glassmorphic_performance_notifier.dart';
import 'package:luna_arc_sync/core/config/glassmorphic_presets.dart';
import 'package:luna_arc_sync/core/theme/no_overscroll_behavior.dart';
import 'package:luna_arc_sync/core/cache/glassmorphic_cache.dart';
import 'package:luna_arc_sync/data/models/user_models.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  @override
  void initState() {
    super.initState();
    // 获取所有用户和统计信息
    context.read<UserCubit>().getAllUsers();
    context.read<UserCubit>().getAdminStats();
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
              currentUserLoaded: (user) => const Center(child: CircularProgressIndicator()),
              allUsersLoaded: (users) => _buildUsersList(context, users, hasCustomBackground),
              userDetailsLoaded: (user) => const Center(child: CircularProgressIndicator()),
              adminStatsLoaded: (stats) => const Center(child: CircularProgressIndicator()),
              dataLoaded: (currentUser, allUsers, adminStats) => _buildUsersList(context, allUsers ?? <AdminUserListDto>[], hasCustomBackground),
              error: (message) => _buildErrorState(message),
            );
          },
        ),
      ),
    );
  }

  Widget _buildUsersList(BuildContext context, users, bool hasCustomBackground) {
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          backgroundColor: hasCustomBackground ? Colors.transparent : null,
          title: const Text('用户管理'),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // 统计信息卡片
              _buildStatsCard(context, hasCustomBackground),
              
              const SizedBox(height: 24),
              
              // 用户列表
              _buildUsersListCard(context, users, hasCustomBackground),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard(BuildContext context, bool hasCustomBackground) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        final stats = state.maybeWhen(
          adminStatsLoaded: (stats) => stats,
          orElse: () => null,
        );

        if (stats == null) {
          return const SizedBox.shrink();
        }

        final cardContent = AdminStatsCard(stats: stats);

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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: cardContent,
          ),
        );
      },
    );
  }

  Widget _buildUsersListCard(BuildContext context, users, bool hasCustomBackground) {
    final cardContent = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '用户列表',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '共 ${users.length} 个用户',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // 用户列表项
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: users.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final user = users[index];
              return AdminUserListItem(
                user: user,
                onRoleChanged: (isAdmin, isActive) {
                  context.read<UserCubit>().updateUserRole(
                    user.id,
                    UpdateUserRoleDto(
                      isAdmin: isAdmin,
                      isActive: isActive,
                    ),
                  );
                },
                onDelete: () {
                  _showDeleteConfirmDialog(context, user);
                },
              );
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
            '加载用户列表失败',
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
              context.read<UserCubit>().getAllUsers();
            },
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('确认删除'),
          content: Text('确定要删除用户 ${user.email} 吗？此操作不可撤销。'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<UserCubit>().deleteUser(user.id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              child: const Text('删除'),
            ),
          ],
        );
      },
    );
  }
}
