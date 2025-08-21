// lib/presentation/documents/view/document_list_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luna_arc_sync/core/di/injection.dart';
import 'package:luna_arc_sync/data/models/document_models.dart';
import 'package:luna_arc_sync/presentation/documents/cubit/document_list_cubit.dart';
import 'package:luna_arc_sync/presentation/documents/cubit/document_list_state.dart';
import 'package:luna_arc_sync/presentation/documents/view/document_detail_page.dart';
import 'package:luna_arc_sync/presentation/documents/widgets/document_list_item.dart';

// --- Entry Point Widget (Provider) ---
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

// --- UI View Widget ---
class DocumentListView extends StatefulWidget {
  const DocumentListView({super.key});

  @override
  State<DocumentListView> createState() => _DocumentListViewState();
}

class _DocumentListViewState extends State<DocumentListView> {
  final _scrollController = ScrollController();
  bool _isEditMode = false;

  static const _scrollThreshold = 0.9;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll >= (maxScroll * _scrollThreshold)) {
      context.read<DocumentListCubit>().fetchNextPage();
    }
  }

  Future<void> _navigateToDetail(Document document) async {
    if (_isEditMode) return;

    final shouldRefresh = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => DocumentDetailPage(documentId: document.documentId),
      ),
    );

    if (mounted && shouldRefresh == true) {
      context.read<DocumentListCubit>().fetchDocuments(refresh: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildTopBar(context),
          const Divider(height: 1),
          Expanded(child: _buildBody()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDocumentDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
  
  // --- 1. 更新顶部栏，加入排序和过滤 ---
  Widget _buildTopBar(BuildContext context) {
    // 使用 watch 监听状态变化，以便在排序状态改变时重建图标
    final state = context.watch<DocumentListCubit>().state;
    final cubit = context.read<DocumentListCubit>();

    Icon? buildSortIcon(SortBy sortBy) {
      if (state.sortBy == sortBy) {
        return Icon(
          state.sortOrder == SortOrder.desc ? Icons.arrow_downward : Icons.arrow_upward,
          size: 18,
        );
      }
      return null;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text('All Documents', style: Theme.of(context).textTheme.titleLarge),
          ),
          Row(
            children: [
              // 过滤按钮
              IconButton(
                icon: const Icon(Icons.filter_list),
                tooltip: 'Filter by Tags',
                onPressed: () {
                  // TODO: 实现标签过滤对话框
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tag filtering UI is not implemented yet.')));
                },
              ),
              // 排序按钮
              PopupMenuButton<SortBy>(
                icon: const Icon(Icons.sort),
                tooltip: 'Sort Documents',
                onSelected: (sortBy) => cubit.changeSorting(sortBy),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: SortBy.updatedAt,
                    child: ListTile(title: const Text('Date'), trailing: buildSortIcon(SortBy.updatedAt)),
                  ),
                  PopupMenuItem(
                    value: SortBy.title,
                    child: ListTile(title: const Text('Title'), trailing: buildSortIcon(SortBy.title)),
                  ),
                  PopupMenuItem(
                    value: SortBy.pageCount,
                    child: ListTile(title: const Text('Pages'), trailing: buildSortIcon(SortBy.pageCount)),
                  ),
                ],
              ),
              // 编辑模式按钮
              IconButton(
                icon: Icon(_isEditMode ? Icons.done : Icons.edit),
                onPressed: () => setState(() => _isEditMode = !_isEditMode),
                tooltip: _isEditMode ? 'Done' : 'Edit Documents',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return BlocConsumer<DocumentListCubit, DocumentListState>(
      listener: (context, state) {
        // 当 errorMessage 更新时显示 SnackBar (忽略 null 值)
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ));
        }
      },
      builder: (context, state) {
        // ... builder 逻辑保持不变 ...
        switch (state.status) {
          case DocumentListStatus.initial:
            return const Center(child: CircularProgressIndicator());
          case DocumentListStatus.loading:
             // 如果是刷新，显示加载指示器；否则显示旧列表
            return state.documents.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : _buildDocumentList(context, state);
          case DocumentListStatus.failure:
            return Center(child: Text(state.errorMessage ?? 'Failed to load documents.'));
          case DocumentListStatus.success:
          case DocumentListStatus.loadingMore:
            if (state.documents.isEmpty) {
              return const Center(child: Text('No documents yet. Create one!'));
            }
            return _buildDocumentList(context, state);
        }
      },
    );
  }

  Widget _buildDocumentList(BuildContext context, DocumentListState state) {
    return RefreshIndicator(
      onRefresh: () => context.read<DocumentListCubit>().fetchDocuments(refresh: true),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: state.hasReachedMax ? state.documents.length : state.documents.length + 1,
        itemBuilder: (context, index) {
          if (index >= state.documents.length) {
            return const Center(
              child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator()),
            );
          }
          final document = state.documents[index];
          // --- 2. 传递 onEdit 回调 ---
          return DocumentListItemRow(
            document: document,
            isEditMode: _isEditMode,
            onTap: () => _navigateToDetail(document),
            onDelete: () => _showDeleteConfirmationDialog(context, document),
            onEdit: () => _showEditDocumentDialog(context, document), // 新增
          );
        },
      ),
    );
  }
}

