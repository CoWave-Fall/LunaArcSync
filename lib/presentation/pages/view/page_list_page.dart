import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:luna_arc_sync/core/di/injection.dart';
import 'package:luna_arc_sync/presentation/pages/cubit/page_list_cubit.dart';
import 'package:luna_arc_sync/presentation/pages/cubit/page_list_state.dart';
import 'package:luna_arc_sync/presentation/pages/view/page_detail_page_with_pageview.dart';
import 'package:luna_arc_sync/presentation/pages/widgets/page_list_item.dart';
import 'package:luna_arc_sync/core/theme/background_image_notifier.dart';
import 'package:luna_arc_sync/presentation/widgets/optimized_glassmorphic_list.dart';
import 'package:luna_arc_sync/core/config/glassmorphic_presets.dart';

// PageListPage 现在是一个更简单的容器，只负责提供 Bloc
class PageListPage extends StatelessWidget {
  const PageListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PageListCubit>()..fetchPages(),
      // Scaffold 现在由 PageListView 自己管理
      child: const PageListView(),
    );
  }
}

// PageListView 包含了所有的 UI 和交互逻辑
class PageListView extends StatefulWidget {
  const PageListView({super.key});

  @override
  State<PageListView> createState() => _PageListViewState();
}

class _PageListViewState extends State<PageListView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 不再需要滚动监听，因为我们直接获取所有数据
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // 创建页面的对话框逻辑
  void _showCreatePageDialog(BuildContext context) {
    final pageListCubit = context.read<PageListCubit>();
    
    final titleController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    PlatformFile? selectedFile;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: pageListCubit,
          child: StatefulBuilder(
            builder: (stfContext, setState) {
              bool isLoading = false;
              
              return AlertDialog(
                title: const Text('Create New Page'),
                content: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: 'Page Title'),
                        validator: (value) =>
                            value!.isEmpty ? 'Title cannot be empty' : null,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              final result = await FilePicker.platform.pickFiles(
                                type: FileType.image,
                                withData: true, // 确保获取文件字节
                              );
                              if (result != null && result.files.single.bytes != null) {
                                setState(() {
                                  selectedFile = result.files.single;
                                });
                              }
                            },
                            child: const Text('Select Image'),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Text(selectedFile?.name ?? 'No file selected',
                                  overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(stfContext).pop(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                            if (formKey.currentState!.validate() && selectedFile != null) {
                              setState(() => isLoading = true);
                              try {
                                await stfContext.read<PageListCubit>().createPage(
                                      title: titleController.text,
                                      fileBytes: selectedFile!.bytes!,
                                      fileName: selectedFile!.name,
                                    );
                                if (stfContext.mounted) Navigator.of(stfContext).pop();
                              } catch (e) {
                                if (stfContext.mounted) {
                                  ScaffoldMessenger.of(stfContext).showSnackBar(
                                    SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
                                  );
                                }
                              } finally {
                                if (stfContext.mounted) {
                                  setState(() => isLoading = false);
                                }
                              }
                            } else if (selectedFile == null) {
                              ScaffoldMessenger.of(stfContext).showSnackBar(
                                const SnackBar(content: Text("Please select an image file."), backgroundColor: Colors.orange),
                              );
                            }
                          },
                    child: isLoading
                        // ignore: dead_code
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Create'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<PageListCubit, PageListState>(
        listener: (context, state) {
          if (state.status == PageListStatus.success && state.errorMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (context, state) {
          switch (state.status) {
            case PageListStatus.initial:
            case PageListStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case PageListStatus.failure:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.errorMessage ?? 'Failed to load pages.'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => context.read<PageListCubit>().fetchPages(),
                      child: const Text('Retry'),
                    )
                  ],
                ),
              );

            case PageListStatus.success:
            case PageListStatus.loadingMore:
              if (state.pages.isEmpty) {
                return const Center(child: Text('No pages found. Add one!'));
              }
              
              // 检查是否有自定义背景
              final hasCustomBackground = context.watch<BackgroundImageNotifier>().hasCustomBackground;
              
              return RefreshIndicator(
                onRefresh: () => context.read<PageListCubit>().fetchPages(),
                child: hasCustomBackground
                    // 使用优化的毛玻璃列表（共享渲染）
                    ? OptimizedGlassmorphicListBuilder(
                        blurGroup: 'page_list',
                        blur: GlassmorphicPresets.pageListBlur,
                        opacity: GlassmorphicPresets.pageListOpacity,
                        controller: _scrollController,
                        itemCount: state.pages.length,
                        itemBuilder: (context, index) {
                          final page = state.pages[index];
                          return PageListItem(
                            page: page,
                            onTap: () {
                              // 提取所有页面ID
                              final pageIds = state.pages.map((p) => p.pageId).toList();
                              Navigator.of(context).push<bool>( // 接收返回值
                                MaterialPageRoute(
                                  builder: (_) => PageDetailPageWithPageView(
                                    pageId: page.pageId,
                                    pageIds: pageIds,
                                    currentIndex: index,
                                  ),
                                ),
                              ).then((result) {
                                 // 从详情页返回后，无论是否有变动，都刷新一下列表
                                 // 这是一个简单而可靠的策略
                                 if (mounted) {
                                   // ignore: use_build_context_synchronously
                                   context.read<PageListCubit>().fetchPages();
                                 }
                              });
                            },
                          );
                        },
                      )
                    // 普通列表（无背景时）
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: state.pages.length,
                        itemBuilder: (context, index) {
                          final page = state.pages[index];
                          return PageListItem(
                            page: page,
                            onTap: () {
                              // 提取所有页面ID
                              final pageIds = state.pages.map((p) => p.pageId).toList();
                              Navigator.of(context).push<bool>( // 接收返回值
                                MaterialPageRoute(
                                  builder: (_) => PageDetailPageWithPageView(
                                    pageId: page.pageId,
                                    pageIds: pageIds,
                                    currentIndex: index,
                                  ),
                                ),
                              ).then((result) {
                                 // 从详情页返回后，无论是否有变动，都刷新一下列表
                                 // 这是一个简单而可靠的策略
                                 if (mounted) {
                                   // ignore: use_build_context_synchronously
                                   context.read<PageListCubit>().fetchPages();
                                 }
                              });
                            },
                          );
                        },
                      ),
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePageDialog(context),
        tooltip: 'Create a new page',
        child: const Icon(Icons.add),
      ),
    );
  }
}