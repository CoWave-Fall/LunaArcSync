import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:luna_arc_sync/data/models/document_models.dart';

class DocumentListItem extends StatelessWidget {
  final Document document;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;

  const DocumentListItem({
    super.key,
    required this.document,
    required this.onTap,
    this.onLongPress,
    this.isSelected = false, // Default to not selected
  });

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
    final theme = Theme.of(context);
    final selectedColor = theme.colorScheme.primary.withValues(alpha: 0.1);

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        color: isSelected ? selectedColor : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Icon changes based on selection
            isSelected
                ? CircleAvatar(
                    radius: 16,
                    backgroundColor: theme.colorScheme.primary,
                    child: const Icon(Icons.check, color: Colors.white, size: 20),
                  )
                : Icon(Icons.description, color: theme.colorScheme.primary, size: 32),
            const SizedBox(width: 16),

            // 2. Name and tags column (unchanged)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document.title,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  if (document.tags.isNotEmpty)
                    Wrap(
                      spacing: 6.0,
                      runSpacing: 4.0,
                      children: document.tags.map((tag) => Chip(
                        label: Text(tag),
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        labelStyle: const TextStyle(fontSize: 12),
                        backgroundColor: theme.colorScheme.secondaryContainer,
                        side: BorderSide.none,
                        visualDensity: VisualDensity.compact,
                      )).toList(),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // 3. Date and page count (unchanged)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatDate(document.updatedAt),
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  '${document.pageCount} pages',
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}