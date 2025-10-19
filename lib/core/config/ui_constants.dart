/// UI常量配置
/// 
/// 提供应用程序UI的各种常量值
class UIConstants {
  // 防止实例化
  UIConstants._();

  // ========== 动画时长 ==========
  
  /// 快速动画时长（毫秒）
  static const int fastAnimationDuration = 150;
  
  /// 标准动画时长（毫秒）
  static const int standardAnimationDuration = 300;
  
  /// 慢速动画时长（毫秒）
  static const int slowAnimationDuration = 500;

  // ========== 列表项配置 ==========
  
  /// 列表项水平内边距
  static const double listItemHorizontalPadding = 16.0;
  
  /// 列表项垂直内边距
  static const double listItemVerticalPadding = 12.0;
  
  /// 列表项之间的间距
  static const double listItemSpacing = 8.0;
  
  /// 列表项图标大小
  static const double listItemIconSize = 32.0;
  
  /// 列表项小图标大小
  static const double listItemSmallIconSize = 28.0;

  // ========== 卡片配置 ==========
  
  /// 卡片圆角半径
  static const double cardBorderRadius = 12.0;
  
  /// 卡片内边距
  static const double cardPadding = 16.0;
  
  /// 卡片外边距（垂直）
  static const double cardVerticalMargin = 8.0;
  
  /// 卡片外边距（水平）
  static const double cardHorizontalMargin = 8.0;

  // ========== 间距配置 ==========
  
  /// 微小间距
  static const double spaceTiny = 4.0;
  
  /// 小间距
  static const double spaceSmall = 8.0;
  
  /// 标准间距
  static const double spaceNormal = 12.0;
  
  /// 中等间距
  static const double spaceMedium = 16.0;
  
  /// 大间距
  static const double spaceLarge = 24.0;
  
  /// 超大间距
  static const double spaceXLarge = 32.0;

  // ========== 图标大小 ==========
  
  /// 微小图标
  static const double iconSizeTiny = 16.0;
  
  /// 小图标
  static const double iconSizeSmall = 20.0;
  
  /// 标准图标
  static const double iconSizeNormal = 24.0;
  
  /// 中等图标
  static const double iconSizeMedium = 28.0;
  
  /// 大图标
  static const double iconSizeLarge = 32.0;
  
  /// 超大图标
  static const double iconSizeXLarge = 48.0;

  // ========== 文字大小 ==========
  
  /// 微小文字
  static const double textSizeTiny = 10.0;
  
  /// 小文字
  static const double textSizeSmall = 12.0;
  
  /// 标准文字
  static const double textSizeNormal = 14.0;
  
  /// 中等文字
  static const double textSizeMedium = 16.0;
  
  /// 大文字
  static const double textSizeLarge = 18.0;
  
  /// 超大文字
  static const double textSizeXLarge = 24.0;

  // ========== 按钮配置 ==========
  
  /// 按钮最小高度
  static const double buttonMinHeight = 48.0;
  
  /// 按钮圆角半径
  static const double buttonBorderRadius = 8.0;
  
  /// 按钮水平内边距
  static const double buttonHorizontalPadding = 24.0;

  // ========== Chip配置 ==========
  
  /// Chip水平内边距
  static const double chipHorizontalPadding = 4.0;
  
  /// Chip文字大小
  static const double chipTextSize = 12.0;
  
  /// Chip之间的间距
  static const double chipSpacing = 6.0;
  
  /// Chip行间距
  static const double chipRunSpacing = 4.0;

  // ========== 日期格式化相关 ==========
  
  /// 同一天内显示时间的天数阈值
  static const int sameDayThreshold = 1;
  
  /// 一周内显示星期的天数阈值
  static const int weekThreshold = 7;

  // ========== 性能相关 ==========
  
  /// 60fps的目标帧时间（毫秒）
  static const int targetFrameTimeMs = 16;
  
  /// 滚动节流延迟（毫秒）
  static const int scrollThrottleMs = 100;
  
  /// 搜索防抖延迟（毫秒）
  static const int searchDebounceMs = 300;

  // ========== 分页相关 ==========
  
  /// 默认页面大小
  static const int defaultPageSize = 20;
  
  /// 加载更多的触发阈值（距底部项数）
  static const int loadMoreThreshold = 5;
}