// --- 3. 更新 DocumentListItemRow 以包含编辑按钮 ---
class DocumentListItemRow extends StatelessWidget {
  const DocumentListItemRow({
    super.key,
    required this.document,
    required this.isEditMode,
    required this.onTap,
    required this.onDelete,
    required this.onEdit, // 新增
  });

  final Document document;
  final bool isEditMode;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onEdit; // 新增

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DocumentListItem(
            document: document,
            onTap: onTap,
          ),
        ),
        if (isEditMode)
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent),
                onPressed: onEdit,
                tooltip: 'Edit',
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: onDelete,
                tooltip: 'Delete',
              ),
            ],
          )
      ],
    );
  }
}

// --- Dialog Functions ---

// --- 4. 更新创建对话框以自动添加标签 ---
void _showCreateDocumentDialog(BuildContext context) {
  final cubit = context.read<DocumentListCubit>();
  final titleController = TextEditingController();
  // 预先填入自动生成的标签
  final tagsController = TextEditingController(text: cubit.getAutoTagForCreation());

  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Create New Document'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Document Title'),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
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
              if (titleController.text.trim().isEmpty) return;
              
              final tags = tagsController.text
                  .split(RegExp(r'[, ]+'))
                  .where((s) => s.isNotEmpty)
                  .map((tag) => tag.trim())
                  .toList();

              try {
                // 将标签列表去重
                final uniqueTags = tags.toSet().toList();
                await cubit.createDocument(title: titleController.text.trim(), tags: uniqueTags);
                if (dialogContext.mounted) Navigator.of(dialogContext).pop();
              } catch (e) {
                 if (context.mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text('Failed to create: $e'), backgroundColor: Colors.red)
                   );
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

// --- 5. 新增编辑对话框 ---
void _showEditDocumentDialog(BuildContext context, Document document) {
  final cubit = context.read<DocumentListCubit>();
  final titleController = TextEditingController(text: document.title);
  final tagsController = TextEditingController(text: document.tags.join(', '));

  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Edit Document'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Document Title'),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
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
            onPressed: () {
              if (titleController.text.trim().isEmpty) return;

              final tags = tagsController.text
                  .split(RegExp(r'[, ]+'))
                  .where((s) => s.isNotEmpty)
                  .map((tag) => tag.trim())
                  .toSet() // 去重
                  .toList();
              
              cubit.updateDocument(
                documentId: document.documentId,
                title: titleController.text.trim(),
                tags: tags,
              );
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}

// 删除确认对话框 (保持不变)
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
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
          TextButton(
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              try {
                await cubit.deleteDocument(document.documentId);
                if (dialogContext.mounted) Navigator.of(dialogContext).pop();
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