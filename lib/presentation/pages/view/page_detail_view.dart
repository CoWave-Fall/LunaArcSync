import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luna_arc_sync/core/di/injection.dart';
import 'package:luna_arc_sync/data/models/job_models.dart';
import 'package:luna_arc_sync/l10n/app_localizations.dart';
import 'package:luna_arc_sync/presentation/pages/view/version_history_page.dart';
import 'package:luna_arc_sync/core/theme/background_image_notifier.dart';
import 'package:luna_arc_sync/core/theme/fullscreen_notifier.dart';
import 'package:luna_arc_sync/core/services/page_preload_service.dart';
import 'package:luna_arc_sync/data/repositories/document_repository.dart';
import 'package:luna_arc_sync/data/repositories/page_repository.dart';
import 'package:luna_arc_sync/core/theme/page_navigation_notifier.dart';
import 'package:luna_arc_sync/core/cache/pdf_preload_manager.dart';
import 'package:luna_arc_sync/presentation/pages/view/widgets/page_content_widget.dart';
import 'package:luna_arc_sync/presentation/pages/view/widgets/fullscreen_progress_bar.dart';

class PagesDetailView extends StatefulWidget {
  final String pageId;
  final List<String>? pageIds; // 页面ID列表，用于前后导航
  final int? currentIndex; // 当前页面在列表中的索引
  final int? totalPageCount; // 文档的总页面数
  final String? documentId; // 文档ID，用于获取更多页面

  const PagesDetailView({
    required this.pageId,
    super.key,
    this.pageIds,
    this.currentIndex,
    this.totalPageCount,
    this.documentId,
  });

  @override
  State<PagesDetailView> createState() => _PagesDetailViewState();
}

