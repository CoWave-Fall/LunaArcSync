import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luna_arc_sync/core/di/injection.dart';
import 'package:luna_arc_sync/presentation/pages/cubit/page_detail_cubit.dart';
import 'package:luna_arc_sync/presentation/pages/cubit/page_detail_state.dart';
import 'package:luna_arc_sync/presentation/pages/view/version_history_Page.dart';
import 'package:luna_arc_sync/presentation/pages/view/page_detail_page.dart' show FileViewer;

/// 使用PageView的页面详情容器
/// 支持滑动切换和页面缓存
class PageDetailPageWithPageView extends StatefulWidget {
  final String pageId;
  final List<String> pageIds;
  final int currentIndex;
  
  const PageDetailPageWithPageView({
    super.key,
    required this.pageId,
    required this.pageIds,
    required this.currentIndex,
  });

  @override
  State<PageDetailPageWithPageView> createState() => _PageDetailPageWithPageViewState();
}

class _PageDetailPageWithPageViewState extends State<PageDetailPageWithPageView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.currentIndex);
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
    super.key,
    required this.pageId,
    required this.pageIds,
    required this.currentIndex,
    required this.totalPages,
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
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                  context
                                      .read<PageDetailCubit>()
                                      .search('');
                                },
                              ),
                            ),
                            onChanged: (query) {
                              context
                                  .read<PageDetailCubit>()
                                  .search(query);
                            },
                          ),
                        ),
                      ),
                    if (!_isSearchVisible)
                      IconButton(
                        icon: const Icon(Icons.history),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => VersionHistoryPage(
                                pageId: widget.pageId,
                              ),
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
                  success: (page, ocrStatus, _, searchQuery, highlightedBboxes) {
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
                            maxScale: 5.0,
                            child: SizedBox.expand(
                              child: FileViewer(
                                fileUrl: fileUrl,
                                pageId: widget.pageId,
                                versionId: versionId,
                                imageKey: _imageKey,
                                onImageRendered: (size) {
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

