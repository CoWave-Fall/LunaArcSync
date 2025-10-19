import 'package:flutter/material.dart';
import 'package:luna_arc_sync/data/models/document_models.dart';
import 'package:luna_arc_sync/data/models/user_models.dart';
import 'package:provider/provider.dart';
import 'package:luna_arc_sync/core/theme/background_image_notifier.dart';
import 'package:luna_arc_sync/presentation/widgets/optimized_glassmorphic_container.dart';
import 'package:luna_arc_sync/core/theme/glassmorphic_performance_notifier.dart';
import 'package:luna_arc_sync/core/cache/glassmorphic_cache.dart';
import 'package:luna_arc_sync/core/utils/date_formatter.dart';
import 'package:luna_arc_sync/core/config/ui_constants.dart';
import 'package:luna_arc_sync/core/config/glassmorphic_presets.dart';
import 'package:luna_arc_sync/presentation/auth/cubit/auth_cubit.dart';
import 'package:luna_arc_sync/presentation/auth/cubit/auth_state.dart';
import 'package:luna_arc_sync/presentation/documents/cubit/document_list_cubit.dart';
import 'package:luna_arc_sync/core/api/api_client.dart';
import 'package:luna_arc_sync/core/di/injection.dart';
import 'package:luna_arc_sync/core/api/authenticated_image_provider.dart';

/// 文档列表项组件
/// 
/// 显示单个文档的信息，包括标题、标签、更新时间和页数
/// 支持自定义背景下的毛玻璃效果和选中状态
class DocumentListItem extends StatelessWidget {
  /// 文档数据
  final Document document;
  
  /// 点击回调
  final VoidCallback onTap;
  
  /// 长按回调（可选，用于多选等操作）
  final VoidCallback? onLongPress;
  
  /// 是否被选中
  final bool isSelected;

