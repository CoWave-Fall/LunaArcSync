// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get settingsPageTitle => '设置';

  @override
  String get languageSettingTitle => '语言';

  @override
  String get languageSettingSubtitle => '中文';

  @override
  String get importDatabaseTitle => '导入数据库';

  @override
  String get exportDatabaseTitle => '导出数据库';

  @override
  String get darkModeTitle => '深色模式';

  @override
  String get notificationsTitle => '通知';

  @override
  String get clearCacheTitle => '清除缓存';

  @override
  String get aboutTitle => '关于';

  @override
  String get appVersion => '0.0.1';

  @override
  String get appLegalese => '泠月案阁 (LunaArcSync) 是一个开源的文档管理和同步应用。';

  @override
  String get aiContentNotice =>
      '本程序含有生成式AI生成的内容。感谢Gemini、Claude、DeepSeek在开发过程中的帮助。';

  @override
  String get trademarkNotice => '商标声明：';

  @override
  String get trademarkGemini => '• \"Gemini\" 是 Google LLC 的商标';

  @override
  String get trademarkClaude => '• \"Claude\" 是 Anthropic PBC 的商标';

  @override
  String get trademarkDeepSeek => '• \"DeepSeek\" 是 DeepSeek 的商标';

  @override
  String get trademarkDisclaimer => '• 上述商标归各自所有者所有，本程序不声称拥有这些商标';

  @override
  String get appInfoPlaceholder =>
      '泠月案阁 (LunaArcSync) 是一个开源的文档管理和同步应用。\n\n程序（排名不分先后）：\n• Gemini\n• Claude\n• DeepSeek\n• CoWave-Fall\n\n项目地址：\nhttps://github.com/CoWave-Fall/LunaArcSync\n\n作者主页：\nhttps://github.com/CoWave-Fall/';

  @override
  String get viewLicenses => '查看许可';

  @override
  String get licensesTitle => '开源许可';

  @override
  String get licensesContent =>
      '基于以下开源项目构建：\n\n• Flutter (BSD-3-Clause)\n• Dio (MIT)\n• flutter_bloc (MIT)\n• go_router (BSD-3-Clause)\n• image_cropper (MIT)\n• pdfx (MIT)\n• flutter_svg (MIT)\n• file_picker (MIT)\n• shared_preferences (BSD-3-Clause)\n• provider (MIT)\n• file_saver (MIT)\n• path_provider (BSD-3-Clause)\n• device_info_plus (MIT)\n• package_info_plus (MIT)\n• cunning_document_scanner (MIT)\n• image (MIT)\n• path (BSD-3-Clause)\n• bloc (MIT)\n• get_it (MIT)\n• injectable (MIT)\n• freezed_annotation (MIT)\n• json_annotation (MIT)\n• flutter_secure_storage (MIT)\n• intl (BSD-3-Clause)\n• material_tag_editor (MIT)\n• image_cropper_platform_interface (MIT)\n\n其他依赖库详见 pubspec.yaml';

  @override
  String get overviewAppBarTitle => '概览';

  @override
  String get overviewRecentActivity => '最近活动';

  @override
  String get logoutButtonTooltip => '登出';

  @override
  String get welcomeBack => '欢迎回来！';

  @override
  String get welcomeSubtitle => '这是您活动的摘要。';

  @override
  String get jobsPageTitle => '任务';

  @override
  String get loadHistoryTooltip => '加载历史';

  @override
  String get refreshTooltip => '刷新';

  @override
  String get deleteJobTitle => '删除任务';

  @override
  String get deleteJobMessage => '您确定要删除此任务吗？此操作无法撤销。';

  @override
  String get delete => '删除';

  @override
  String get cancel => '取消';

  @override
  String get jobCompleted => '任务完成';

  @override
  String get pdfExportCompleted => 'PDF导出完成';

  @override
  String get ocrProcessingCompleted => 'OCR处理完成';

  @override
  String get batchExportCompleted => '批量导出完成';

  @override
  String get view => '查看';

  @override
  String get jobFailed => '任务失败';

  @override
  String get pdfExportFailed => 'PDF导出失败';

  @override
  String get ocrProcessingFailed => 'OCR处理失败';

  @override
  String get batchExportFailed => '批量导出失败';

  @override
  String get unknownError => '未知错误';

  @override
  String get downloadingResult => '正在下载结果文件...';

  @override
  String downloadSuccess(String fileName, String fileSize) {
    return '文件下载成功！已保存为 $fileName (${fileSize}MB)';
  }

  @override
  String downloadFailed(String error) {
    return '下载失败：$error';
  }

  @override
  String get jobId => '任务ID';

  @override
  String get submitted => '提交时间';

  @override
  String get started => '开始时间';

  @override
  String get completed => '完成时间';

  @override
  String get pageId => '页面ID';

  @override
  String get downloadResult => '下载结果';

  @override
  String get loadingJobs => '正在加载任务...';

  @override
  String get refreshingJobs => '正在刷新任务...';

  @override
  String get failedToLoadJobs => '加载任务失败';

  @override
  String get tryAgain => '重试';

  @override
  String get noJobsFound => '未找到任务';

  @override
  String get noJobsDescription => '您目前没有任何活跃任务。\n所有任务都已完成或没有正在进行的任务。';

  @override
  String get refreshJobs => '刷新任务';

  @override
  String get viewJobHistory => '查看任务历史';

  @override
  String get jobsInfo => '当您开始处理文档或执行批量操作时，任务将在此处显示。';

  @override
  String get cannotDeleteQueuedJobs => '无法删除排队中或正在处理的任务。请等待它们完成。';

  @override
  String failedToDeleteJob(String error) {
    return '删除任务失败：$error';
  }

  @override
  String get gridColumns => '网格列数';

  @override
  String get columns => '列数';

  @override
  String get defaultViewMode => '默认视图模式';

  @override
  String get defaultViewModeDescription => '选择页面默认的显示方式';

  @override
  String get listView => '列表视图';

  @override
  String get gridView => '网格视图';

  @override
  String get darkModeImageProcessing => '深色模式图像处理';

  @override
  String get darkModeImageProcessingSubtitle => '调整深色模式的图像处理';

  @override
  String get english => 'English';

  @override
  String get chinese => '中文';

  @override
  String get editDocumentInfo => '编辑文档信息';

  @override
  String get documentTitle => '文档标题';

  @override
  String get pleaseEnterTitle => '请输入标题';

  @override
  String get loadingDocument => '正在加载文档...';

  @override
  String get documentEmpty => '此文档为空。添加页面开始使用！';

  @override
  String get switchView => '切换视图';

  @override
  String get gridSettings => '网格设置';

  @override
  String get exportAsPdf => '导出为PDF';

  @override
  String get deletePage => '删除页面';

  @override
  String get movePage => '移动页面';

  @override
  String get addPage => '添加页面';

  @override
  String get edit => '编辑';

  @override
  String get done => '完成';

  @override
  String get save => '保存';

  @override
  String get confirm => '确认';

  @override
  String get areYouSure => '您确定吗？';

  @override
  String get thisActionCannotBeUndone => '此操作无法撤销。';

  @override
  String get page => '页面';

  @override
  String get pages => '页面';

  @override
  String get ofPages => '共';

  @override
  String get noPagesFound => '未找到页面';

  @override
  String get addFirstPage => '添加您的第一个页面';

  @override
  String get scanDocument => '扫描文档';

  @override
  String get importImage => '导入图片';

  @override
  String get takePhoto => '拍照';

  @override
  String get selectFromGallery => '从相册选择';

  @override
  String get documentSaved => '文档保存成功';

  @override
  String get documentDeleted => '文档删除成功';

  @override
  String get pageDeleted => '页面删除成功';

  @override
  String get pageMoved => '页面移动成功';

  @override
  String get errorOccurred => '发生错误';

  @override
  String get retry => '重试';

  @override
  String get close => '关闭';

  @override
  String get aboutAppBarTitle => '关于';

  @override
  String get errorLoadingAbout => '加载关于信息失败';

  @override
  String get connectionErrorTitle => '服务器连接失败';

  @override
  String get authErrorTitle => '认证失败';

  @override
  String get backToLogin => '返回登录';

  @override
  String get retryButton => '重试';

  @override
  String get aboutAppInfo => '应用程序信息';

  @override
  String get aboutAppName => '泠月案阁';

  @override
  String get aboutVersion => '版本';

  @override
  String get aboutContact => '联系信息';

  @override
  String get aboutGitHub => 'GitHub仓库';

  @override
  String get aboutServerInfo => '服务器信息';

  @override
  String get aboutUserAccount => '用户账号';

  @override
  String get aboutClientInfo => '客户端信息';

  @override
  String get aboutLoginStatus => '登录状态';

  @override
  String get aboutChecking => '检查中...';

  @override
  String get aboutLoggedIn => '已登录';

  @override
  String get aboutNotLoggedIn => '未登录';

  @override
  String get aboutUserId => '用户ID';

  @override
  String get aboutPackageName => '包名';

  @override
  String get aboutDeviceModel => '设备型号';

  @override
  String get aboutDeviceOS => '操作系统';

  @override
  String get aboutDeviceInfo => '设备信息';

  @override
  String get aboutLoading => '加载中...';

  @override
  String get aboutUnknown => '未知';

  @override
  String get loginManualLoginRequired => '请先手动登录一次以保存凭据';

  @override
  String loginAutoLoginFailed(String error) {
    return '自动登录失败: $error';
  }

  @override
  String get loginDeleteServer => '删除服务器';

  @override
  String loginDeleteServerConfirm(String serverName) {
    return '确定要删除服务器 \"$serverName\" 吗？';
  }

  @override
  String loginServerDeleted(String serverName) {
    return '已删除服务器 \"$serverName\"';
  }

  @override
  String loginDeleteServerFailed(String error) {
    return '删除服务器失败: $error';
  }

  @override
  String get appTitle => '泠月案阁';

  @override
  String get appTitleCharacters => '泠月案阁';

  @override
  String get settingsExportDatabase => '导出数据库';

  @override
  String get settingsExportDatabaseDescription => '这将导出您的所有数据，包括文档、页面、设置等。\n\n';

  @override
  String get settingsExportDatabaseAdditionalInfo =>
      '导出的数据将保存为ZIP文件，您可以在其他设备上导入使用。\n\n确定要继续吗？';

  @override
  String get settingsImportDatabase => '导入数据库';

  @override
  String get settingsImportDatabaseDescription => '请选择之前导出的ZIP文件进行导入。\n\n';

  @override
  String get settingsImportDatabaseAdditionalInfo =>
      '注意：导入数据将覆盖当前设备上的所有数据，请确保已备份重要信息。\n\n导入完成后需要重启应用才能生效。\n\n确定要继续吗？';

  @override
  String get settingsFileTooLarge => '文件过大，请选择小于100MB的文件';

  @override
  String get settingsFileCorrupted => '无法读取文件，请确保文件未损坏';

  @override
  String get settingsNoFileSelected => '未选择文件';

  @override
  String settingsFileSelectionError(String error) {
    return '选择文件时出错: $error';
  }

  @override
  String get settingsSavingExportFile => '正在保存导出文件...';

  @override
  String get settingsSaveExportFile => '保存导出文件';

  @override
  String get settingsSaveCancelled => '保存已取消';

  @override
  String settingsExportSuccess(String fileName, String fileSize) {
    return '导出成功！文件已保存为 $fileName (${fileSize}MB)';
  }

  @override
  String settingsSaveFileFailed(String error) {
    return '保存文件失败: $error';
  }

  @override
  String get saveFile => '保存文件';

  @override
  String get saveCancelled => '保存已取消';

  @override
  String get settingsImportSuccess => '导入成功';

  @override
  String get settingsImportSuccessDescription => '数据导入成功！\n\n';

  @override
  String get settingsImportSuccessAdditionalInfo =>
      '为了确保所有数据正确加载，请重启应用程序。\n\n点击确定后应用将关闭，请手动重新打开。';

  @override
  String get settingsRefreshPageToCompleteImport => '请刷新页面以完成导入';

  @override
  String get settingsExportConfirmMessage =>
      '导出的数据将保存为ZIP文件，您可以在其他设备上导入使用。\n\n确定要继续吗？';

  @override
  String get settingsAppearanceSettings => '外观设置';

  @override
  String get settingsDisplaySettings => '显示设置';

  @override
  String get settingsJobSettings => '任务设置';

  @override
  String get settingsNotificationSettings => '通知设置';

  @override
  String get settingsDataManagement => '数据管理';

  @override
  String get settingsAbout => '关于';

  @override
  String get settingsPollingIntervalLabel => '秒';

  @override
  String get settingsOpenSourceThanks => '感谢以下开源项目的支持：';

  @override
  String get settingsOtherDependencies => '其他依赖库详见 pubspec.yaml 文件';

  @override
  String get settingsLicenseTitle => '许可证';

  @override
  String settingsLicenseUnavailable(String licenseType) {
    return '许可证内容暂不可用。\n\n许可证类型: $licenseType\n\n请访问项目主页查看完整的许可证信息。';
  }

  @override
  String get settingsAppName => '泠月案阁';

  @override
  String get settingsProgramContributors => '程序';

  @override
  String get settingsAiContentNotice => 'AI生成内容声明';

  @override
  String get settingsTechnicalInfo => '技术信息';

  @override
  String get settingsPackageName => '包名';

  @override
  String get settingsVersion => '版本';

  @override
  String get settingsBuildNumber => '构建号';

  @override
  String get settingsProjectUrl => '项目地址';

  @override
  String get settingsAuthorUrl => '作者主页';

  @override
  String get settingsThemeSettings => '主题设置';

  @override
  String get settingsThemeColor => '主题颜色';

  @override
  String get settingsThemeColorDescription => '选择应用的主题颜色';

  @override
  String get settingsBackgroundImage => '背景图片';

  @override
  String get settingsBackgroundImageEnabled => '已启用自定义背景';

  @override
  String get settingsBackgroundImageDisabled => '使用默认背景';

  @override
  String get settingsBackgroundImageDescription =>
      '设置自定义背景图片，启用后侧边栏和卡片将显示毛玻璃效果';

  @override
  String get settingsBackgroundImageEnable => '启用自定义背景';

  @override
  String get settingsBackgroundImageSelect => '选择图片';

  @override
  String get settingsBackgroundImageRemove => '删除背景';

  @override
  String get settingsBackgroundImageRemoveConfirm => '确定要删除自定义背景图片吗？';

  @override
  String get settingsBackgroundImageSet => '背景图片设置成功';

  @override
  String settingsBackgroundImageError(String error) {
    return '设置背景图片时出错：$error';
  }

  @override
  String get settingsJobHistory => '任务历史';

  @override
  String settingsMaxJobHistoryRecords(String count) {
    return '最大记录数: $count';
  }

  @override
  String get settingsPollingInterval => '轮询间隔';

  @override
  String settingsPollingIntervalValue(String seconds) {
    return '间隔: $seconds秒';
  }

  @override
  String get settingsFollowSystem => '跟随系统';

  @override
  String get settingsFollowSystemDescription => '根据系统设置自动切换';

  @override
  String get settingsLightTheme => '浅色主题';

  @override
  String get settingsLightThemeDescription => '始终使用浅色主题';

  @override
  String get settingsDarkTheme => '深色主题';

  @override
  String get settingsDarkThemeDescription => '始终使用深色主题';

  @override
  String get simpleAnimationExampleTitle => '简单SVG动画示例';

  @override
  String get svgAnimationDemoTitle => 'SVG动画演示';

  @override
  String get svgAnimationEnableAnimation => '启用动画';

  @override
  String svgAnimationLogoSize(String size) {
    return 'Logo大小: ${size}px';
  }

  @override
  String jobsTaskCompletedWithId(String message, String jobId) {
    return '$message！任务ID: $jobId...';
  }

  @override
  String get documentNotLoadedCannotExport => '文档未加载，无法导出';

  @override
  String get documentEmptyCannotExportPdf => '文档为空，无法导出PDF';

  @override
  String get documentExportAsPdf => '导出为PDF';

  @override
  String documentExportAsPdfDescription(String title) {
    return '将导出文档 \"$title\" 为PDF文件。\n\n';
  }

  @override
  String documentExportAsPdfAdditionalInfo(String pageCount) {
    return '文档包含 $pageCount 页，导出任务将在后台处理。\n\n您可以在\"任务\"页面查看导出进度和结果。\n\n确定要开始导出吗？';
  }

  @override
  String get documentStartExport => '开始导出';

  @override
  String documentPdfExportTaskStarted(String jobId) {
    return 'PDF导出任务已启动！任务ID: $jobId...';
  }

  @override
  String get loginWelcomeMessage => '登录泠月案阁';

  @override
  String get loginSelectServer => '选择服务器';

  @override
  String get loginAddServer => '添加服务器';

  @override
  String get myDocuments => '我的文档';

  @override
  String get themeModeSystem => '跟随系统';

  @override
  String get themeModeLight => '浅色主题';

  @override
  String get themeModeDark => '深色主题';

  @override
  String get loginWelcomeBack => '欢迎回来！';

  @override
  String get loginServerAddress => '服务器地址 (IP:端口)';

  @override
  String get loginServerAddressHint => '192.168.1.100:8080';

  @override
  String get loginServerAddressHelper => '输入IP地址和端口 (例如: 192.168.1.100:8080)';

  @override
  String get loginEmail => '邮箱';

  @override
  String get loginPassword => '密码';

  @override
  String get loginButton => '登录';

  @override
  String get loginSuccess => '登录成功！';

  @override
  String get loginRegisterPrompt => '没有账户？注册';

  @override
  String get loginServerAddressRequired => '请输入服务器地址';

  @override
  String get loginServerAddressInvalidFormat =>
      '请输入IP:端口格式 (例如: 192.168.1.100:8080)';

  @override
  String get loginServerAddressInvalidParts =>
      '格式无效。请使用IP:端口 (例如: 192.168.1.100:8080)';

  @override
  String get loginEmailRequired => '请输入有效的邮箱';

  @override
  String get loginPasswordRequired => '密码不能为空';

  @override
  String get darkModeSettingsTitle => '深色模式图像处理';

  @override
  String get darkModeSettingsDarkTextThreshold => '深色文本阈值';

  @override
  String darkModeSettingsDarkTextThresholdDescription(String value) {
    return '$value (0-255) - 较低的值捕获更多文本';
  }

  @override
  String get darkModeSettingsWhiteThreshold => '白色阈值';

  @override
  String darkModeSettingsWhiteThresholdDescription(String value) {
    return '$value (0-255)';
  }

  @override
  String get darkModeSettingsDarkenFactor => '变暗系数';

  @override
  String darkModeSettingsDarkenFactorDescription(String value) {
    return '$value%';
  }

  @override
  String get darkModeSettingsLightenFactor => '变亮系数';

  @override
  String darkModeSettingsLightenFactorDescription(String value) {
    return '$value%';
  }

  @override
  String get darkModeSettingsNote => '注意：更改将应用于新的图像渲染。现有缓存的图像将使用旧设置。';

  @override
  String get darkModeSettingsResetDefaults => '重置为默认值';

  @override
  String get darkModeSettingsClose => '关闭';

  @override
  String get clearCacheSelectTypes => '选择要清除的缓存类型：';

  @override
  String get clearCachePdfImages => 'PDF图像';

  @override
  String get clearCacheDarkModeSettings => '深色模式设置';

  @override
  String get clearCacheJobHistory => '任务历史';

  @override
  String get clearCacheTotalSize => '总缓存大小：';

  @override
  String get clearCacheClearSelected => '清除选中项';

  @override
  String get clearCacheClearAll => '清除全部';

  @override
  String get clearCacheSuccess => '选中的缓存清除成功';

  @override
  String get clearCacheAllSuccess => '所有缓存清除成功';

  @override
  String get fontSettingsTitle => '字体设置';

  @override
  String get fontSettingsSubtitle => '选择应用字体';

  @override
  String get fontLXGWWenKaiMono => '霞鹜文楷等宽';

  @override
  String get fontSystem => '系统默认';

  @override
  String get ocrProcessingInProgress => '正在处理OCR...';

  @override
  String get ocrTaskCompleted => 'OCR处理完成！';

  @override
  String ocrTaskStartFailed(String error) {
    return 'OCR任务启动失败: $error';
  }

  @override
  String get renderFailed => '渲染失败';

  @override
  String get copyAllText => '复制全部文本';

  @override
  String get textCopied => '文本已复制到剪贴板';

  @override
  String get copyText => '复制文本';

  @override
  String get selectAll => '全选';

  @override
  String get copy => '复制';

  @override
  String get createNewDocument => '创建新文档';

  @override
  String get thisDocumentIsEmpty => '此文档为空。添加页面开始使用！';

  @override
  String get tags => '标签';

  @override
  String get addTag => '添加标签';

  @override
  String get filterByTags => '按标签筛选';

  @override
  String get goodMorning => '早上好';

  @override
  String get goodAfternoon => '中午好';

  @override
  String get goodEvening => '晚上好';

  @override
  String get loadingDocuments => '正在加载文档...';

  @override
  String get selectFromFiles => '从文件选择';

  @override
  String get refresh => '刷新';

  @override
  String get pagesUploadedSuccessfully => '页面上传成功！';

  @override
  String get pdfUploadedSuccessfully => 'PDF上传成功！正在处理页面...';

  @override
  String get failedToCreateDocument => '创建文档失败';

  @override
  String get theConnectErrored => '连接错误';

  @override
  String get cancelCreate => '取消创建';

  @override
  String get titleCannotBeEmpty => '标题不能为空';

  @override
  String get create => '创建';

  @override
  String get versionHistory => '版本历史';

  @override
  String get viewVersionHistory => '查看版本历史';

  @override
  String get noVersionHistoryFound => '未找到版本历史';

  @override
  String get current => '当前';

  @override
  String get numberOfColumns => '列数';

  @override
  String get searchDocuments => '搜索文档';

  @override
  String get searchDocumentsPagesContent => '搜索文档、页面、内容...';

  @override
  String get startTypingToSearch => '开始输入以搜索';

  @override
  String get searchFailed => '搜索失败';

  @override
  String get uploadingAndProcessingPdf => '正在上传和处理PDF...';

  @override
  String get pdfUploadFailed => 'PDF上传失败';

  @override
  String get noResultsFound => '未找到结果';

  @override
  String get accErr001 => '该邮箱已存在用户。';

  @override
  String get accErr002 => '用户创建失败。';

  @override
  String get accSuc001 => '用户创建成功！';

  @override
  String get accErr003 => '邮箱或密码无效。';

  @override
  String get pagErr001 => '文件是必需的。';

  @override
  String get pagErr002 => '文档未找到或不属于您。';

  @override
  String pagErr003(String duplicatePageIds) {
    return '请求中发现重复的页面ID：$duplicatePageIds';
  }

  @override
  String pagErr004(String duplicateOrders) {
    return '请求中发现重复的顺序号：$duplicateOrders';
  }

  @override
  String get pagErr005 => '更新页面顺序失败。请确保所有页面属于指定文档和用户。';

  @override
  String pagErr006(String maxOrder) {
    return '新顺序必须在1到$maxOrder之间。';
  }

  @override
  String get pagErr007 => '插入过程中更新页面顺序失败。';

  @override
  String get pagErr008 => '未提供文件。';

  @override
  String get pagErr009 => '未提供图片文件。';

  @override
  String get pagErr010 => '请上传有效的PDF文件。';

  @override
  String get pagErr011 => '只允许PDF文件。';

  @override
  String get pagErr012 => '文档未找到或没有页面。';

  @override
  String pagErr013(String pageId, String documentId) {
    return '在文档$documentId中未找到ID为$pageId的页面。';
  }

  @override
  String get pagErr014 => '文档未找到。';

  @override
  String get docErr001 => '添加页面到文档失败。页面可能不存在、不属于您或已在其他文档中。';

  @override
  String get docErr002 => '未提供文档ID。';

  @override
  String jobErr001(String jobId) {
    return '未找到ID为$jobId的任务';
  }

  @override
  String jobErr002(String versionId) {
    return '未找到ID为$versionId的版本';
  }

  @override
  String jobErr003(String pageId) {
    return '未找到ID为$pageId的页面';
  }

  @override
  String jobErr004(String versionId) {
    return '未找到ID为$versionId的版本';
  }

  @override
  String jobErr005(String jobId) {
    return '未找到ID为$jobId的任务';
  }

  @override
  String get jobSuc001 => 'OCR任务已排队。';

  @override
  String get jobSuc002 => '拼接任务已排队。';

  @override
  String get jobSuc003 => '任务已成功取消。';

  @override
  String get imgErr001 => '页面未找到。';

  @override
  String get imgErr002 => '缩略图不可用。';

  @override
  String get imgErr003 => '存储中未找到缩略图文件。';

  @override
  String get verErr001 => '页面未找到。';

  @override
  String get verErr002 => '页面未找到。';

  @override
  String get srcErr001 => '搜索查询不能为空。';

  @override
  String get datErr001 => '必须提供目标用户ID。';

  @override
  String get datErr002 => '未上传文件。';

  @override
  String get datErr003 => '未上传文件。';

  @override
  String get datSuc001 => '数据导入成功。';

  @override
  String get datSuc002 => '您的数据导入成功。';

  @override
  String get appInfo001 => '初始化中';

  @override
  String get pdfErr001 => '读取PDF文件获取页数失败。文件可能已损坏或无效。';

  @override
  String get pdfErr002 => '读取或处理PDF文件失败。文件可能已损坏或格式不支持。';

  @override
  String get pdfErr003 => '从PDF文件提取文本失败。文件可能已损坏或格式不支持。';

  @override
  String pdfErr004(String pageNumber) {
    return '从PDF文件第$pageNumber页提取文本失败。文件可能已损坏或格式不支持。';
  }

  @override
  String get ocrErr001 => '版本未找到。';

  @override
  String get ocrErr002 => '版本缺少文件元数据。';

  @override
  String get ocrErr003 => '文件未找到。';

  @override
  String get ocrErr004 => '无法从版本文件获取图像数据。';

  @override
  String get stiErr001 => '拼接至少需要两个源图像。';

  @override
  String get stiErr002 => '一个或多个源版本未找到。';

  @override
  String stiErr003(String status) {
    return '无法拼接图像。状态：$status';
  }

  @override
  String stiErr004(String pageId, String userId) {
    return '用户$userId的页面ID $pageId未找到。';
  }

  @override
  String get impErr001 => '非管理员导出必须提供用户ID。';

  @override
  String get impErr002 => '导入归档中未找到data.json。';

  @override
  String get networkErrorTitle => '网络错误';

  @override
  String get networkErrorServerOffline =>
      '服务器离线或无法访问\n\n建议：\n1. 检查网络连接\n2. 尝试切换服务器\n3. 稍后重试';

  @override
  String get networkErrorConnectionFailed =>
      '无法连接到服务器\n\n建议：\n1. 检查服务器地址是否正确\n2. 检查网络连接\n3. 检查防火墙设置';

  @override
  String get networkErrorConnectionTimeout =>
      '连接超时\n\n建议：\n1. 检查网络连接速度\n2. 尝试切换到更稳定的网络\n3. 稍后重试';

  @override
  String get networkErrorUnauthorized => '认证失败\n\n您的登录已过期，请重新登录';

  @override
  String get networkErrorForbidden => '权限不足\n\n您没有权限访问此资源';

  @override
  String get networkErrorNotFound => '资源不存在\n\n请求的资源未找到';

  @override
  String get networkErrorServerError => '服务器错误\n\n服务器遇到了问题，请稍后重试';

  @override
  String get networkErrorGeneric => '网络错误\n\n请检查您的网络连接并重试';

  @override
  String get errorRetry => '重试';

  @override
  String get errorDismiss => '关闭';

  @override
  String get errorDetails => '技术详情';

  @override
  String get errorServerUnreachable => '服务器不可达';

  @override
  String get errorAuthenticationFailed => '认证失败';

  @override
  String get errorOccurredTitle => '出错了';
}
