import 'package:flutter/material.dart';
import 'package:luna_arc_sync/data/models/user_models.dart';

class AdminUserListItem extends StatelessWidget {
  final AdminUserListDto user;
  final Function(bool isAdmin, bool isActive) onRoleChanged;
  final VoidCallback onDelete;

  const AdminUserListItem({
    super.key,
    required this.user,
    required this.onRoleChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // 用户头像
          CircleAvatar(
            radius: 24,
            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            child: Text(
              user.email.substring(0, 1).toUpperCase(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // 用户信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.email,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'ID: ${user.id.substring(0, 8)}...',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '文档: ${user.documentCount}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '页面: ${user.pageCount}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '创建: ${_formatDate(user.createdAt)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (user.lastLoginAt != null) ...[
                      const SizedBox(width: 16),
                      Text(
                        '最后登录: ${_formatDate(user.lastLoginAt!)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          
          // 角色和状态控制
          Column(
            children: [
              // 管理员角色开关
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch(
                    value: user.isAdmin,
                    onChanged: (value) {
                      onRoleChanged(value, user.isActive);
                    },
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '管理员',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // 活跃状态开关
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch(
                    value: user.isActive,
                    onChanged: (value) {
                      onRoleChanged(user.isAdmin, value);
                    },
                    activeColor: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '活跃',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(width: 16),
          
          // 删除按钮
          IconButton(
            onPressed: onDelete,
            icon: Icon(
              Icons.delete_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            tooltip: '删除用户',
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }
}
