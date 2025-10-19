import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luna_arc_sync/core/api/api_client.dart';
import 'package:luna_arc_sync/core/di/injection.dart';
import 'package:luna_arc_sync/data/models/job_models.dart';
import 'package:luna_arc_sync/l10n/app_localizations.dart';
import 'package:luna_arc_sync/presentation/pages/cubit/page_detail_cubit.dart';
import 'package:luna_arc_sync/presentation/pages/cubit/page_detail_state.dart';
import 'package:luna_arc_sync/data/models/page_models.dart';
import 'package:luna_arc_sync/presentation/pages/view/version_history_Page.dart';
import 'package:luna_arc_sync/presentation/pages/widgets/highlight_overlay_with_fitted_box.dart';
import 'package:luna_arc_sync/presentation/pages/widgets/ocr_text_overlay_with_fitted_box.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:luna_arc_sync/core/config/pdf_render_backend.dart';
import 'package:luna_arc_sync/presentation/pages/widgets/pdfx_renderer.dart';
import 'package:luna_arc_sync/presentation/pages/widgets/pdfrx_renderer.dart';
import 'package:luna_arc_sync/core/cache/image_cache_service_enhanced.dart';
import 'package:luna_arc_sync/core/theme/background_image_notifier.dart';
import 'package:luna_arc_sync/core/theme/fullscreen_notifier.dart';
import 'package:luna_arc_sync/core/services/page_preload_service.dart';
import 'package:luna_arc_sync/data/repositories/document_repository.dart';
import 'package:luna_arc_sync/data/repositories/page_repository.dart';
import 'package:luna_arc_sync/core/theme/page_navigation_notifier.dart';
import 'package:luna_arc_sync/core/cache/pdf_preload_manager.dart';

/// 文件加载结果
class _FileLoadResult {
  final Uint8List bytes;
  final String contentType;
  final bool fromCache;

  _FileLoadResult({
    required this.bytes,
    required this.contentType,
    required this.fromCache,
  });
}

class PageDetailPage extends StatefulWidget {
  final String pageId;
  final List<String>? pageIds; // 页面ID列表，用于前后导航
  final int? currentIndex; // 当前页面在列表中的索引
  final int? totalPageCount; // 文档的总页面数
  final String? documentId; // 文档ID，用于获取更多页面
  
  const PageDetailPage({
    super.key, 
    required this.pageId,
    this.pageIds,
    this.currentIndex,
    this.totalPageCount,
    this.documentId,
  });

  @override
  State<PageDetailPage> createState() => _PageDetailPageState();
}

class _PageDetailPageState extends State<PageDetailPage> {
  late final PageController _pageController;
  late int _currentPageIndex;
  final FocusNode _focusNode = FocusNode(); // 用于键盘事件监听
  final Map<String, GlobalKey<_PageContentWidgetState>> _pageKeys = {};
  bool _isSearchVisible = false;
  final _searchController = TextEditingController();
  bool _isFullscreen = false; // 全屏模式标志
  
  // 动态页数管理
  List<String> _currentPageIds = [];
  int _currentTotalPages = 0;
  int _preloadCount = 2;
  final PagePreloadService _preloadService = PagePreloadService();
  
  // 页面详情缓存，避免重复API调用
  final Map<String, String> _pageVersionCache = {};
  
  // 初始化状态
  bool _isInitialized = false;

  /// 立即初始化基本数据
  void _initializeBasicData() {
    // 初始化页面列表
    if (widget.pageIds != null) {
      _currentPageIds = List.from(widget.pageIds!);
      _currentTotalPages = widget.totalPageCount ?? widget.pageIds!.length;
    } else {
      _currentPageIds = [widget.pageId];
      _currentTotalPages = 1;
    }
    
    // 为每个页面创建GlobalKey
    for (final pageId in _currentPageIds) {
      _pageKeys[pageId] = GlobalKey<_PageContentWidgetState>();
    }
    
    // 标记为已初始化
    _isInitialized = true;
  }
  
