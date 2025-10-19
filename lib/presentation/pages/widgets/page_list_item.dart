import 'package:flutter/material.dart';
import 'package:luna_arc_sync/data/models/page_models.dart' as models;
import 'package:provider/provider.dart';
import 'package:luna_arc_sync/core/theme/background_image_notifier.dart';
import 'package:luna_arc_sync/core/theme/glassmorphic_performance_notifier.dart';
import 'package:luna_arc_sync/presentation/widgets/optimized_glassmorphic_container.dart';
import 'package:luna_arc_sync/core/utils/date_formatter.dart';
import 'package:luna_arc_sync/core/config/ui_constants.dart';
import 'package:luna_arc_sync/core/cache/glassmorphic_cache.dart';
import 'package:luna_arc_sync/core/config/glassmorphic_presets.dart';

/// 页面列表项组件
/// 
/// 显示单个页面的信息，包括标题和更新时间
/// 支持自定义背景下的毛玻璃效果
class PageListItem extends StatelessWidget {
  /// 页面数据
  final models.Page page;
  
  /// 点击回调
  final VoidCallback onTap;

  const PageListItem({
    super.key,
    required this.page,
    required this.onTap,
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
        // 使用页面列表预设
        final blur = config.getActualBlur(GlassmorphicPresets.pageListBlur);
        final opacity = config.getActualOpacity(GlassmorphicPresets.pageListOpacity);
        
        return OptimizedGlassmorphicCard(
          blur: blur,
          opacity: opacity,
          padding: EdgeInsets.symmetric(
            horizontal: UIConstants.listItemHorizontalPadding,
            vertical: UIConstants.listItemVerticalPadding,
          ),
          margin: EdgeInsets.symmetric(
            horizontal: UIConstants.cardHorizontalMargin,
            vertical: UIConstants.listItemSpacing / 2,
          ),
          useSharedBlur: true,  // 启用共享模糊（由 OptimizedGlassmorphicListBuilder 提供）
          blurGroup: 'page_list',
          blurMethod: config.blurMethod,
          kawaseConfig: config.blurMethod == BlurMethod.kawase 
              ? config.getKawaseConfig() 
              : null,
          onTap: onTap,
          child: _buildContent(context),
        );
      },
    );
  }

  /// 构建普通卡片（无自定义背景）
  Widget _buildPlainCard(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: UIConstants.listItemHorizontalPadding,
          vertical: UIConstants.listItemVerticalPadding,
        ),
        child: _buildContent(context),
      ),
    );
  }

  /// 构建内容区域
  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final hasCustomBackground = context.watch<BackgroundImageNotifier>().hasCustomBackground;
    
    return Row(
      children: [
        // 页面图标
        Icon(
          Icons.article_outlined,
          color: theme.colorScheme.primary,
          size: UIConstants.listItemSmallIconSize,
        ),
        
        SizedBox(width: UIConstants.spaceMedium),
        
        // 页面标题
        Expanded(
          child: Text(
            page.title,
            style: theme.textTheme.titleMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        
        SizedBox(width: UIConstants.spaceMedium),
        
        // 更新时间
        Text(
          DateFormatter.formatSmartDate(page.updatedAt),
          style: theme.textTheme.bodySmall?.copyWith(
            color: hasCustomBackground ? null : Colors.grey[600],
          ),
        ),
      ],
    );
  }
}