/// 缓存配置常量
/// 
/// 提供各种缓存服务的配置常量
class CacheConstants {
  // 防止实例化
  CacheConstants._();

  // ========== 图片缓存配置 ==========
  
  /// 图片缓存目录名
  static const String imageCacheDirName = 'image_cache';
  
  /// 增强图片缓存目录名（用于渲染缓存）
  static const String imageRenderCacheDirName = 'image_render_cache';
  
  /// 缓存元数据存储键
  static const String cacheMetadataKey = 'image_cache_metadata';
  
  /// 缓存过期时间（天）
  static const int cacheExpiryDays = 7;
  
  /// 最大缓存项数
  static const int maxCacheItems = 200;
  
  /// 最大缓存大小（MB）
  static const int maxCacheSizeMB = 300;
  
  /// 最大缓存大小（字节）
  static const int maxCacheSizeBytes = maxCacheSizeMB * 1024 * 1024;

  // ========== 毛玻璃过滤器缓存配置 ==========
  
  /// 毛玻璃过滤器最大缓存数
  static const int maxGlassmorphicFilters = 50;

  // ========== PDF缓存配置 ==========
  
  /// PDF缓存目录名
  static const String pdfCacheDirName = 'pdf_cache';
  
  /// PDF缓存过期时间（天）
  static const int pdfCacheExpiryDays = 30;

  // ========== 文本缓存配置 ==========
  
  /// OCR文本缓存最大条目数
  static const int maxTextCacheEntries = 100;
  
  /// 文本缓存过期时间（小时）
  static const int textCacheExpiryHours = 24;

  // ========== 预加载配置 ==========
  
  /// 预加载页面数（向前）
  static const int preloadAheadCount = 3;
  
  /// 预加载页面数（向后）
  static const int preloadBehindCount = 1;
  
  /// 预加载延迟（毫秒）
  static const int preloadDelayMs = 500;

  // ========== 缓存清理策略 ==========
  
  /// 自动清理触发阈值（缓存大小百分比）
  static const double autoCleanupThreshold = 0.9; // 90%
  
  /// 清理目标百分比（清理后保留的缓存大小）
  static const double cleanupTargetPercentage = 0.7; // 70%
}

