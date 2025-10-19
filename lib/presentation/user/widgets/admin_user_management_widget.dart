import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luna_arc_sync/presentation/user/cubit/user_cubit.dart';
import 'package:luna_arc_sync/presentation/user/cubit/user_state.dart';
import 'package:luna_arc_sync/presentation/user/widgets/admin_user_list_item.dart';
import 'package:luna_arc_sync/presentation/user/widgets/admin_stats_card.dart';
import 'package:luna_arc_sync/presentation/widgets/optimized_glassmorphic_container.dart';
import 'package:luna_arc_sync/data/models/user_models.dart';
import 'package:luna_arc_sync/core/services/multi_account_service.dart';
import 'package:provider/provider.dart';

/// 管理员用户管理组件
/// 
/// 这是一个集成在用户页面中的管理员功能组件，提供：
/// - 用户统计信息展示
/// - 用户列表管理
/// - 用户角色和状态管理
/// - 多账号登录支持
class AdminUserManagementWidget extends StatefulWidget {
  const AdminUserManagementWidget({super.key});

  @override
  State<AdminUserManagementWidget> createState() => _AdminUserManagementWidgetState();
}

class _AdminUserManagementWidgetState extends State<AdminUserManagementWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // 获取所有用户和统计信息
    context.read<UserCubit>().getAllUsers();
    context.read<UserCubit>().getAdminStats();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OptimizedGlassmorphicContainer(
      blur: 12.0,
      opacity: 0.15,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 8),
      useSharedBlur: true,
      blurGroup: 'admin_management',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题和展开/收起按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.admin_panel_settings,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '管理员功能',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                icon: AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          
          // 展开的内容
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isExpanded
                ? Column(
                    children: [
                      const SizedBox(height: 20),
                      
                      // 统计信息卡片
                      BlocBuilder<UserCubit, UserState>(
                        builder: (context, state) {
                          return state.maybeWhen(
                            adminStatsLoaded: (stats) => AdminStatsCard(stats: stats),
                            orElse: () => _buildStatsLoadingCard(),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // 标签页
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                          ),
                          labelColor: Theme.of(context).colorScheme.primary,
                          unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
                          tabs: const [
                            Tab(
                              icon: Icon(Icons.people),
                              text: '用户管理',
                            ),
                            Tab(
                              icon: Icon(Icons.account_circle),
                              text: '多账号登录',
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // 标签页内容
                      SizedBox(
                        height: 400,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildUserManagementTab(),
                            _buildMultiAccountTab(),
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  /// 构建用户管理标签页
  Widget _buildUserManagementTab() {
    return BlocConsumer<UserCubit, UserState>(
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
          initial: () => _buildLoadingState(),
          loading: () => _buildLoadingState(),
          currentUserLoaded: (user) => _buildLoadingState(),
          allUsersLoaded: (users) => _buildUsersList(users),
          userDetailsLoaded: (user) => _buildLoadingState(),
          adminStatsLoaded: (stats) => _buildLoadingState(),
          dataLoaded: (currentUser, allUsers, adminStats) => _buildUsersList(allUsers ?? <AdminUserListDto>[]),
          error: (message) => _buildErrorState(message),
        );
      },
    );
  }

  /// 构建多账号登录标签页
  Widget _buildMultiAccountTab() {
    return OptimizedGlassmorphicContainer(
      blur: 8.0,
      opacity: 0.1,
      borderRadius: BorderRadius.circular(12),
      padding: const EdgeInsets.all(16),
      useSharedBlur: true,
      blurGroup: 'multi_account',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.swap_horiz,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '多账号登录管理',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // 当前登录账号信息
          _buildCurrentAccountInfo(),
          
          const SizedBox(height: 16),
          
          // 已保存的账号列表
          _buildSavedAccountsList(),
          
          const SizedBox(height: 16),
          
          // 添加新账号按钮
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _showAddAccountDialog,
              icon: const Icon(Icons.add),
              label: const Text('添加新账号'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建当前账号信息
  Widget _buildCurrentAccountInfo() {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return state.maybeWhen(
          currentUserLoaded: (user) => Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    user.nickname.isNotEmpty ? user.nickname[0].toUpperCase() : 'U',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.nickname.isNotEmpty ? user.nickname : user.username,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user.email,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '当前账号',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }

  /// 构建已保存账号列表
  Widget _buildSavedAccountsList() {
    return FutureBuilder<List<SavedAccount>>(
      future: context.read<MultiAccountService>().getSavedAccounts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final accounts = snapshot.data ?? [];
        
        if (accounts.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.account_circle_outlined,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '已保存的账号',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '暂无其他已保存的账号',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: accounts.length,
          itemBuilder: (context, index) {
            final account = accounts[index];
            return _buildAccountItem(account);
          },
        );
      },
    );
  }

  /// 构建账号项
  Widget _buildAccountItem(SavedAccount account) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              account.displayName.isNotEmpty ? account.displayName[0].toUpperCase() : 'A',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.displayName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  account.email,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '${account.serverDisplay} • ${account.statusDescription}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => _switchToAccount(account),
                icon: Icon(
                  Icons.swap_horiz,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                tooltip: '切换到此账号',
              ),
              IconButton(
                onPressed: () => _deleteAccount(account),
                icon: Icon(
                  Icons.delete_outline,
                  size: 16,
                  color: Theme.of(context).colorScheme.error,
                ),
                tooltip: '删除此账号',
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 切换账号
  void _switchToAccount(SavedAccount account) async {
    try {
      await context.read<MultiAccountService>().switchToAccount(account.accountId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('已切换到账号: ${account.displayName}'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
      // 刷新页面数据
      context.read<UserCubit>().getCurrentUserProfile();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('切换账号失败: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  /// 删除账号
  void _deleteAccount(SavedAccount account) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('确认删除'),
          content: Text('确定要删除账号 ${account.displayName} 吗？'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await context.read<MultiAccountService>().deleteAccount(account.accountId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('账号已删除'),
                    ),
                  );
                  setState(() {}); // 刷新UI
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('删除失败: $e'),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                }
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

  /// 构建用户列表
  Widget _buildUsersList(List<AdminUserListDto> users) {
    return OptimizedGlassmorphicContainer(
      blur: 8.0,
      opacity: 0.1,
      borderRadius: BorderRadius.circular(12),
      padding: const EdgeInsets.all(16),
      useSharedBlur: true,
      blurGroup: 'user_list',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '用户列表',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '共 ${users.length} 个用户',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // 用户列表项
          Expanded(
            child: ListView.separated(
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
          ),
        ],
      ),
    );
  }

  /// 构建统计信息加载卡片
  Widget _buildStatsLoadingCard() {
    return OptimizedGlassmorphicContainer(
      blur: 8.0,
      opacity: 0.1,
      borderRadius: BorderRadius.circular(12),
      padding: const EdgeInsets.all(16),
      useSharedBlur: true,
      blurGroup: 'stats_loading',
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  /// 构建加载状态
  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  /// 构建错误状态
  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            '加载失败',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
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

  /// 显示删除确认对话框
  void _showDeleteConfirmDialog(BuildContext context, AdminUserListDto user) {
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

  /// 显示添加账号对话框
  void _showAddAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('添加新账号'),
          content: const Text('此功能将允许您在同一服务器上管理多个账号。'),
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
                // TODO: 实现添加账号逻辑
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('添加账号功能开发中...'),
                  ),
                );
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }
}
