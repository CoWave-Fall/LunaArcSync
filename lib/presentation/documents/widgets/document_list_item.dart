import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:luna_arc_sync/data/models/document_models.dart';

class DocumentListItem extends StatelessWidget {
  final Document document;
  final VoidCallback onTap;

  const DocumentListItem({
    super.key,
    required this.document,
    required this.onTap,
  });

  // 辅助函数，根据标签决定图标颜色
  Color _getIconColorForTags(List<String> tags, BuildContext context) {
    // 定义标签与颜色的映射关系
    const Map<String, Color> tagColors = {
      'work': Colors.blue,
      'personal': Colors.green,
      'urgent': Colors.red,
    };
    // 检查是否有匹配的标签，返回对应的颜色
    for (final tag in tags) {
      if (tagColors.containsKey(tag.toLowerCase())) {
        return tagColors[tag.toLowerCase()]!;
      }
    }
    // 如果没有，则返回主题的默认 primary color
    return Theme.of(context).colorScheme.primary;
  }

  // 辅助函数，智能格式化日期
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays < 1 && now.day == date.day) {
      return DateFormat.jm().format(date.toLocal()); // 例如: "5:30 PM"
    } else if (difference.inDays < 7) {
      return DateFormat.E().format(date.toLocal()); // 例如: "Tue" for Tuesday
    } else {
      return DateFormat.yMd().format(date.toLocal()); // 例如: "8/20/2025"
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = _getIconColorForTags(document.tags, context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. 图标
            Icon(Icons.description, color: iconColor, size: 32),
            const SizedBox(width: 16),
            
            // 2. 名称和标签的垂直列
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // 如果有标签，则显示标签行
                  if (document.tags.isNotEmpty)
                    Wrap(
                      spacing: 6.0,
                      runSpacing: 4.0,
                      children: document.tags.map((tag) => Chip(
                        label: Text(tag),
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        labelStyle: const TextStyle(fontSize: 12),
                        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                        side: BorderSide.none,
                        visualDensity: VisualDensity.compact,
                      )).toList(),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            
            // 3. 时间和页面数量
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatDate(document.updatedAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  '${document.pageCount} pages',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}