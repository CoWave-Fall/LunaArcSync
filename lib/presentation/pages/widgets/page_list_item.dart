import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:luna_arc_sync/data/models/page_models.dart' as models;
import 'package:provider/provider.dart';
import 'package:luna_arc_sync/core/theme/background_image_notifier.dart';
import 'package:luna_arc_sync/presentation/widgets/glassmorphic_container.dart';

class PageListItem extends StatelessWidget {
  final models.Page page;
  final VoidCallback onTap;

  const PageListItem({
    super.key,
    required this.page,
    required this.onTap,
  });

  // 辅助函数，格式化日期
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final localDate = date.toLocal(); // 转换为本地时间以便比较
    final difference = now.difference(localDate);

    // 在同一天内
    if (difference.inDays < 1 && now.day == localDate.day) {
      return DateFormat.jm().format(localDate); // 返回 "下午 5:30"
    } 
    // 在一周内
    else if (difference.inDays < 7) {
      return DateFormat.E().format(localDate); // 返回 "周二"
    } 
    // 更早的时间
    else {
      return DateFormat.yMd().format(localDate); // 返回 "2025/8/20"
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasCustomBackground = context.watch<BackgroundImageNotifier>().hasCustomBackground;
    final iconColor = Theme.of(context).colorScheme.primary;

    final content = Row(
      children: [
        // 1. 图标
        Icon(Icons.article_outlined, color: iconColor, size: 28),
        const SizedBox(width: 16),
        
        // 2. 名称
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                page.title,
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        
        // 3. 时间
        Text(
          _formatDate(page.updatedAt),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: hasCustomBackground ? null : Colors.grey[600],
          ),
        ),
      ],
    );

    // 如果有自定义背景，使用毛玻璃卡片
    if (hasCustomBackground) {
      return GlassmorphicCard(
        blur: 8.0,
        opacity: 0.15,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        onTap: onTap,
        child: content,
      );
    }

    // 没有自定义背景时，使用普通样式
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: content,
      ),
    );
  }
}