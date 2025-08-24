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
      child: const _DocumentListView(),
    );
  }
}

class _DocumentListView extends StatefulWidget {
  const _DocumentListView();

  @override
  State<_DocumentListView> createState() => _DocumentListViewState();
}

class _DocumentListViewState extends State<_DocumentListView> {
  final _scrollController = ScrollController();

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
    if (_isBottom) {
      context.read<DocumentListCubit>().fetchDocuments();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  Future<void> _showCreateDocumentDialog(BuildContext context) async {
    final titleController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final newDocument = await showDialog<Document>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Create New Document'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Document Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Title cannot be empty';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // Here you would typically call a cubit method to create the document
                  // For now, we'll just pop with a dummy document
                  final newDoc = Document(documentId: 'new', title: titleController.text, createdAt: DateTime.now(), updatedAt: DateTime.now(), pageCount: 0, tags: []);
                   Navigator.of(dialogContext).pop(newDoc);
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );

    if (newDocument != null && mounted) {
      // Potentially refresh or navigate
    }
  }

  // --- START: SORTING AND FILTERING DIALOGS ---

  void _showSortDialog(BuildContext context) {
    final cubit = context.read<DocumentListCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Sort By'),
          content: BlocBuilder<DocumentListCubit, DocumentListState>(
            bloc: cubit,
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: SortOption.values.map((option) {
                  return RadioListTile<SortOption>(
                    title: Text(option.displayName),
                    value: option,
                    groupValue: state.sortOption,
                    onChanged: (value) {
                      if (value != null) {
                        cubit.changeSort(value);
                        Navigator.of(dialogContext).pop();
                      }
                    },
                  );
                }).toList(),
              );
            },
          ),
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    final cubit = context.read<DocumentListCubit>();
    // Fetch tags when the dialog is opened if they haven't been loaded yet
    if (cubit.state.allTags.isEmpty && !cubit.state.areTagsLoading) {
      cubit.fetchAllTags();
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: cubit,
          child: const _FilterDialogContent(),
        );
      },
    );
  }

  // --- END: SORTING AND FILTERING DIALOGS ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Documents'),
        actions: [
          // --- START: SORT AND FILTER BUTTONS ---
          BlocBuilder<DocumentListCubit, DocumentListState>(
            builder: (context, state) {
              final bool isFilterActive = state.selectedTags.isNotEmpty;
              return Badge(
                isLabelVisible: isFilterActive,
                child: IconButton(
                  icon: const Icon(Icons.filter_list),
                  tooltip: 'Filter by Tags',
                  onPressed: () => _showFilterDialog(context),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort Documents',
            onPressed: () => _showSortDialog(context),
          ),
          // --- END: SORT AND FILTER BUTTONS ---
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<DocumentListCubit>().fetchDocuments(isRefresh: true),
          ),
        ],
      ),
      body: BlocBuilder<DocumentListCubit, DocumentListState>(
        builder: (context, state) {
          if (state.documents.isEmpty && state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null && state.documents.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.error!, textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => context.read<DocumentListCubit>().fetchDocuments(isRefresh: true),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state.documents.isEmpty) {
            return const Center(child: Text('No documents found.'));
          }

          return RefreshIndicator(
            onRefresh: () => context.read<DocumentListCubit>().fetchDocuments(isRefresh: true),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: state.hasReachedMax ? state.documents.length : state.documents.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.documents.length) {
                  return state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : const SizedBox.shrink();
                }
                final document = state.documents[index];
                return DocumentListItem(
                  document: document,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DocumentDetailPage(documentId: document.documentId),
                      ),
                    ).then((_) => context.read<DocumentListCubit>().fetchDocuments(isRefresh: true));
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDocumentDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}


// --- START: FILTER DIALOG WIDGET ---

class _FilterDialogContent extends StatefulWidget {
  const _FilterDialogContent();

  @override
  State<_FilterDialogContent> createState() => _FilterDialogContentState();
}

class _FilterDialogContentState extends State<_FilterDialogContent> {
  late List<String> _tempSelectedTags;

  @override
  void initState() {
    super.initState();
    _tempSelectedTags = context.read<DocumentListCubit>().state.selectedTags;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentListCubit, DocumentListState>(
      builder: (context, state) {
        return AlertDialog(
          title: const Text('Filter by Tags'),
          content: SizedBox(
            width: double.maxFinite,
            child: state.areTagsLoading
                ? const Center(child: CircularProgressIndicator())
                : state.tagsError != null
                    ? Center(child: Text(state.tagsError!))
                    : state.allTags.isEmpty
                        ? const Center(child: Text('No tags found.'))
                        : SingleChildScrollView(
                            child: Wrap(
                              spacing: 8.0,
                              children: state.allTags.map((tag) {
                                final isSelected = _tempSelectedTags.contains(tag);
                                return ChoiceChip(
                                  label: Text(tag),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) {
                                        _tempSelectedTags.add(tag);
                                      } else {
                                        _tempSelectedTags.remove(tag);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _tempSelectedTags = [];
                });
              },
              child: const Text('Clear'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<DocumentListCubit>().applyTagFilter(_tempSelectedTags);
                Navigator.of(context).pop();
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }
}

// --- END: FILTER DIALOG WIDGET ---