class _PagesDetailViewState extends State<PagesDetailView> {
  late final PageController _pageController;
  late int _currentPageIndex;
  final FocusNode _focusNode = FocusNode(); // 用于键盘事件监听
  final Map<String, GlobalKey<PageContentWidgetState>> _pageKeys = {};
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
      _pageKeys[pageId] = GlobalKey<PageContentWidgetState>();
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
      final totalPages = _currentTotalPages > 0
          ? _currentTotalPages
          : _currentPageIds.length;

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
        if (kDebugMode) {
          debugPrint('开始预加载 ${preloadPages.length} 个页面');
        }
      }

      // 为每个页面获取版本ID并预加载
      final futures = <Future<void>>[];
      for (final pageId in preloadPages) {
        futures.add(_preloadSinglePage(pageId));
      }

      // 并行执行预加载，但不等待所有完成
      Future.wait(futures).catchError((Object e) {
        if (kDebugMode) {
          if (kDebugMode) {
            debugPrint('批量预加载出现错误: $e');
          }
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
            if (kDebugMode) {
              debugPrint('页面 $pageId 没有当前版本，跳过预加载');
            }
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
        if (kDebugMode) {
          debugPrint('预加载页面 $pageId 失败: $e');
        }
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
    const preloadRange = 2;

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
      PdfPreloadManager()
          .preloadAdjacentPages(
            adjacentPageIds: adjacentPageIds,
            adjacentVersionIds: adjacentVersionIds,
            isDarkMode: isDarkMode,
          )
          .catchError((Object e) {
            if (kDebugMode) {
              if (kDebugMode) {
                debugPrint('预加载相邻页面到内存失败: $e');
              }
            }
          });
    }
  }

  /// 动态加载更多页面
  Future<void> _loadMorePages() async {
    if (_currentPageIds.length >= _currentTotalPages ||
        widget.documentId == null) {
      return;
    }

    try {
      if (kDebugMode) {
        if (kDebugMode) {
          debugPrint(
            '开始加载更多页面，当前页数: ${_currentPageIds.length}, 总页数: $_currentTotalPages',
          );
        }
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
            _pageKeys[pageId] = GlobalKey<PageContentWidgetState>();
          }
        });

        if (kDebugMode) {
          if (kDebugMode) {
            debugPrint('成功加载 ${newPageIds.length} 个新页面');
          }
        }

        // 预加载新加载的页面
        await _startPreloading();
      }
    } catch (e) {
      if (kDebugMode) {
        if (kDebugMode) {
          debugPrint('加载更多页面失败: $e');
        }
      }
    }
  }

  // 获取当前页面ID
  String get _currentPageId {
    if (_currentPageIds.isNotEmpty &&
        _currentPageIndex < _currentPageIds.length) {
      return _currentPageIds[_currentPageIndex];
    }
    return widget.pageId;
  }

  // 获取当前页面的State
  PageContentWidgetState? get _currentPageState {
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
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
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
    final hasCustomBackground = context
        .watch<BackgroundImageNotifier>()
        .hasCustomBackground;
    final currentPageState = _currentPageState;

    // 如果还没有初始化完成，显示加载状态
    if (!_isInitialized) {
      return Scaffold(
        backgroundColor: hasCustomBackground ? Colors.transparent : null,
        appBar: AppBar(
          backgroundColor: hasCustomBackground ? Colors.transparent : null,
          title: const Text('Loading...'),
        ),
        body: const Center(child: CircularProgressIndicator()),
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
        appBar: _isFullscreen
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: AppBar(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.surface.withValues(alpha: 0.7),
                      elevation: 0,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          // 如果处于全屏状态，先退出全屏
                          if (_isFullscreen) {
                            context.read<FullscreenNotifier>().setFullscreen(
                              false,
                            );
                            SystemChrome.setEnabledSystemUIMode(
                              SystemUiMode.edgeToEdge,
                            );
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                      title: ValueListenableBuilder(
                        valueListenable:
                            currentPageState?.stateNotifier ??
                            ValueNotifier<int>(0),
                        builder: (context, value, child) {
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              // 上移动画：旧的上移渐出，新的上移渐入
                              final offsetAnimation =
                                  Tween<Offset>(
                                    begin: const Offset(0, 0.3),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeOutCubic,
                                    ),
                                  );

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
                                      hintStyle: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.7,
                                        ),
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
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
                          valueListenable:
                              currentPageState?.stateNotifier ??
                              ValueNotifier<int>(0),
                          builder: (context, value, child) {
                            final hasOcrResult =
                                currentPageState?.hasOcrResult ?? false;
                            if (hasOcrResult) {
                              return IconButton(
                                icon: Icon(
                                  _isSearchVisible ? Icons.close : Icons.search,
                                ),
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
                            valueListenable:
                                currentPageState?.stateNotifier ??
                                ValueNotifier<int>(0),
                            builder: (context, value, child) {
                              final showDebugBorders =
                                  currentPageState?.showDebugBorders ?? false;
                              return IconButton(
                                icon: Icon(
                                  showDebugBorders
                                      ? Icons.bug_report
                                      : Icons.bug_report_outlined,
                                ),
                                tooltip: showDebugBorders
                                    ? 'Hide debug borders'
                                    : 'Show debug borders',
                                onPressed: () {
                                  currentPageState?.toggleDebugBorders();
                                },
                              );
                            },
                          ),
                        // 历史版本按钮
                        IconButton(
                          icon: const Icon(Icons.history),
                          tooltip:
                              AppLocalizations.of(
                                context,
                              )?.viewVersionHistory ??
                              'View version history',
                          onPressed: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => VersionHistoryPage(
                                  pageId: _currentPageId,
                                  currentVersionId:
                                      currentPageState?.currentVersionId,
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
                          valueListenable:
                              currentPageState?.stateNotifier ??
                              ValueNotifier<int>(0),
                          builder: (context, value, child) {
                            final ocrStatus = currentPageState?.ocrStatus;
                            if (ocrStatus == JobStatusEnum.Processing) {
                              return Padding(
                                padding: const EdgeInsets.all(12),
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
                                icon: const Icon(
                                  Icons.document_scanner_outlined,
                                ),
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

                if (tapX > centerLeft &&
                    tapX < centerRight &&
                    tapY > centerTop &&
                    tapY < centerBottom) {
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
                        return PageContentWidget(
                          key:
                              _pageKeys[pageId] ??
                              GlobalKey<PageContentWidgetState>(),
                          pageId: pageId,
                        );
                      },
                    )
                  : PageContentWidget(
                      key:
                          _pageKeys[widget.pageId] ??
                          GlobalKey<PageContentWidgetState>(),
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
                child: FullscreenProgressBar(
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