  @override
  void initState() {
    super.initState();
    _currentPageIndex = widget.currentIndex ?? 0;
    _pageController = PageController(initialPage: _currentPageIndex);
    
    // 立即初始化基本数据，避免null check错误
    _initializeBasicData();
    
    // 异步初始化动态页数管理
    _initializePageManagement();
    
    // 确保页面加载时获取焦点以接收键盘事件
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
      
      // 设置页面详情可见，并更新页面导航信息
      if (mounted) {
        context.read<PageNavigationNotifier>().setPageDetailVisible(true);
        _updatePageNavigationInfo();
      }
    });
  }
  
  /// 异步初始化页面管理
  Future<void> _initializePageManagement() async {
    // 获取预加载设置
    _preloadCount = await _preloadService.getPreloadCount();
    
    // 开始预加载
    if (mounted) {
      _startPreloading();
    }
  }
  
  // 更新页面导航信息
  void _updatePageNavigationInfo() {
    if (!mounted) return;
    
    // 如果有pageIds，使用totalPageCount或pageIds的长度
    if (_currentPageIds.isNotEmpty) {
      // 优先使用totalPageCount，如果没有则使用pageIds的长度
      final totalPages = _currentTotalPages > 0 ? _currentTotalPages : _currentPageIds.length;
      
      context.read<PageNavigationNotifier>().updatePageInfo(
        currentPage: _currentPageIndex + 1,
        totalPages: totalPages,
        onPageChanged: (page) {
          final targetIndex = page - 1;
          if (targetIndex >= 0 && targetIndex < _currentPageIds.length) {
            _pageController.animateToPage(
              targetIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
      );
    } else {
      // 单页面模式
      context.read<PageNavigationNotifier>().updatePageInfo(
        currentPage: 1,
        totalPages: 1,
        onPageChanged: (page) {
          // 单页面模式，不需要页面切换
        },
      );
    }
  }

  /// 开始预加载
  Future<void> _startPreloading() async {
    if (_currentPageIds.isEmpty || _preloadCount <= 0) return;
    
    // 预加载当前页面前后的页面
    final preloadPages = <String>[];
    
    // 预加载前面的页面
    for (int i = 1; i <= _preloadCount; i++) {
      final index = _currentPageIndex - i;
      if (index >= 0 && index < _currentPageIds.length) {
        preloadPages.add(_currentPageIds[index]);
      }
    }
    
    // 预加载后面的页面
    for (int i = 1; i <= _preloadCount; i++) {
      final index = _currentPageIndex + i;
      if (index < _currentPageIds.length) {
        preloadPages.add(_currentPageIds[index]);
      }
    }
    
    if (preloadPages.isNotEmpty) {
      if (kDebugMode) {
        print('开始预加载 ${preloadPages.length} 个页面');
      }
      
      // 为每个页面获取版本ID并预加载
      final futures = <Future<void>>[];
      for (final pageId in preloadPages) {
        futures.add(_preloadSinglePage(pageId));
      }
      
      // 并行执行预加载，但不等待所有完成
      Future.wait(futures).catchError((e) {
        if (kDebugMode) {
          print('批量预加载出现错误: $e');
        }
        return <void>[];
      });
    }
  }
  
  /// 获取当前页面的内容类型
  PageContentType? getCurrentPageContentType() {
    if (_currentPageIds.isEmpty) return null;
    
    final currentPageId = _currentPageIds[_currentPageIndex];
    final versionId = _pageVersionCache[currentPageId];
    
    if (versionId == null) return null;
    
    return _preloadService.getCachedContentType(versionId);
  }
  
  /// 预加载单个页面
  Future<void> _preloadSinglePage(String pageId) async {
    try {
      // 检查缓存中是否已有版本ID
      String? versionId = _pageVersionCache[pageId];
      
      if (versionId == null) {
        // 获取页面详情以获取版本ID
        final pageRepository = getIt<IPageRepository>();
        final pageDetail = await pageRepository.getPageById(pageId);
        
        if (pageDetail.currentVersion?.versionId != null) {
          versionId = pageDetail.currentVersion!.versionId;
          // 缓存版本ID
          _pageVersionCache[pageId] = versionId;
        } else {
          if (kDebugMode) {
            print('页面 $pageId 没有当前版本，跳过预加载');
          }
          return;
        }
      }
      
      // 获取当前暗色模式状态
      final isDarkMode = Theme.of(context).brightness == Brightness.dark;
      
      // 使用版本ID进行预加载
      await _preloadService.preloadPage(
        pageId,
        versionId,
        isDarkMode: isDarkMode,
      );
    } catch (e) {
      if (kDebugMode) {
        print('预加载页面 $pageId 失败: $e');
      }
    }
  }
  
  /// 预加载相邻PDF页面到内存（避免闪烁）
  void _preloadAdjacentPdfToMemory() {
    if (_currentPageIds.isEmpty) return;
    
    // 收集相邻页面ID和版本ID
    final adjacentPageIds = <String>[];
    final adjacentVersionIds = <String>[];
    
    // 预加载前后2页
    final preloadRange = 2;
    
    for (int offset = -preloadRange; offset <= preloadRange; offset++) {
      if (offset == 0) continue; // 跳过当前页
      
      final targetIndex = _currentPageIndex + offset;
      if (targetIndex >= 0 && targetIndex < _currentPageIds.length) {
        final pageId = _currentPageIds[targetIndex];
        final versionId = _pageVersionCache[pageId];
        
        if (versionId != null) {
          adjacentPageIds.add(pageId);
          adjacentVersionIds.add(versionId);
        }
      }
    }
    
    if (adjacentPageIds.isNotEmpty) {
      // 获取当前暗色模式状态
      final isDarkMode = Theme.of(context).brightness == Brightness.dark;
      
      // 异步预加载到内存
      PdfPreloadManager().preloadAdjacentPages(
        adjacentPageIds: adjacentPageIds,
        adjacentVersionIds: adjacentVersionIds,
        isDarkMode: isDarkMode,
      ).catchError((e) {
        if (kDebugMode) {
          print('预加载相邻页面到内存失败: $e');
        }
      });
    }
  }
  
  /// 动态加载更多页面
  Future<void> _loadMorePages() async {
    if (_currentPageIds.length >= _currentTotalPages || widget.documentId == null) {
      return;
    }
    
    try {
      if (kDebugMode) {
        print('开始加载更多页面，当前页数: ${_currentPageIds.length}, 总页数: $_currentTotalPages');
      }
      
      // 使用文档仓库获取更多页面
      final documentRepository = getIt<IDocumentRepository>();
      final currentPage = (_currentPageIds.length ~/ 10) + 1; // 假设每页10个页面
      
      final result = await documentRepository.getPagesForDocument(
        widget.documentId!,
        page: currentPage,
        limit: 10,
      );
      
      if (result.items.isNotEmpty) {
        final newPageIds = result.items.map((page) => page.pageId).toList();
        
        setState(() {
          _currentPageIds.addAll(newPageIds);
          for (final pageId in newPageIds) {
            _pageKeys[pageId] = GlobalKey<_PageContentWidgetState>();
          }
        });
        
        if (kDebugMode) {
          print('成功加载 ${newPageIds.length} 个新页面');
        }
        
        // 预加载新加载的页面
        await _startPreloading();
      }
    } catch (e) {
      if (kDebugMode) {
        print('加载更多页面失败: $e');
      }
    }
  }
  
  // 获取当前页面ID
  String get _currentPageId {
    if (_currentPageIds.isNotEmpty && _currentPageIndex < _currentPageIds.length) {
      return _currentPageIds[_currentPageIndex];
    }
    return widget.pageId;
  }
  
  // 获取当前页面的State
  _PageContentWidgetState? get _currentPageState {
    final key = _pageKeys[_currentPageId];
    return key?.currentState;
  }
  
  // 导航到上一页
  void _navigateToPreviousPage() {
    if (_currentPageIds.isEmpty) return;
    if (_currentPageIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  
  // 导航到下一页
  void _navigateToNextPage() {
    if (_currentPageIds.isEmpty) return;
    
    // 检查是否需要加载更多页面
    if (_currentPageIndex >= _currentPageIds.length - 1 && 
        _currentPageIds.length < _currentTotalPages) {
      _loadMorePages();
    }
    
    if (_currentPageIndex < _currentPageIds.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  
  // 处理键盘事件
  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _navigateToPreviousPage();
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _navigateToNextPage();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  // 切换全屏模式
  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });
    
    // 通知全局全屏状态变化（用于隐藏主侧栏）
    context.read<FullscreenNotifier>().setFullscreen(_isFullscreen);
    
    // 切换系统UI显示
    if (_isFullscreen) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersiveSticky,
      );
    } else {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
      );
    }
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    _focusNode.dispose();
    _searchController.dispose();
    
    // 清理预加载服务
    _preloadService.cancelAllPreloads();
    
    // 清除页面导航信息
    context.read<PageNavigationNotifier>().clear();
    
    // 恢复全屏状态 - 使用mounted检查确保widget仍然活跃
    if (mounted) {
      context.read<FullscreenNotifier>().setFullscreen(false);
    }
    // 恢复系统UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasCustomBackground = context.watch<BackgroundImageNotifier>().hasCustomBackground;
    final currentPageState = _currentPageState;
    
    // 如果还没有初始化完成，显示加载状态
    if (!_isInitialized) {
      return Scaffold(
        backgroundColor: hasCustomBackground ? Colors.transparent : null,
        appBar: AppBar(
          backgroundColor: hasCustomBackground ? Colors.transparent : null,
          title: const Text('Loading...'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return Focus(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: hasCustomBackground ? Colors.transparent : null,
        // 全屏时隐藏侧栏
        drawer: _isFullscreen ? null : null, // 如果有Drawer可以在这里配置
        endDrawer: _isFullscreen ? null : null,
        appBar: _isFullscreen ? null : PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: ClipRect(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AppBar(
                backgroundColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.7),
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    // 如果处于全屏状态，先退出全屏
                    if (_isFullscreen) {
                      context.read<FullscreenNotifier>().setFullscreen(false);
                      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                    }
                    Navigator.of(context).pop();
                  },
                ),
                title: ValueListenableBuilder(
                  valueListenable: currentPageState?._stateNotifier ?? ValueNotifier<int>(0),
                  builder: (context, value, child) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        // 上移动画：旧的上移渐出，新的上移渐入
                        final offsetAnimation = Tween<Offset>(
                          begin: const Offset(0.0, 0.3),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                        ));
                        
                        return SlideTransition(
                          position: offsetAnimation,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      layoutBuilder: (currentChild, previousChildren) {
                        return Stack(
                          alignment: Alignment.centerLeft,
                          children: <Widget>[
                            ...previousChildren,
                            if (currentChild != null) currentChild,
                          ],
                        );
                      },
                      child: _isSearchVisible
                          ? TextField(
                              key: const ValueKey('SearchField'),
                              controller: _searchController,
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText: 'Search in page...',
                                hintStyle:
                                    TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(color: Colors.white, fontSize: 18),
                              onChanged: (query) {
                                currentPageState?.search(query);
                              },
                            )
                          : Text(
                              currentPageState?.pageTitle ?? 'Loading...',
                              key: ValueKey('TitleText_$_currentPageId'),
                            ),
                    );
                  },
                ),
                actions: [
                  // 搜索按钮
                  ValueListenableBuilder(
                    valueListenable: currentPageState?._stateNotifier ?? ValueNotifier<int>(0),
                    builder: (context, value, child) {
                      final hasOcrResult = currentPageState?.hasOcrResult ?? false;
                      if (hasOcrResult) {
                        return IconButton(
                          icon: Icon(_isSearchVisible ? Icons.close : Icons.search),
                          tooltip: 'Search in page',
                          onPressed: () {
                            setState(() {
                              _isSearchVisible = !_isSearchVisible;
                              if (!_isSearchVisible) {
                                currentPageState?.search('');
                                _searchController.clear();
                              }
                            });
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  // 调试按钮 - 只在开发模式下显示
                  if (kDebugMode)
                    ValueListenableBuilder(
                      valueListenable: currentPageState?._stateNotifier ?? ValueNotifier<int>(0),
                      builder: (context, value, child) {
                        final showDebugBorders = currentPageState?.showDebugBorders ?? false;
                        return IconButton(
                          icon: Icon(showDebugBorders ? Icons.bug_report : Icons.bug_report_outlined),
                          tooltip: showDebugBorders ? 'Hide debug borders' : 'Show debug borders',
                          onPressed: () {
                            currentPageState?.toggleDebugBorders();
                          },
                        );
                      },
                    ),
                  // 历史版本按钮
                  IconButton(
                    icon: const Icon(Icons.history),
                    tooltip: AppLocalizations.of(context)?.viewVersionHistory ?? 'View version history',
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => VersionHistoryPage(
                            pageId: _currentPageId,
                            currentVersionId: currentPageState?.currentVersionId,
                          ),
                        ),
                      );
                      if (mounted) {
                        currentPageState?.refreshPage();
                      }
                    },
                  ),
                  // OCR按钮
                  ValueListenableBuilder(
                    valueListenable: currentPageState?._stateNotifier ?? ValueNotifier<int>(0),
                    builder: (context, value, child) {
                      final ocrStatus = currentPageState?.ocrStatus;
                      if (ocrStatus == JobStatusEnum.Processing) {
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return IconButton(
                          icon: const Icon(Icons.document_scanner_outlined),
                          tooltip: 'Start OCR',
                          onPressed: () async {
                            currentPageState?.startOcr();
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            // 主内容区域
            GestureDetector(
              onTapUp: (details) {
                // 检测点击是否在中心区域（中间40%区域）
                final size = MediaQuery.of(context).size;
                final centerLeft = size.width * 0.3;
                final centerRight = size.width * 0.7;
                final centerTop = size.height * 0.3;
                final centerBottom = size.height * 0.7;
                
                final tapX = details.globalPosition.dx;
                final tapY = details.globalPosition.dy;
                
                if (tapX > centerLeft && tapX < centerRight &&
                    tapY > centerTop && tapY < centerBottom) {
                  _toggleFullscreen();
                }
              },
              child: _currentPageIds.isNotEmpty
                  ? PageView.builder(
                      controller: _pageController,
                      itemCount: _currentPageIds.length,
                      onPageChanged: (index) async {
                        setState(() {
                          _currentPageIndex = index;
                          // 清除搜索状态
                          if (_isSearchVisible) {
                            _isSearchVisible = false;
                            _searchController.clear();
                          }
                        });
                        
                        // 开始预加载新页面的前后页面
                        await _startPreloading();
                        
                        // 预加载相邻PDF页面到内存（避免闪烁）
                        _preloadAdjacentPdfToMemory();
                        
                        // 检查是否需要加载更多页面
                        if (index >= _currentPageIds.length - 2 && 
                            _currentPageIds.length < _currentTotalPages) {
                          await _loadMorePages();
                        }
                        
                        // 更新页面导航信息
                        _updatePageNavigationInfo();
                      },
                      itemBuilder: (context, index) {
                        if (index >= _currentPageIds.length) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final pageId = _currentPageIds[index];
                        return _PageContentWidget(
                          key: _pageKeys[pageId] ?? GlobalKey<_PageContentWidgetState>(),
                          pageId: pageId,
                        );
                      },
                    )
                  : _PageContentWidget(
                      key: _pageKeys[widget.pageId] ?? GlobalKey<_PageContentWidgetState>(),
                      pageId: widget.pageId,
                    ),
            ),
            // 全屏模式下的进度条（带动画）
            if (_currentPageIds.isNotEmpty)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                left: 0,
                right: 0,
                bottom: _isFullscreen ? 0 : -100,
                child: _FullscreenProgressBar(
                  currentPage: _currentPageIndex + 1,
                  totalPages: _currentTotalPages,
                  onTap: _toggleFullscreen,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// 单个页面的内容widget
/// 使用AutomaticKeepAliveClientMixin保持状态，避免在滑动时重建
class _PageContentWidget extends StatefulWidget {
  final String pageId;
  
  const _PageContentWidget({
    super.key,
    required this.pageId,
  });

  @override
  State<_PageContentWidget> createState() => _PageContentWidgetState();
}

class _PageContentWidgetState extends State<_PageContentWidget> with AutomaticKeepAliveClientMixin {
  late final GlobalKey _imageKey;
  Size? _renderedImageSize;
  JobStatusEnum? _previousOcrStatus;
  bool _showDebugBorders = false;
  PageDetailCubit? _cubit;
  final _stateNotifier = ValueNotifier<int>(0); // 用于通知父组件状态已更新

  @override
  bool get wantKeepAlive => true; // 保持状态，避免重建

  @override
  void initState() {
    super.initState();
    _imageKey = GlobalKey(debugLabel: 'page_image_${widget.pageId}');
  }

  @override
  void dispose() {
    _stateNotifier.dispose();
    super.dispose();
  }
  
  // 通知状态已更新
  void _notifyStateChanged() {
    _stateNotifier.value++;
  }
  
  // 公共接口供父组件调用
  String get pageTitle {
    return _cubit?.state.maybeWhen(
      success: (page, _, _, _, _) => page.title,
      orElse: () => 'Loading...',
    ) ?? 'Loading...';
  }
  
  bool get hasOcrResult {
    return _cubit?.state.maybeWhen(
      success: (page, _, _, _, _) => page.currentVersion?.ocrResult != null,
      orElse: () => false,
    ) ?? false;
  }
  
  JobStatusEnum? get ocrStatus {
    return _cubit?.state.maybeWhen(
      success: (_, ocrStatus, _, _, _) => ocrStatus,
      orElse: () => null,
    );
  }
  
  String? get currentVersionId {
    return _cubit?.state.maybeWhen(
      success: (page, _, _, _, _) => page.currentVersion?.versionId,
      orElse: () => null,
    );
  }
  
  bool get showDebugBorders => _showDebugBorders;
  
  void search(String query) {
    _cubit?.search(query);
  }
  
  void toggleDebugBorders() {
    setState(() {
      _showDebugBorders = !_showDebugBorders;
    });
  }
  
  void refreshPage() {
    _cubit?.fetchPage(widget.pageId);
  }
  
  Future<void> startOcr() async {
    try {
      await _cubit?.startOcrJob();
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.ocrTaskStartFailed(e.toString())),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须调用以保持状态
    
    return BlocProvider(
      create: (context) {
        _cubit = getIt<PageDetailCubit>()..fetchPage(widget.pageId);
        return _cubit!;
      },
      child: BlocConsumer<PageDetailCubit, PageDetailState>(
        listener: (context, state) {
          // 通知父组件状态已更新
          _notifyStateChanged();
          
          state.whenOrNull(
            success: (_, ocrStatus, ocrErrorMessage, _, _) {
              final l10n = AppLocalizations.of(context)!;
              
              // Only show notification when transitioning from Processing to Completed/Failed
              if (_previousOcrStatus == JobStatusEnum.Processing) {
                if (ocrStatus == JobStatusEnum.Completed) {
                  // OCR完成通知
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                        content: Text(l10n.ocrTaskCompleted),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 3)));
                } else if (ocrStatus == JobStatusEnum.Failed && ocrErrorMessage != null) {
                  // OCR失败通知
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                        content: Text(ocrErrorMessage), 
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 4)));
                }
              }
              
              // Update previous status for next comparison
              _previousOcrStatus = ocrStatus;
            },
          );
        },
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(child: CircularProgressIndicator()),
            failure: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(message),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _cubit?.fetchPage(widget.pageId),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            success: (page, ocrStatus, _, searchQuery, highlightedBboxes) {
              if (page.currentVersion == null) {
                return const Center(child: Text('This page has no content yet.'));
              }
              final versionId = page.currentVersion!.versionId;
              final fileUrl = '/api/images/$versionId';

              final ocrResult = page.currentVersion!.ocrResult;
              final l10n = AppLocalizations.of(context)!;
              
              return Column(
                children: [
                  // 顶部进度横幅（非阻塞式）
                  if (ocrStatus == JobStatusEnum.Processing)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              l10n.ocrProcessingInProgress,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  // 页面内容区域
                  Expanded(
                    child: InteractiveViewer(
                      maxScale: 5.0,
                      child: SizedBox.expand(
                        child: FileViewer(
                          fileUrl: fileUrl,
                          pageId: page.pageId,
                          versionId: versionId,
                          imageKey: _imageKey,
                          onImageRendered: (size) {
                            if (_renderedImageSize != size) {
                              setState(() {
                                _renderedImageSize = size;
                                if (kDebugMode) {
                                  print('Rendered image size: $size');
                                }
                              });
                            }
                          },
                          ocrResult: ocrResult,
                          searchQuery: searchQuery,
                          highlightedBboxes: highlightedBboxes,
                          showDebugBorders: _showDebugBorders,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class FileViewer extends StatefulWidget {
  final String fileUrl;
  final String pageId;
  final String versionId;
  final GlobalKey imageKey; // NEW: Key to get rendered size
  final Function(Size)? onImageRendered; // NEW: Callback for rendered size
  final OcrResult? ocrResult;
  final String searchQuery;
  final List<Bbox> highlightedBboxes;
  final bool showDebugBorders;

  const FileViewer({
    super.key,
    required this.fileUrl,
    required this.pageId,
    required this.versionId,
    required this.imageKey, // Make it required
    this.onImageRendered,
    this.ocrResult,
    this.searchQuery = '',
    this.highlightedBboxes = const [],
    this.showDebugBorders = false,
  });

  @override
  State<FileViewer> createState() => _FileViewerState();
}

class _FileViewerState extends State<FileViewer> with AutomaticKeepAliveClientMixin {
  late Future<_FileLoadResult> _loadFuture;
  Size? _imageIntrinsicSize; // 存储图片的固有尺寸
  Size? _calculatedRenderSize; // 存储计算出的实际渲染尺寸

  @override
  bool get wantKeepAlive => true; // 保持状态，避免重建

  @override
  void initState() {
    super.initState();
    _loadFuture = _loadFile();
  }

  Future<Size?> _loadImageIntrinsicSize(Uint8List bytes) async {
    try {
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;
      
      final size = Size(image.width.toDouble(), image.height.toDouble());
      _imageIntrinsicSize = size;
      
      image.dispose();
      codec.dispose();
      
      return size;
    } catch (e) {
      if (kDebugMode) {
        print('❌ 图片解码失败: ${e.toString()}');
        print('数据长度: ${bytes.length} bytes');
        if (bytes.isNotEmpty) {
          print('数据头: ${bytes.take(16).map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}');
        }
      }
      return null;
    }
  }

  Future<_FileLoadResult> _loadFile() async {
    try {
      // 首先尝试从缓存加载图片
      final cachedBytes = await ImageCacheServiceEnhanced.getCachedImage(widget.fileUrl);
      if (cachedBytes != null) {
        if (kDebugMode) {
          print('✅ 图片从缓存加载: ${widget.fileUrl}');
        }
        // 缓存命中，返回缓存的数据
        // 注意：这里假设缓存的是图片，如果不是图片会由后续的渲染逻辑处理
        return _FileLoadResult(
          bytes: cachedBytes,
          contentType: 'image/jpeg', // 假设缓存的是图片
          fromCache: true,
        );
      }

      // 缓存未命中，从网络加载
      if (kDebugMode) {
        print('🔄 图片从网络加载: ${widget.fileUrl}');
      }
      
      final apiClient = getIt<ApiClient>();
      final response = await apiClient.dio.get(
        widget.fileUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      final bytes = response.data as Uint8List;
      final contentType = response.headers.value('content-type') ?? '';

      // 如果是图片，缓存它
      if (contentType.startsWith('image/')) {
        ImageCacheServiceEnhanced.cacheImage(
          url: widget.fileUrl,
          imageBytes: bytes,
        );
      }

      return _FileLoadResult(
        bytes: bytes,
        contentType: contentType,
        fromCache: false,
      );
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('❌ 加载文件失败: ${widget.fileUrl}');
        print('错误: $e');
        print('堆栈: $stackTrace');
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须调用以保持状态
    
    return FutureBuilder<_FileLoadResult>(
      future: _loadFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(),
                ),
                SizedBox(height: 12),
                Text('Loading file...', style: TextStyle(fontSize: 14)),
              ],
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 50),
                const SizedBox(height: 8),
                const Text("Failed to load file."),
                if (snapshot.hasError)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      snapshot.error.toString(),
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          );
        }

        final result = snapshot.data!;
        return _buildImageWidget(result.bytes, result.contentType);
      },
    );
  }

  Widget _buildImageWidget(Uint8List bytes, String contentType) {

    Widget imageWidget;
    if (contentType.startsWith('image/')) {
      // 对于普通图片，异步加载固有尺寸（addPostFrameCallback 会等待它完成）
      if (_imageIntrinsicSize == null) {
        _loadImageIntrinsicSize(bytes);
      }
      
      imageWidget = FittedBox(
        key: widget.imageKey, // Move key to FittedBox to get actual rendered size
        fit: BoxFit.contain,
        alignment: Alignment.center, // 明确设置图片居中
        child: Image.memory(bytes),
      );
    } else if (contentType == 'application/pdf') {
      imageWidget = _PdfVectorRenderer(
        bytes: bytes, 
        pageId: widget.pageId,
        versionId: widget.versionId,
        imageKey: widget.imageKey,
        onImageRendered: widget.onImageRendered,
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.help_outline, size: 50),
            const SizedBox(height: 8),
            Text('Unsupported file type: $contentType'),
          ],
        ),
      );
    }

    // After the image is built, report its actual rendered size
    WidgetsBinding.instance.addPostFrameCallback((_) async {
          // 等待固有尺寸加载完成（仅针对普通图片）
          if (contentType.startsWith('image/')) {
            int retries = 0;
            while (_imageIntrinsicSize == null && retries < 20) {
              await Future.delayed(const Duration(milliseconds: 50));
              retries++;
            }
          }
          
          if (widget.imageKey.currentContext != null && 
              mounted &&
              _imageIntrinsicSize != null) {
            final renderObject = widget.imageKey.currentContext!.findRenderObject();
            if (renderObject is RenderBox && renderObject.hasSize) {
              // 计算 BoxFit.contain 下的实际渲染尺寸
              final containerSize = renderObject.size;
              final imageAspectRatio = _imageIntrinsicSize!.width / _imageIntrinsicSize!.height;
              final containerAspectRatio = containerSize.width / containerSize.height;
              
              Size actualSize;
              if (imageAspectRatio > containerAspectRatio) {
                // 图片更宽，以宽度为准
                final width = containerSize.width;
                final height = width / imageAspectRatio;
                actualSize = Size(width, height);
              } else {
                // 图片更高，以高度为准
                final height = containerSize.height;
                final width = height * imageAspectRatio;
                actualSize = Size(width, height);
              }
              
              // 更新内部状态和通知父组件
              if (mounted) {
                setState(() {
                  _calculatedRenderSize = actualSize;
                });
              }
              
              if (widget.onImageRendered != null) {
                widget.onImageRendered!(actualSize);
              }
            }
          }
        });

        // 如果有OCR结果，将图片和OCR叠加层包装在Stack中
        if (widget.ocrResult != null) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final containerSize = Size(constraints.maxWidth, constraints.maxHeight);
              
              // 使用计算好的渲染尺寸，如果还没计算出来则使用容器尺寸作为临时值
              final renderSize = _calculatedRenderSize ?? containerSize;
              
              return Stack(
                alignment: Alignment.center, // 确保内容居中
                children: [
                  imageWidget,
                  // OCR 叠加层（始终显示）
                  SizedBox(
                    width: containerSize.width,
                    height: containerSize.height,
                    child: Stack(
                      children: [
                          if (widget.highlightedBboxes.isNotEmpty)
                            Positioned.fill(
                              child: HighlightOverlayWithFittedBox(
                                bboxes: widget.highlightedBboxes,
                                imageWidth: widget.ocrResult!.imageWidth,
                                imageHeight: widget.ocrResult!.imageHeight,
                                renderedImageWidth: renderSize.width,
                                renderedImageHeight: renderSize.height,
                                containerSize: containerSize,
                              ),
                            ),
                        Positioned.fill(
                          child: OcrTextOverlayWithFittedBox(
                            ocrResult: widget.ocrResult!,
                            renderedImageWidth: renderSize.width,
                            renderedImageHeight: renderSize.height,
                            containerSize: containerSize,
                            searchQuery: widget.searchQuery.isNotEmpty ? widget.searchQuery : null,
                            showDebugBorders: widget.showDebugBorders,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        }

        return imageWidget; // Return just the image widget
  }
}

// A widget that renders a PDF using the configured backend
// Supports multiple rendering engines:
// - PDF.js: Vector rendering with text selection (WebView-based)
// - pdfx: High-quality raster rendering at 4x resolution (Native)
class _PdfVectorRenderer extends StatefulWidget {
  final Uint8List bytes;
  final String pageId;
  final String versionId;
  final GlobalKey imageKey;
  final Function(Size)? onImageRendered;
  
  const _PdfVectorRenderer({
    required this.bytes,
    required this.pageId,
    required this.versionId,
    required this.imageKey,
    this.onImageRendered,
  });

  @override
  State<_PdfVectorRenderer> createState() => _PdfVectorRendererState();
}

class _PdfVectorRendererState extends State<_PdfVectorRenderer> {
  InAppWebViewController? _webViewController;
  bool _isLoading = true;
  String? _errorMessage;
  PdfRenderBackend? _currentBackend;

  @override
  void initState() {
    super.initState();
    _loadBackendConfig();
  }

  Future<void> _loadBackendConfig() async {
    final backend = await PdfRenderBackendService.getBackend();
    if (mounted) {
      setState(() {
        _currentBackend = backend;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 如果还没加载配置，显示加载中
    if (_currentBackend == null) {
      return const Center(child: CircularProgressIndicator());
    }
    
    // 根据配置选择渲染器
    switch (_currentBackend!) {
      case PdfRenderBackend.pdfx:
        return _buildPdfxRenderer();
      case PdfRenderBackend.pdfrx:
        return _buildPdfrxRenderer();
      case PdfRenderBackend.pdfjs:
        return _buildPdfjsRenderer();
    }
  }
  
  Widget _buildPdfxRenderer() {
    return Column(
      children: [
        Expanded(
          child: PdfxRenderer(
            pdfBytes: widget.bytes,
            pageId: widget.pageId,
            versionId: widget.versionId,
            imageKey: widget.imageKey,
            onImageRendered: widget.onImageRendered,
          ),
        ),
        _buildBackendSwitcher(),
      ],
    );
  }
  
  Widget _buildPdfrxRenderer() {
    return Column(
      children: [
        Expanded(
          child: PdfrxRenderer(
            pdfBytes: widget.bytes,
            pageId: widget.pageId,
            versionId: widget.versionId,
            imageKey: widget.imageKey,
            onImageRendered: widget.onImageRendered,
          ),
        ),
        _buildBackendSwitcher(),
      ],
    );
  }
  
  Widget _buildPdfjsRenderer() {
    if (_errorMessage != null) {
      return Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 50, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _errorMessage = null;
                        _isLoading = true;
                      });
                    },
                    child: const Text('重试'),
                  ),
                ],
              ),
            ),
          ),
          _buildBackendSwitcher(),
        ],
      );
    }

    // 使用InAppWebView + PDF.js渲染PDF
    // 这是真正的矢量渲染，支持文本选择、复制和搜索
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              InAppWebView(
                initialData: InAppWebViewInitialData(
                  data: _generatePdfViewerHtml(),
                  baseUrl: WebUri('about:blank'),
                  encoding: 'utf-8',
                  mimeType: 'text/html',
                ),
                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,
                  useHybridComposition: true,
                  allowFileAccessFromFileURLs: true,
                  allowUniversalAccessFromFileURLs: true,
                  supportZoom: true,
                  builtInZoomControls: true,
                  displayZoomControls: false,
                  transparentBackground: true,
                  // 启用文本选择
                  disableLongPressContextMenuOnLinks: false,
                  // 允许复制
                  allowsLinkPreview: true,
                ),
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                  // 将PDF数据传递给WebView
                  _loadPdfData();
                },
                onLoadStop: (controller, url) {
                  if (mounted) {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
                onReceivedError: (controller, request, error) {
                  if (kDebugMode) {
                    print('PDF WebView load error: ${error.description}');
                  }
                  if (mounted) {
                    setState(() {
                      _errorMessage = 'PDF加载失败: ${error.description}';
                      _isLoading = false;
                    });
                  }
                },
                onConsoleMessage: (controller, consoleMessage) {
                  if (kDebugMode) {
                    print('PDF.js: ${consoleMessage.message}');
                  }
                },
              ),
              if (_isLoading)
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(),
                        ),
                        SizedBox(height: 12),
                        Text('Loading PDF...', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        _buildBackendSwitcher(),
      ],
    );
  }
  
  Widget _buildBackendSwitcher() {
    IconData backendIcon;
    switch (_currentBackend!) {
      case PdfRenderBackend.pdfx:
        backendIcon = Icons.high_quality;
        break;
      case PdfRenderBackend.pdfrx:
        backendIcon = Icons.touch_app;
        break;
      case PdfRenderBackend.pdfjs:
        backendIcon = Icons.text_fields;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            backendIcon,
            size: 20,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              PdfRenderBackendService.getBackendDisplayName(_currentBackend!),
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
          ),
          TextButton.icon(
            onPressed: _switchBackend,
            icon: const Icon(Icons.swap_horiz, size: 18),
            label: const Text('切换', style: TextStyle(fontSize: 12)),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> _switchBackend() async {
    // 循环切换后端: pdfjs -> pdfx -> pdfrx -> pdfjs
    PdfRenderBackend newBackend;
    switch (_currentBackend!) {
      case PdfRenderBackend.pdfjs:
        newBackend = PdfRenderBackend.pdfx;
        break;
      case PdfRenderBackend.pdfx:
        newBackend = PdfRenderBackend.pdfrx;
        break;
      case PdfRenderBackend.pdfrx:
        newBackend = PdfRenderBackend.pdfjs;
        break;
    }
    
    await PdfRenderBackendService.setBackend(newBackend);
    
    if (mounted) {
      setState(() {
        _currentBackend = newBackend;
        _isLoading = true;
        _errorMessage = null;
      });
      
      // 显示提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '已切换到 ${PdfRenderBackendService.getBackendDisplayName(newBackend)}',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _loadPdfData() async {
    if (_webViewController == null) return;
    
    try {
      // 将PDF字节数据转换为Base64
      final base64Data = base64Encode(widget.bytes);
      
      // 通过JavaScript将PDF数据传递给PDF.js
      await _webViewController!.evaluateJavascript(source: '''
        loadPdfFromBase64('$base64Data');
      ''');
    } catch (e) {
      if (kDebugMode) {
        print('Error loading PDF data: $e');
      }
      if (mounted) {
        setState(() {
          _errorMessage = 'PDF数据加载失败: $e';
        });
      }
    }
  }

  String _generatePdfViewerHtml() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? '#1e1e1e' : '#ffffff';
    
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes">
  <title>PDF Viewer</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    html, body {
      width: 100%;
      height: 100%;
      overflow: hidden;
      background-color: $backgroundColor;
    }
    #pdfContainer {
      width: 100%;
      height: 100%;
      overflow: auto;
      display: flex;
      flex-direction: column;
      align-items: center;
      padding: 16px;
    }
    .pdfPage {
      margin-bottom: 16px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    #loadingIndicator {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      color: ${isDarkMode ? '#ffffff' : '#000000'};
      font-family: sans-serif;
      font-size: 14px;
    }
  </style>
</head>
<body>
  <div id="loadingIndicator">Loading PDF.js...</div>
  <div id="pdfContainer"></div>
  
  <!-- 使用PDF.js的CDN版本 -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.min.js" 
    onerror="handleScriptError('PDF.js main library')"></script>
  <script>
    function handleScriptError(scriptName) {
      const indicator = document.getElementById('loadingIndicator');
      indicator.textContent = 'Failed to load ' + scriptName + '. Please check your internet connection.';
      indicator.style.color = 'red';
      console.error('Script load error:', scriptName);
    }
    
    // 配置PDF.js的worker
    if (typeof pdfjsLib !== 'undefined') {
      pdfjsLib.GlobalWorkerOptions.workerSrc = 'https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.worker.min.js';
    } else {
      console.error('PDF.js library not loaded');
      document.getElementById('loadingIndicator').textContent = 'PDF.js library failed to load. Please check your internet connection.';
      document.getElementById('loadingIndicator').style.color = 'red';
    }
    
    let pdfDoc = null;
    
    async function loadPdfFromBase64(base64Data) {
      try {
        // 检查 PDF.js 是否已加载
        if (typeof pdfjsLib === 'undefined') {
          throw new Error('PDF.js library not loaded. Please check your internet connection.');
        }
        
        document.getElementById('loadingIndicator').textContent = 'Loading PDF...';
        
        // 将Base64转换为Uint8Array
        const binaryString = atob(base64Data);
        const bytes = new Uint8Array(binaryString.length);
        for (let i = 0; i < binaryString.length; i++) {
          bytes[i] = binaryString.charCodeAt(i);
        }
        
        // 加载PDF文档
        const loadingTask = pdfjsLib.getDocument({ data: bytes });
        pdfDoc = await loadingTask.promise;
        
        document.getElementById('loadingIndicator').style.display = 'none';
        
        // 渲染所有页面
        await renderAllPages();
      } catch (error) {
        console.error('Error loading PDF:', error);
        const indicator = document.getElementById('loadingIndicator');
        indicator.textContent = 'Error loading PDF: ' + error.message;
        indicator.style.color = 'red';
      }
    }
    
    async function renderAllPages() {
      const container = document.getElementById('pdfContainer');
      container.innerHTML = '';
      
      for (let pageNum = 1; pageNum <= pdfDoc.numPages; pageNum++) {
        await renderPage(pageNum, container);
      }
    }
    
    async function renderPage(pageNum, container) {
      try {
        const page = await pdfDoc.getPage(pageNum);
        
        // 创建canvas容器
        const pageDiv = document.createElement('div');
        pageDiv.className = 'pdfPage';
        
        // 设置合适的缩放比例
        const viewport = page.getViewport({ scale: 1.5 });
        
        // 创建canvas用于渲染PDF
        const canvas = document.createElement('canvas');
        const context = canvas.getContext('2d');
        canvas.width = viewport.width;
        canvas.height = viewport.height;
        
        // 创建文本层容器（用于文本选择）
        const textLayerDiv = document.createElement('div');
        textLayerDiv.style.position = 'absolute';
        textLayerDiv.style.left = '0';
        textLayerDiv.style.top = '0';
        textLayerDiv.style.right = '0';
        textLayerDiv.style.bottom = '0';
        textLayerDiv.style.overflow = 'hidden';
        textLayerDiv.style.lineHeight = '1.0';
        
        const pageContainer = document.createElement('div');
        pageContainer.style.position = 'relative';
        pageContainer.style.width = viewport.width + 'px';
        pageContainer.style.height = viewport.height + 'px';
        
        pageContainer.appendChild(canvas);
        pageContainer.appendChild(textLayerDiv);
        pageDiv.appendChild(pageContainer);
        container.appendChild(pageDiv);
        
        // 渲染PDF页面到canvas
        await page.render({
          canvasContext: context,
          viewport: viewport
        }).promise;
        
        // 渲染文本层以支持文本选择
        const textContent = await page.getTextContent();
        pdfjsLib.renderTextLayer({
          textContentSource: textContent,
          container: textLayerDiv,
          viewport: viewport,
          textDivs: []
        });
        
      } catch (error) {
        console.error('Error rendering page ' + pageNum + ':', error);
      }
    }
    
    // 全局函数，供Flutter调用
    window.loadPdfFromBase64 = loadPdfFromBase64;
  </script>
</body>
</html>
    ''';
  }
}

/// 全屏模式下的进度条
/// 显示图形化进度条和页码信息
class _FullscreenProgressBar extends StatefulWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onTap;

  const _FullscreenProgressBar({
    required this.currentPage,
    required this.totalPages,
    required this.onTap,
  });

  @override
  State<_FullscreenProgressBar> createState() => _FullscreenProgressBarState();
}

class _FullscreenProgressBarState extends State<_FullscreenProgressBar> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final progress = widget.currentPage / widget.totalPages;
    final percentage = (progress * 100).toInt();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: ClipRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: _isPressed ? 14 : 16,
            ),
            decoration: BoxDecoration(
              color: isDark 
                  ? Colors.black.withValues(alpha: 0.6)
                  : Colors.white.withValues(alpha: 0.7),
              border: Border(
                top: BorderSide(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.1),
                  width: 0.5,
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  // 图形化进度条
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 进度条容器
                        Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.15)
                                : Colors.black.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Stack(
                            children: [
                              // 已完成进度
                              FractionallySizedBox(
                                widthFactor: progress,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: isDark
                                          ? [
                                              Colors.blue.shade400,
                                              Colors.blue.shade300,
                                            ]
                                          : [
                                              Colors.blue.shade600,
                                              Colors.blue.shade500,
                                            ],
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.withValues(alpha: 0.3),
                                        blurRadius: 4,
                                        spreadRadius: 0.5,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // 页码
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.12)
                          : Colors.black.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.2)
                            : Colors.black.withValues(alpha: 0.15),
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      '${widget.currentPage}/${widget.totalPages}',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                        color: isDark ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // 百分比
                  SizedBox(
                    width: 42,
                    child: Text(
                      '$percentage%',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: isDark 
                            ? Colors.white.withValues(alpha: 0.7)
                            : Colors.black.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
