/// 毛玻璃效果预设配置
/// 
/// 为不同类型的组件提供推荐的毛玻璃参数
class GlassmorphicPresets {
  // 防止实例化
  GlassmorphicPresets._();

  // ========== 列表项预设 ==========
  
  /// 文档列表项
  static const double documentListBlur = 8.0;
  static const double documentListOpacity = 0.15;
  
  /// 页面列表项
  static const double pageListBlur = 8.0;
  static const double pageListOpacity = 0.15;
  
  /// 任务列表项（Jobs）
  static const double jobListBlur = 10.0;
  static const double jobListOpacity = 0.2;

  // ========== 卡片预设 ==========
  
  /// 关于页面卡片（较重的毛玻璃效果）
  static const double aboutCardBlur = 15.0;
  static const double aboutCardOpacity = 0.2;
  
  /// 设置页面卡片
  static const double settingsCardBlur = 12.0;
  static const double settingsCardOpacity = 0.18;
  
  /// 信息卡片（轻量级）
  static const double infoCardBlur = 10.0;
  static const double infoCardOpacity = 0.15;

  // ========== 对话框和弹出层预设 ==========
  
  /// 对话框背景
  static const double dialogBlur = 20.0;
  static const double dialogOpacity = 0.25;
  
  /// 底部弹出层
  static const double bottomSheetBlur = 15.0;
  static const double bottomSheetOpacity = 0.2;

  // ========== 导航栏预设 ==========
  
  /// 顶部导航栏
  static const double appBarBlur = 12.0;
  static const double appBarOpacity = 0.15;
  
  /// 底部导航栏
  static const double bottomNavBarBlur = 12.0;
  static const double bottomNavBarOpacity = 0.2;

  // ========== 搜索和输入预设 ==========
  
  /// 搜索栏
  static const double searchBarBlur = 10.0;
  static const double searchBarOpacity = 0.15;
  
  /// 输入框
  static const double inputFieldBlur = 8.0;
  static const double inputFieldOpacity = 0.1;

  // ========== 特殊效果预设 ==========
  
  /// 悬浮操作按钮（FAB）背景
  static const double fabBlur = 12.0;
  static const double fabOpacity = 0.2;
  
  /// 工具提示背景
  static const double tooltipBlur = 10.0;
  static const double tooltipOpacity = 0.25;
  
  /// 加载遮罩
  static const double loadingOverlayBlur = 8.0;
  static const double loadingOverlayOpacity = 0.3;

  // ========== 辅助方法 ==========
  
  /// 获取组件预设配置
  /// 
  /// [componentType] 组件类型标识
  /// 返回 Map，包含 'blur' 和 'opacity' 键
  static Map<String, double> getPreset(String componentType) {
    switch (componentType) {
      // 列表项
      case 'document_list':
        return {'blur': documentListBlur, 'opacity': documentListOpacity};
      case 'page_list':
        return {'blur': pageListBlur, 'opacity': pageListOpacity};
      case 'job_list':
        return {'blur': jobListBlur, 'opacity': jobListOpacity};
      
      // 卡片
      case 'about_card':
        return {'blur': aboutCardBlur, 'opacity': aboutCardOpacity};
      case 'settings_card':
        return {'blur': settingsCardBlur, 'opacity': settingsCardOpacity};
      case 'info_card':
        return {'blur': infoCardBlur, 'opacity': infoCardOpacity};
      
      // 对话框
      case 'dialog':
        return {'blur': dialogBlur, 'opacity': dialogOpacity};
      case 'bottom_sheet':
        return {'blur': bottomSheetBlur, 'opacity': bottomSheetOpacity};
      
      // 导航栏
      case 'app_bar':
        return {'blur': appBarBlur, 'opacity': appBarOpacity};
      case 'bottom_nav_bar':
        return {'blur': bottomNavBarBlur, 'opacity': bottomNavBarOpacity};
      
      // 搜索和输入
      case 'search_bar':
        return {'blur': searchBarBlur, 'opacity': searchBarOpacity};
      case 'input_field':
        return {'blur': inputFieldBlur, 'opacity': inputFieldOpacity};
      
      // 特殊效果
      case 'fab':
        return {'blur': fabBlur, 'opacity': fabOpacity};
      case 'tooltip':
        return {'blur': tooltipBlur, 'opacity': tooltipOpacity};
      case 'loading_overlay':
        return {'blur': loadingOverlayBlur, 'opacity': loadingOverlayOpacity};
      
      // 默认值
      default:
        return {'blur': 10.0, 'opacity': 0.15};
    }
  }
  
  /// 获取模糊强度
  static double getBlur(String componentType) {
    return getPreset(componentType)['blur']!;
  }
  
  /// 获取不透明度
  static double getOpacity(String componentType) {
    return getPreset(componentType)['opacity']!;
  }
}

