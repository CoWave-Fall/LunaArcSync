import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:luna_arc_sync/data/models/page_models.dart' as models;

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
    // 图标现在使用默认主题颜色
    final iconColor = Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
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
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}