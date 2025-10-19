import 'package:intl/intl.dart';

/// 日期格式化工具类
/// 
/// 提供智能的日期格式化功能，根据时间差异返回不同格式
class DateFormatter {
  // 防止实例化
  DateFormatter._();

  /// 智能格式化日期
  /// 
  /// 根据与当前时间的差异，返回不同格式的日期字符串：
  /// - 同一天内：显示时间（例如：5:30 PM）
  /// - 一周内：显示星期（例如：Tue）
  /// - 更早：显示完整日期（例如：8/20/2025）
  /// 
  /// [date] 要格式化的日期时间
  /// 返回格式化后的字符串
  static String formatSmartDate(DateTime date) {
    final now = DateTime.now();
    final localDate = date.toLocal();
    final difference = now.difference(localDate);

    // 同一天内，显示时间
    if (difference.inDays < 1 && now.day == localDate.day) {
      return DateFormat.jm().format(localDate); // 例如: "5:30 PM" 或 "下午 5:30"
    }
    
    // 一周内，显示星期
    if (difference.inDays < 7) {
      return DateFormat.E().format(localDate); // 例如: "Tue" 或 "周二"
    }
    
    // 更早的时间，显示完整日期
    return DateFormat.yMd().format(localDate); // 例如: "8/20/2025" 或 "2025/8/20"
  }

  /// 格式化为完整日期时间
  /// 
  /// [date] 要格式化的日期时间
  /// 返回完整的日期时间字符串（例如：2025-10-18 15:30:45）
  static String formatFullDateTime(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date.toLocal());
  }

  /// 格式化为短日期
  /// 
  /// [date] 要格式化的日期
  /// 返回短日期字符串（例如：10/18/2025）
  static String formatShortDate(DateTime date) {
    return DateFormat.yMd().format(date.toLocal());
  }

  /// 格式化为长日期
  /// 
  /// [date] 要格式化的日期
  /// 返回长日期字符串（例如：October 18, 2025）
  static String formatLongDate(DateTime date) {
    return DateFormat.yMMMMd().format(date.toLocal());
  }

  /// 格式化为相对时间
  /// 
  /// [date] 要格式化的日期时间
  /// 返回相对时间字符串（例如：2小时前、3天前）
  static String formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return '刚刚';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}周前';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}个月前';
    } else {
      return '${(difference.inDays / 365).floor()}年前';
    }
  }
}

