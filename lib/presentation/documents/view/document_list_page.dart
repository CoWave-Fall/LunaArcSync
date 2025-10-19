import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:luna_arc_sync/core/di/injection.dart';
import 'package:luna_arc_sync/l10n/app_localizations.dart';
import 'package:luna_arc_sync/presentation/documents/cubit/document_list_cubit.dart';
import 'package:luna_arc_sync/presentation/documents/cubit/document_list_state.dart';
import 'package:luna_arc_sync/presentation/documents/view/document_detail_page.dart';
import 'package:luna_arc_sync/presentation/documents/widgets/document_list_item.dart';
import 'package:luna_arc_sync/data/models/document_models.dart';
import 'package:luna_arc_sync/core/animations/animated_list_item.dart';
import 'package:luna_arc_sync/core/animations/animated_button.dart';
import 'package:luna_arc_sync/core/theme/background_image_notifier.dart';
import 'package:luna_arc_sync/core/theme/no_overscroll_behavior.dart';
import 'package:luna_arc_sync/presentation/widgets/optimized_glassmorphic_list.dart';

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

  // --- START: Selection Mode State ---
  bool _isSelectionMode = false;
  final Set<String> _selectedDocumentIds = {};
  // --- END: Selection Mode State ---

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

  // --- START: Selection Mode Methods ---
  void _enableSelectionMode(String documentId) {
    setState(() {
      _isSelectionMode = true;
      _selectedDocumentIds.add(documentId);
    });
  }

  void _disableSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedDocumentIds.clear();
    });
  }

  void _toggleSelection(String documentId) {
    setState(() {
      if (_selectedDocumentIds.contains(documentId)) {
        _selectedDocumentIds.remove(documentId);
        if (_selectedDocumentIds.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedDocumentIds.add(documentId);
      }
    });
  }

  void _handleItemTap(String documentId) {
    if (_isSelectionMode) {
      _toggleSelection(documentId);
    } else {
      final cubit = context.read<DocumentListCubit>();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DocumentDetailPage(documentId: documentId),
        ),
      ).then((_) => cubit.fetchDocuments(isRefresh: true));
    }
  }
  
  Future<void> _batchExport() async {
    final cubit = context.read<DocumentListCubit>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (_selectedDocumentIds.isEmpty) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Please select at least one document to export.')),
      );
      return;
    }

    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text('Starting export for ${_selectedDocumentIds.length} documents...')),
    );

    try {
      final jobId = await cubit.startBatchExportJob(_selectedDocumentIds.toList());

      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Batch export job started with ID: $jobId. Please check the Jobs page for progress.')),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('An error occurred during batch export: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      _disableSelectionMode(); // Always exit selection mode after attempting export
    }
  }
  // --- END: Selection Mode Methods ---

  Future<void> _showCreateDocumentDialog(BuildContext context) async {
    final titleController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final cubit = context.read<DocumentListCubit>();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        bool isLoading = false;
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)?.createNewDocument ?? 'Create New Document'),
            content: Form(
              key: formKey,
              child: TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)?.documentTitle ?? 'Document Title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {

                    return AppLocalizations.of(context)?.titleCannotBeEmpty ?? 'Title cannot be empty';
                  }
                  return null;
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () => Navigator.of(dialogContext).pop(),
                child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel'),
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (formKey.currentState!.validate()) {
                          setState(() => isLoading = true);
                          try {
                            await cubit.createDocument(titleController.text);
                            if (mounted) {
                              // ignore: use_build_context_synchronously
                              Navigator.of(dialogContext).pop();
                            }
                          } catch (e) {
                            if (mounted) {
                              // ignore: use_build_context_synchronously
                              final scaffoldMessenger = ScaffoldMessenger.of(context);
                              scaffoldMessenger.showSnackBar(
                                SnackBar(content: Text('${AppLocalizations.of(context)?.failedToCreateDocument ?? 'Failed to create document'}: $e'), backgroundColor: Colors.red),
                              );
                            }
                          } finally {
                             if (mounted) {
                                setState(() => isLoading = false);
                             }
                          }
                        }
                      },
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(AppLocalizations.of(context)?.create ?? 'Create'),
              ),
            ],
          );
        });
      },
    );
  }

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
    if (!cubit.state.areTagsLoading) {
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

  // --- START: AppBar Build Methods ---
  AppBar _buildNormalAppBar() {
    final hasCustomBackground = context.watch<BackgroundImageNotifier>().hasCustomBackground;
    return AppBar(
      backgroundColor: hasCustomBackground ? Colors.transparent : null,
      title: Text(AppLocalizations.of(context)!.myDocuments),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          tooltip: AppLocalizations.of(context)?.searchDocuments ?? 'Search Documents',
          onPressed: () => context.push('/search'),
        ),
        Selector<DocumentListCubit, List<String>>(
          selector: (context, cubit) => cubit.state.selectedTags,
          builder: (context, selectedTags, child) {
            final bool isFilterActive = selectedTags.isNotEmpty;
            return Badge(
              isLabelVisible: isFilterActive,
              child: IconButton(
                icon: const Icon(Icons.filter_list),
                tooltip: AppLocalizations.of(context)?.filterByTags ?? 'Filter by Tags',
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
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => context.read<DocumentListCubit>().fetchDocuments(isRefresh: true),
        ),
      ],
    );
  }

  AppBar _buildContextualAppBar() {
    final hasCustomBackground = context.watch<BackgroundImageNotifier>().hasCustomBackground;
    return AppBar(
      backgroundColor: hasCustomBackground ? Colors.transparent : null,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: _disableSelectionMode,
      ),
      title: Text('${_selectedDocumentIds.length} selected'),
      actions: [
        IconButton(
          icon: const Icon(Icons.ios_share),
          tooltip: 'Export Selection',
          onPressed: _selectedDocumentIds.isEmpty ? null : _batchExport,
        ),
      ],
    );
  }
  // --- END: AppBar Build Methods ---

  @override
  Widget build(BuildContext context) {
    final hasCustomBackground = context.watch<BackgroundImageNotifier>().hasCustomBackground;
    return PopScope(
      canPop: !_isSelectionMode,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _isSelectionMode) {
          _disableSelectionMode();
        }
      },
      child: Scaffold(
        backgroundColor: hasCustomBackground ? Colors.transparent : null,
        appBar: _isSelectionMode ? _buildContextualAppBar() : _buildNormalAppBar(),
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

            return ScrollConfiguration(
              behavior: hasCustomBackground 
                  ? const GlassmorphicScrollBehavior() 
                  : ScrollConfiguration.of(context).copyWith(),
              child: RefreshIndicator(
                onRefresh: () => context.read<DocumentListCubit>().fetchDocuments(isRefresh: true),
                child: Selector<DocumentListCubit, List<Document>>(
                selector: (context, cubit) => cubit.state.documents,
                builder: (context, documents, child) {
                  // 使用优化的毛玻璃列表
                  if (hasCustomBackground) {
                    return OptimizedGlassmorphicListBuilder(
                      blurGroup: 'document_list',
                      itemCount: documents.length,
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        final document = documents[index];
                        final isSelected = _selectedDocumentIds.contains(document.documentId);

                        return AnimatedListItem(
                          key: ValueKey(document.documentId),
                          index: index,
                          delay: const Duration(milliseconds: 30),
                          duration: const Duration(milliseconds: 400),
                          animationType: AnimationType.fadeSlideUp,
                          child: DocumentListItem(
                            key: ValueKey('item_${document.documentId}'),
                            document: document,
                            isSelected: isSelected,
                            onTap: () => _handleItemTap(document.documentId),
                            onLongPress: () => _enableSelectionMode(document.documentId),
                          ),
                        );
                      },
                    );
                  } else {
                    // 没有自定义背景时使用普通列表
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final document = documents[index];
                        final isSelected = _selectedDocumentIds.contains(document.documentId);

                        return AnimatedListItem(
                          key: ValueKey(document.documentId),
                          index: index,
                          delay: const Duration(milliseconds: 30),
                          duration: const Duration(milliseconds: 400),
                          animationType: AnimationType.fadeSlideUp,
                          child: DocumentListItem(
                            key: ValueKey('item_${document.documentId}'),
                            document: document,
                            isSelected: isSelected,
                            onTap: () => _handleItemTap(document.documentId),
                            onLongPress: () => _enableSelectionMode(document.documentId),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
              ),
            );
          },
        ),
        floatingActionButton: _isSelectionMode
            ? null
            : AnimatedFAB(
                onPressed: () => _showCreateDocumentDialog(context),
                tooltip: AppLocalizations.of(context)?.createNewDocument ?? 'Create New Document',
                child: const Icon(Icons.add),
              ),
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
    _tempSelectedTags = List<String>.from(context.read<DocumentListCubit>().state.selectedTags);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentListCubit, DocumentListState>(
      builder: (context, state) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)?.filterByTags ?? 'Filter by Tags'),
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
              child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel'),
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