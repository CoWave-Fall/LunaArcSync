import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luna_arc_sync/core/di/injection.dart';
import 'package:luna_arc_sync/core/services/smart_pdf_preloader.dart';
import 'package:luna_arc_sync/data/repositories/page_repository.dart';
import 'package:luna_arc_sync/presentation/pages/cubit/page_detail_cubit.dart';
import 'package:luna_arc_sync/presentation/settings/notifiers/precaching_settings_notifier.dart';
import 'package:luna_arc_sync/presentation/pages/cubit/page_detail_state.dart';
import 'package:luna_arc_sync/presentation/pages/view/version_history_page.dart';
import 'package:luna_arc_sync/presentation/pages/view/widgets/file_viewer_widget.dart';

/// 使用PageView的页面详情容器
/// 支持滑动切换和页面缓存
class PagesSwipeView extends StatefulWidget {
  final String pageId;
  final List<String> pageIds;
  final int currentIndex;

  const PagesSwipeView({
    required this.pageId,
    required this.pageIds,
    required this.currentIndex,
    super.key,
  });

  @override
  State<PagesSwipeView> createState() => _PagesSwipeViewState();
}

class _PagesSwipeViewState extends State<PagesSwipeView> {
  late PageController _pageController;
  late SmartPdfPreloader _smartPreloader;
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.currentIndex);
    
    // 初始化智能预加载器
    _smartPreloader = SmartPdfPreloader();
    
    // 从设置中获取预加载数量
    _loadPreloadSettings();
    
    // 开始预加载
    _startSmartPreloading();
  }
  
  /// 从设置中加载预加载配置
  Future<void> _loadPreloadSettings() async {
    // 获取预加载设置（这里需要使用 Provider 或者类似的机制）
    // 暂时使用默认值
    final precachingNotifier = PrecachingSettingsNotifier();
    await precachingNotifier.loadSettings();
    
    _smartPreloader.setPreloadCount(precachingNotifier.precachingRange);
  }
  
  /// 开始智能预加载
  Future<void> _startSmartPreloading() async {
    if (widget.pageIds.isEmpty) return;
    
    final pageRepository = getIt<IPageRepository>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // 智能预加载相邻页面
    await _smartPreloader.preloadPages(
      currentPageIndex: widget.currentIndex,
      pageIds: widget.pageIds,
      pageRepository: pageRepository,
      isDarkMode: isDarkMode,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.pageIds.length,
      itemBuilder: (context, index) {
        return _SinglePageDetailView(
          key: ValueKey(widget.pageIds[index]),
          pageId: widget.pageIds[index],
          pageIds: widget.pageIds,
          currentIndex: index,
          totalPages: widget.pageIds.length,
        );
      },
    );
  }
}

/// 单个页面的详情视图
/// 使用AutomaticKeepAliveClientMixin保持状态
class _SinglePageDetailView extends StatefulWidget {
  final String pageId;
  final List<String> pageIds;
  final int currentIndex;
  final int totalPages;

  const _SinglePageDetailView({
    required this.pageId,
    required this.pageIds,
    required this.currentIndex,
    required this.totalPages,
    super.key,
  });

  @override
  State<_SinglePageDetailView> createState() => _SinglePageDetailViewState();
}

class _SinglePageDetailViewState extends State<_SinglePageDetailView>
    with AutomaticKeepAliveClientMixin {
  bool _isSearchVisible = false;
  final _searchController = TextEditingController();
  late final GlobalKey _imageKey;
  Size? _renderedImageSize;
  bool _showDebugBorders = false;
  final FocusNode _focusNode = FocusNode();

  @override
  bool get wantKeepAlive => true; // 保持页面状态

  @override
  void initState() {
    super.initState();
    _imageKey = GlobalKey(debugLabel: 'page_image_${widget.pageId}');
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须调用以保持状态

    return BlocProvider(
      create: (context) => getIt<PageDetailCubit>()..fetchPage(widget.pageId),
      child: Builder(
        builder: (context) {
          return BlocConsumer<PageDetailCubit, PageDetailState>(
            listener: (context, state) {
              // 可以在这里添加状态变化的监听逻辑
            },
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    '${widget.currentIndex + 1} / ${widget.totalPages}',
                  ),
                  actions: [
                    if (!_isSearchVisible)
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            _isSearchVisible = true;
                          });
                        },
                      ),
                    if (_isSearchVisible)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: TextField(
                            controller: _searchController,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: 'Search',
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    _isSearchVisible = false;
                                    _searchController.clear();
                                  });
                                  context.read<PageDetailCubit>().search('');
                                },
                              ),
                            ),
                            onChanged: (query) {
                              context.read<PageDetailCubit>().search(query);
                            },
                          ),
                        ),
                      ),
                    if (!_isSearchVisible)
                      IconButton(
                        icon: const Icon(Icons.history),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) =>
                                  VersionHistoryPage(pageId: widget.pageId),
                            ),
                          );
                        },
                      ),
                    if (!_isSearchVisible)
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'debug') {
                            setState(() {
                              _showDebugBorders = !_showDebugBorders;
                            });
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'debug',
                            child: Row(
                              children: [
                                Icon(
                                  _showDebugBorders
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                ),
                                const SizedBox(width: 8),
                                const Text('Debug Borders'),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                body: state.when(
                  initial: () => const SizedBox.shrink(),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  failure: (message) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(message),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => context
                              .read<PageDetailCubit>()
                              .fetchPage(widget.pageId),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                  success:
                      (page, ocrStatus, _, searchQuery, highlightedBboxes) {
                        if (page.currentVersion == null) {
                          return const Center(
                            child: Text('This page has no content yet.'),
                          );
                        }
                        final versionId = page.currentVersion!.versionId;
                        final fileUrl = '/api/images/$versionId';
                        final ocrResult = page.currentVersion!.ocrResult;

                        return Column(
                          children: [
                            Expanded(
                              child: InteractiveViewer(
                                maxScale: 5,
                                child: SizedBox.expand(
                                  child: FileViewerWidget(
                                    fileUrl: fileUrl,
                                    pageId: widget.pageId,
                                    versionId: versionId,
                                    imageKey: _imageKey,
                                    onImageRendered: (Size size) {
                                      if (_renderedImageSize != size) {
                                        setState(() {
                                          _renderedImageSize = size;
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