  const DocumentListItem({
    super.key,
    required this.document,
    required this.onTap,
    this.onLongPress,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasCustomBackground = context.watch<BackgroundImageNotifier>().hasCustomBackground;
    
    // 有自定义背景时使用毛玻璃卡片，否则使用普通容器
    return hasCustomBackground 
        ? _buildGlassmorphicCard(context)
        : _buildPlainCard(context);
  }

  /// 构建毛玻璃卡片（用于自定义背景）
  Widget _buildGlassmorphicCard(BuildContext context) {
    return Consumer<GlassmorphicPerformanceNotifier>(
      builder: (context, performanceNotifier, child) {
        final config = performanceNotifier.config;
        // 使用文档列表预设
        final blur = config.getActualBlur(GlassmorphicPresets.documentListBlur);
        final opacity = config.getActualOpacity(GlassmorphicPresets.documentListOpacity);
        
        return OptimizedGlassmorphicCard(
          blur: blur,
          opacity: opacity,
          padding: const EdgeInsets.symmetric(
            horizontal: UIConstants.listItemHorizontalPadding,
            vertical: UIConstants.listItemVerticalPadding,
          ),
          margin: EdgeInsets.symmetric(
            horizontal: UIConstants.cardHorizontalMargin,
            vertical: UIConstants.listItemSpacing / 2,
          ),
          useSharedBlur: config.useSharedBlur,
          blurGroup: 'document_list',
          blurMethod: config.blurMethod,
          kawaseConfig: config.blurMethod == BlurMethod.kawase 
              ? config.getKawaseConfig() 
              : null,
          onTap: onTap,
          onLongPress: onLongPress,
          child: _buildSelectedContainer(context, _buildContent(context)),
        );
      },
    );
  }

  /// 构建普通卡片（无自定义背景）
  Widget _buildPlainCard(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: _buildSelectedContainer(
        context,
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: UIConstants.listItemHorizontalPadding,
            vertical: UIConstants.listItemVerticalPadding,
          ),
          child: _buildContent(context),
        ),
      ),
    );
  }

  /// 构建选中状态容器
  Widget _buildSelectedContainer(BuildContext context, Widget child) {
    if (!isSelected) return child;

    final theme = Theme.of(context);
    final selectedColor = theme.colorScheme.primary.withValues(alpha: 0.1);

    return Container(
      decoration: BoxDecoration(
        color: selectedColor,
        borderRadius: BorderRadius.circular(UIConstants.cardBorderRadius),
      ),
      child: child,
    );
  }

  /// 构建内容区域
  Widget _buildContent(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildLeadingIcon(context),
        const SizedBox(width: UIConstants.spaceMedium),
        _buildTitleAndTags(context),
        const SizedBox(width: UIConstants.spaceMedium),
        _buildOwnerInfo(context),
        const SizedBox(width: UIConstants.spaceMedium),
        _buildDateAndPageCount(context),
      ],
    );
  }

  /// 构建前导图标（选中状态显示对勾，否则显示文档图标）
  Widget _buildLeadingIcon(BuildContext context) {
    final theme = Theme.of(context);
    
    if (isSelected) {
      return CircleAvatar(
        radius: 16,
        backgroundColor: theme.colorScheme.primary,
        child: const Icon(
          Icons.check,
          color: Colors.white,
          size: UIConstants.iconSizeSmall,
        ),
      );
    }
    
    return Icon(
      Icons.description,
      color: theme.colorScheme.primary,
      size: UIConstants.listItemIconSize,
    );
  }

  /// 构建标题和标签区域
  Widget _buildTitleAndTags(BuildContext context) {
    final theme = Theme.of(context);
    
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 文档标题
          Text(
            document.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          
          // 标签列表
          if (document.tags.isNotEmpty) ...[
            const SizedBox(height: UIConstants.spaceTiny),
            Wrap(
              spacing: UIConstants.chipSpacing,
              runSpacing: UIConstants.chipRunSpacing,
              children: document.tags.map(_buildTagChip).toList(),
            ),
          ],
        ],
      ),
    );
  }

  /// 构建单个标签 Chip
  Widget _buildTagChip(String tag) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return Chip(
          label: Text(tag),
          padding: EdgeInsets.symmetric(
            horizontal: UIConstants.chipHorizontalPadding,
          ),
          labelStyle: const TextStyle(
            fontSize: UIConstants.chipTextSize,
          ),
          backgroundColor: theme.colorScheme.secondaryContainer,
          side: BorderSide.none,
          visualDensity: VisualDensity.compact,
        );
      },
    );
  }

  /// 构建属主信息（仅admin可见）
  Widget _buildOwnerInfo(BuildContext context) {
    // 检查是否是admin
    final authState = context.select<AuthCubit, AuthState>((cubit) => cubit.state);
    final isAdmin = authState.when(
      initial: () => false,
      authenticated: (userId, isAdmin, role) => isAdmin,
      unauthenticated: (isLoading, error) => false,
    );

    // 如果不是admin或没有ownerUserId，返回空widget
    if (!isAdmin || document.ownerUserId == null) {
      return const SizedBox.shrink();
    }

    // 从DocumentListCubit获取用户信息
    final userInfo = context.select<DocumentListCubit, UserDto?>(
      (cubit) => cubit.state.userInfoCache[document.ownerUserId],
    );

    // 如果还没有加载用户信息，返回空widget或加载指示器
    if (userInfo == null) {
      return const SizedBox(
        width: 80,
        child: Center(child: SizedBox.shrink()),
      );
    }

    final apiClient = getIt<ApiClient>();
    final avatarUrl = '/api/accounts/avatar/${document.ownerUserId}';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 头像
        CircleAvatar(
          radius: 14,
          backgroundImage: userInfo.avatar != null && userInfo.avatar!.isNotEmpty
              ? AuthenticatedImageProvider(avatarUrl, apiClient)
              : null,
          child: userInfo.avatar == null || userInfo.avatar!.isEmpty
              ? Text(
                  userInfo.nickname.isNotEmpty 
                      ? userInfo.nickname[0].toUpperCase()
                      : userInfo.username[0].toUpperCase(),
                  style: const TextStyle(fontSize: 12),
                )
              : null,
        ),
        const SizedBox(width: UIConstants.spaceSmall),
        // 昵称
        SizedBox(
          width: 60,
          child: Text(
            userInfo.nickname.isNotEmpty ? userInfo.nickname : userInfo.username,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// 构建日期和页数区域
  Widget _buildDateAndPageCount(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 更新时间
        Text(
          DateFormatter.formatSmartDate(document.updatedAt),
          style: theme.textTheme.bodySmall,
        ),
        
        const SizedBox(height: UIConstants.spaceTiny),
        
        // 页数
        Text(
          '${document.pageCount} pages',
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}