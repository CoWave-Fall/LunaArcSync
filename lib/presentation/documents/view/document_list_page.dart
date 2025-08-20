import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luna_arc_sync/core/di/injection.dart';
import 'package:luna_arc_sync/data/models/document_models.dart';
import 'package:luna_arc_sync/presentation/documents/cubit/document_list_cubit.dart';
import 'package:luna_arc_sync/presentation/documents/cubit/document_list_state.dart';
import 'package:luna_arc_sync/presentation/documents/view/document_detail_page.dart';
import 'package:luna_arc_sync/presentation/documents/widgets/document_list_item.dart';

class DocumentListPage extends StatelessWidget {
  const DocumentListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DocumentListCubit>()..fetchDocuments(),
      child: const DocumentListView(),
    );
  }
}

class DocumentListView extends StatefulWidget {
  const DocumentListView({super.key});

  @override
  State<DocumentListView> createState() => _DocumentListViewState();
}

class _DocumentListViewState extends State<DocumentListView> {
  final _scrollController = ScrollController();
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController..removeListener(_onScroll)..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<DocumentListCubit>().fetchNextPage();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _showCreateDocumentDialog(BuildContext context) {
    final titleController = TextEditingController();
    final tagsController = TextEditingController(); // <--- 新增 Controller
    final cubit = context.read<DocumentListCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Create New Document'),
          content: Column( // <--- 改为 Column 以容纳多个输入框
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Document Title'),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              TextField( // <--- 新增标签输入框
                controller: tagsController,
                decoration: const InputDecoration(
                  labelText: 'Tags',
                  hintText: 'e.g., work, important, draft',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty) {
                  // 将标签字符串按逗号或空格分割，并去除首尾空格
                  final tags = tagsController.text
                      .split(RegExp(r'[, ]+')) // 按逗号或空格分割
                      .where((s) => s.isNotEmpty) // 过滤掉空字符串
                      .map((tag) => tag.trim()) // 去除首尾空格
                      .toList();

                  try {
                    // 注意：你的 cubit 的 createDocument 方法需要更新以接收 tags 参数
                    await cubit.createDocument(
                      title: titleController.text,
                      tags: tags, // <--- 传递标签
                    );
                    if (mounted) Navigator.of(dialogContext).pop();
                  } catch (e) {
                     if (mounted) {
                       ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(content: Text(e.toString()), backgroundColor: Colors.red)
                       );
                     }
                  }
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context, Document document) async {
    final cubit = context.read<DocumentListCubit>();
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Document'),
          content: Text('Are you sure you want to delete "${document.title}"? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                try {
                  await cubit.deleteDocument(document.documentId);
                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop();
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to delete document: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
  children: [
    // --- START: 新增的顶栏 ---
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 左侧的标题/面包屑导航
          Text(
            'All Documents',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          
          // 右侧的操作按钮
          Row(
            children: [
              IconButton(
                icon: Icon(_isEditMode ? Icons.done : Icons.edit),
                onPressed: () {
                  setState(() {
                    _isEditMode = !_isEditMode;
                  });
                },
                tooltip: _isEditMode ? 'Done' : 'Edit Documents',
              ),
            ],
          ),
        ],
      ),
    ),
    const Divider(height: 1), // 添加一条分割线，让布局更清晰
          Expanded(
            child: BlocConsumer<DocumentListCubit, DocumentListState>(
              listener: (context, state) {
                if (state.status == DocumentListStatus.success && state.errorMessage != null) {
                  ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
                }
              },
              builder: (context, state) {
                switch (state.status) {
                  case DocumentListStatus.initial:
                  case DocumentListStatus.loading:
                    return const Center(child: CircularProgressIndicator());
                  case DocumentListStatus.failure:
                    return Center(child: Text(state.errorMessage ?? 'Failed to load documents.'));
                  case DocumentListStatus.success:
                  case DocumentListStatus.loadingMore:
                    if (state.documents.isEmpty) {
                      return const Center(child: Text('No documents yet. Create one!'));
                    }
                    return RefreshIndicator(
                      onRefresh: () => context.read<DocumentListCubit>().fetchDocuments(),
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: state.hasReachedMax ? state.documents.length : state.documents.length + 1,
                        itemBuilder: (context, index) {
                          if (index >= state.documents.length) {
                            return const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator()));
                          }
                          final document = state.documents[index];
                          return Row(
                            children: [
                              Expanded(
                                child: DocumentListItem(
                                  document: document,
                                  onTap: () {
                                    if (!_isEditMode) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => DocumentDetailPage(documentId: document.documentId),
                                        ),
                                      ).then((_) {
                                        context.read<DocumentListCubit>().fetchDocuments();
                                      });
                                    }
                                  },
                                ),
                              ),
                              if (_isEditMode)
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  onPressed: () {
                                    _showDeleteConfirmationDialog(context, document);
                                  },
                                ),
                            ],
                          );
                        },
                      ),
                    );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDocumentDialog(context),
        child: const Icon(Icons.add),
        tooltip: 'Create a new document',
      ),
    );
  }
}
