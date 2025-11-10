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
import 'package:luna_arc_sync/data/models/folder_models.dart';
import 'package:luna_arc_sync/core/animations/animated_list_item.dart';
import 'package:luna_arc_sync/core/animations/animated_button.dart';
import 'package:luna_arc_sync/core/theme/background_image_notifier.dart';
import 'package:luna_arc_sync/core/theme/no_overscroll_behavior.dart';
import 'package:luna_arc_sync/presentation/widgets/optimized_glassmorphic_list.dart';
import 'package:luna_arc_sync/core/utils/context_utils.dart';

class DocumentListPage extends StatelessWidget {
  const DocumentListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DocumentListCubit>()..initialize(),
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
  static const String _ownerAllToken = '__ALL__';

  final _scrollController = ScrollController();

  // --- START: Selection Mode State ---
  bool _isSelectionMode = false;
  final Set<String> _selectedDocumentIds = {};
  // --- END: Selection Mode State ---

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
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

  void _onScroll() {
    if (!_scrollController.hasClients || _isSelectionMode) return;
    final position = _scrollController.position;
    if (position.maxScrollExtent - position.pixels <= 200) {
      context.read<DocumentListCubit>().fetchDocuments();
    }
  }

  void _handleItemTap(String documentId) {
    if (_isSelectionMode) {
      _toggleSelection(documentId);
    } else {
      final cubit = context.read<DocumentListCubit>();
      ContextUtils.safeNavigate(
        context,
        () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => DocumentDetailPage(documentId: documentId),
          ),
        ),
      ).then((_) {
        if (mounted) {
          cubit.fetchDocuments(isRefresh: true);
        }
      });
    }
  }

  Future<void> _batchExport() async {
    if (_selectedDocumentIds.isEmpty) {
      ContextUtils.showSnackBar(
        context,
        'Please select at least one document to export.',
      );
      return;
    }

    ContextUtils.showSnackBar(
      context,
      'Starting export for ${_selectedDocumentIds.length} documents...',
    );

    try {
      final cubit = context.read<DocumentListCubit>();
      final jobId = await cubit.startBatchExportJob(
        _selectedDocumentIds.toList(),
      );

      if (mounted) {
        ContextUtils.showSuccessSnackBar(
          context,
          'Batch export job started with ID: $jobId. Please check the Jobs page for progress.',
        );
      }
    } catch (e) {
      if (mounted) {
        ContextUtils.showErrorSnackBar(
          context,
          'An error occurred during batch export: $e',
        );
      }
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
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                AppLocalizations.of(context)?.createNewDocument ??
                    'Create New Document',
              ),
              content: Form(
                key: formKey,
                child: TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)?.documentTitle ??
                        'Document Title',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)?.titleCannotBeEmpty ??
                          'Title cannot be empty';
                    }
                    return null;
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
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
                                final scaffoldMessenger = ScaffoldMessenger.of(
                                  context,
                                );
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${AppLocalizations.of(context)?.failedToCreateDocument ?? 'Failed to create document'}: $e',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
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
          },
        );
      },
    );
  }

  void _showSortDialog(BuildContext context) {
    final cubit = context.read<DocumentListCubit>();
    showDialog<void>(
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
                    // ignore: deprecated_member_use
                    groupValue: state.sortOption,
                    // ignore: deprecated_member_use
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

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: cubit,
          child: const _FilterDialogContent(),
        );
      },
    );
  }

  Future<void> _showOwnerFilterDialog(
    DocumentListCubit cubit,
    DocumentListState state,
  ) async {
    cubit.loadAdminUsers();
    final previousSelection = state.selectedOwnerUserId;

    final result = await showModalBottomSheet<String?>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: BlocBuilder<DocumentListCubit, DocumentListState>(
              bloc: cubit,
              builder: (context, currentState) {
                final isLoading = currentState.isOwnerFilterLoading;
                final users = currentState.adminUsers;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: const Text('Filter by owner'),
                      trailing: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(sheetContext).pop(),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.groups_2_outlined),
                      title: const Text('All users'),
                      trailing: currentState.selectedOwnerUserId == null
                          ? const Icon(Icons.check)
                          : null,
                      onTap: () =>
                          Navigator.of(sheetContext).pop(_ownerAllToken),
                    ),
                    const Divider(height: 1),
                    SizedBox(
                      height: 320,
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : users.isEmpty
                          ? const Center(child: Text('No users available'))
                          : ListView.separated(
                              itemCount: users.length,
                              separatorBuilder: (_, _) =>
                                  const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final user = users[index];
                                final isSelected =
                                    currentState.selectedOwnerUserId == user.id;
                                return ListTile(
                                  leading: const Icon(Icons.person_outline),
                                  title: Text(user.email),
                                  subtitle: Text(
                                    '${user.documentCount} documents',
                                  ),
                                  trailing: isSelected
                                      ? const Icon(Icons.check)
                                      : null,
                                  onTap: () =>
                                      Navigator.of(sheetContext).pop(user.id),
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );

    if (result == null) {
      return;
    }

    final newOwnerId = result == _ownerAllToken ? null : result;
    if (previousSelection == newOwnerId) {
      return;
    }

    await cubit.setOwnerFilter(newOwnerId);
    if (!mounted) return;
    final error = cubit.state.ownerFilterError;
    if (error != null) {
      ContextUtils.showErrorSnackBar(
        context,
        'Failed to apply owner filter: $error',
      );
    } else {
      final label = _resolveOwnerName(cubit.state);
      ContextUtils.showSnackBar(context, '已筛选: $label');
    }
  }

  Future<void> _showCreateFolderDialog({String? parentFolderId}) async {
    final cubit = context.read<DocumentListCubit>();
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        bool isSubmitting = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Create Folder'),
              content: Form(
                key: formKey,
                child: TextFormField(
                  controller: controller,
                  autofocus: true,
                  decoration: const InputDecoration(labelText: 'Folder name'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Folder name cannot be empty';
                    }
                    return null;
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            setState(() => isSubmitting = true);
                            try {
                              Navigator.of(
                                dialogContext,
                              ).pop(controller.text.trim());
                            } finally {
                              setState(() => isSubmitting = false);
                            }
                          }
                        },
                  child: isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == null || result.trim().isEmpty) {
      return;
    }

    try {
      await cubit.createFolderNode(
        result.trim(),
        parentFolderId: parentFolderId,
      );
      if (!mounted) return;
      ContextUtils.showSuccessSnackBar(context, 'Folder created');
    } catch (e) {
      if (!mounted) return;
      ContextUtils.showErrorSnackBar(context, 'Failed to create folder: $e');
    }
  }

  Future<void> _showRenameFolderDialog(
    String folderId,
    String currentName,
  ) async {
    final cubit = context.read<DocumentListCubit>();
    final controller = TextEditingController(text: currentName);
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        bool isSubmitting = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Rename Folder'),
              content: Form(
                key: formKey,
                child: TextFormField(
                  controller: controller,
                  autofocus: true,
                  decoration: const InputDecoration(labelText: 'Folder name'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Folder name cannot be empty';
                    }
                    return null;
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            setState(() => isSubmitting = true);
                            try {
                              Navigator.of(
                                dialogContext,
                              ).pop(controller.text.trim());
                            } finally {
                              setState(() => isSubmitting = false);
                            }
                          }
                        },
                  child: isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    final newName = result?.trim();
    if (newName == null || newName.isEmpty || newName == currentName) {
      return;
    }

    try {
      await cubit.renameFolder(folderId, newName);
      if (!mounted) return;
      ContextUtils.showSuccessSnackBar(context, 'Folder renamed');
    } catch (e) {
      if (!mounted) return;
      ContextUtils.showErrorSnackBar(context, 'Failed to rename folder: $e');
    }
  }

  Future<void> _confirmDeleteFolder(String folderId, String folderName) async {
    final cubit = context.read<DocumentListCubit>();

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Folder'),
          content: Text(
            'Delete "$folderName" and all its subfolders and documents?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    try {
      await cubit.deleteFolder(folderId);
      if (!mounted) return;
      ContextUtils.showSuccessSnackBar(context, 'Folder deleted');
    } catch (e) {
      if (!mounted) return;
      ContextUtils.showErrorSnackBar(context, 'Failed to delete folder: $e');
    }
  }

  Future<void> _showMoveFolderDialog(String folderId) async {
    final cubit = context.read<DocumentListCubit>();
    final state = cubit.state;

    final targetId = await _showFolderPicker(
      state: state,
      title: 'Move folder to...',
      excludeFolderId: folderId,
    );

    if (targetId == null) {
      return;
    }

    final targetParent = targetId == kRootFolderGuid ? null : targetId;

    try {
      await cubit.moveFolder(
        folderId: folderId,
        targetParentFolderId: targetParent,
      );
      if (!mounted) return;
      ContextUtils.showSuccessSnackBar(context, 'Folder moved');
    } catch (e) {
      if (!mounted) return;
      ContextUtils.showErrorSnackBar(context, 'Failed to move folder: $e');
    }
  }

  Future<void> _showMoveDocumentDialog(Document document) async {
    final cubit = context.read<DocumentListCubit>();
    final state = cubit.state;

    final targetId = await _showFolderPicker(
      state: state,
      title: 'Move "${document.title}" to...',
    );

    if (targetId == null) {
      return;
    }

    final targetFolderId = targetId == kRootFolderGuid ? null : targetId;

    try {
      await cubit.moveDocument(
        documentId: document.documentId,
        targetFolderId: targetFolderId,
      );
      if (!mounted) return;
      ContextUtils.showSuccessSnackBar(context, 'Document moved');
    } catch (e) {
      if (!mounted) return;
      ContextUtils.showErrorSnackBar(context, 'Failed to move document: $e');
    }
  }

  Future<String?> _showFolderPicker({
    required DocumentListState state,
    required String title,
    String? excludeFolderId,
    bool allowRoot = true,
  }) async {
    final tree = state.folderTree;
    final cubit = context.read<DocumentListCubit>();
    if (tree == null) {
      ContextUtils.showSnackBar(context, 'Folder tree is not loaded yet');
      return null;
    }

    final excluded = excludeFolderId == null
        ? <String>{}
        : _collectExcludedFolderIds(cubit, excludeFolderId);

    final options = <_FolderOption>[];
    if (allowRoot) {
      options.add(const _FolderOption(kRootFolderGuid, 'Root'));
    }

    void addOptions(List<FolderDto> folders, int depth) {
      for (final folder in folders) {
        if (excluded.contains(folder.folderId)) {
          continue;
        }
        final indent = '  ' * depth;
        options.add(_FolderOption(folder.folderId, '$indent${folder.name}'));
        addOptions(folder.children, depth + 1);
      }
    }

    addOptions(tree.folders, 0);

    if (options.isEmpty) {
      ContextUtils.showSnackBar(context, 'No available folders');
      return null;
    }

    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(title),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(sheetContext).pop(),
                ),
              ),
              SizedBox(
                height: 320,
                child: ListView.separated(
                  itemCount: options.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final option = options[index];
                    return ListTile(
                      title: Text(option.displayName),
                      onTap: () => Navigator.of(sheetContext).pop(option.id),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    return selected;
  }

  Set<String> _collectExcludedFolderIds(
    DocumentListCubit cubit,
    String folderId,
  ) {
    final result = <String>{folderId};
    final target = cubit.findFolderById(folderId);
    if (target == null) {
      return result;
    }

    void collect(FolderDto folder) {
      for (final child in folder.children) {
        result.add(child.folderId);
        collect(child);
      }
    }

    collect(target);
    return result;
  }

  void _handleFolderAction(
    _FolderAction action,
    FolderDto folder,
    bool isDrawer,
  ) {
    switch (action) {
      case _FolderAction.createChild:
        _showCreateFolderDialog(parentFolderId: folder.folderId);
        break;
      case _FolderAction.rename:
        _showRenameFolderDialog(folder.folderId, folder.name);
        break;
      case _FolderAction.move:
        _showMoveFolderDialog(folder.folderId);
        break;
      case _FolderAction.delete:
        _confirmDeleteFolder(folder.folderId, folder.name);
        break;
    }
    if (isDrawer && mounted) {
      Navigator.of(context).maybePop();
    }
  }

  void _onFolderSelected(String folderId, bool isDrawer) {
    context.read<DocumentListCubit>().selectFolder(folderId);
    if (isDrawer && mounted) {
      Navigator.of(context).maybePop();
    }
  }

  // --- START: AppBar & Layout Helpers ---
  AppBar _buildNormalAppBar({
    required DocumentListState state,
    required DocumentListCubit cubit,
    required bool isWideLayout,
    required bool hasCustomBackground,
  }) {
    return AppBar(
      automaticallyImplyLeading: !isWideLayout,
      backgroundColor: hasCustomBackground ? Colors.transparent : null,
      title: Text(AppLocalizations.of(context)!.myDocuments),
      actions: [
        if (state.isAdmin)
          IconButton(
            iconSize: 24,
            icon: state.isOwnerFilterLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.manage_accounts_outlined),
            tooltip: state.selectedOwnerUserId == null
                ? '筛选所属用户'
                : '当前用户: ${_resolveOwnerName(state)}',
            onPressed: state.isOwnerFilterLoading
                ? null
                : () => _showOwnerFilterDialog(cubit, state),
          ),
        IconButton(
          icon: const Icon(Icons.search),
          tooltip:
              AppLocalizations.of(context)?.searchDocuments ??
              'Search Documents',
          onPressed: () => context.push('/search'),
        ),
        Badge(
          isLabelVisible: state.selectedTags.isNotEmpty,
          label: Text('${state.selectedTags.length}'),
          child: IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip:
                AppLocalizations.of(context)?.filterByTags ?? 'Filter by Tags',
            onPressed: () => _showFilterDialog(context),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.sort),
          tooltip: 'Sort Documents',
          onPressed: () => _showSortDialog(context),
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: 'Refresh',
          onPressed: () => cubit.refresh(),
        ),
      ],
    );
  }

  AppBar _buildContextualAppBar({
    required DocumentListState state,
    required bool hasCustomBackground,
  }) {
    return AppBar(
      backgroundColor: hasCustomBackground ? Colors.transparent : null,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: _disableSelectionMode,
      ),
      title: Text('${_selectedDocumentIds.length} selected'),
      actions: [
        IconButton(
          icon: const Icon(Icons.drive_file_move_outline),
          tooltip: 'Move Selection',
          onPressed: _selectedDocumentIds.isEmpty
              ? null
              : () async {
                  final cubit = context.read<DocumentListCubit>();
                  final currentState = cubit.state;
                  final targetId = await _showFolderPicker(
                    state: currentState,
                    title: 'Move selected documents to...',
                  );
                  if (targetId == null) return;
                  final targetFolderId = targetId == kRootFolderGuid
                      ? null
                      : targetId;
                  try {
                    for (final docId in _selectedDocumentIds) {
                      await cubit.moveDocument(
                        documentId: docId,
                        targetFolderId: targetFolderId,
                      );
                    }
                    if (mounted) {
                      ContextUtils.showSuccessSnackBar(
                        context,
                        'Documents moved',
                      );
                      _disableSelectionMode();
                    }
                  } catch (e) {
                    if (!mounted) return;
                    ContextUtils.showErrorSnackBar(
                      context,
                      'Failed to move documents: $e',
                    );
                  }
                },
        ),
        IconButton(
          icon: const Icon(Icons.ios_share),
          tooltip: 'Export Selection',
          onPressed: _selectedDocumentIds.isEmpty ? null : _batchExport,
        ),
      ],
    );
  }

  Widget _buildBody({
    required DocumentListState state,
    required bool hasCustomBackground,
    required bool isWideLayout,
  }) {
    final content = _buildDocumentList(state, hasCustomBackground);

    if (!isWideLayout) {
      return content;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: 300,
          child: _buildFolderTreePanel(state: state, isDrawer: false),
        ),
        const VerticalDivider(width: 1),
        Expanded(child: content),
      ],
    );
  }

  Widget _buildDocumentList(DocumentListState state, bool hasCustomBackground) {
    if (state.isLoading && state.documents.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.documents.isEmpty) {
      final message = state.error ?? 'No documents found.';
      return RefreshIndicator(
        onRefresh: () => context.read<DocumentListCubit>().refresh(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
          children: [
            Icon(
              state.error == null ? Icons.inbox_outlined : Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      );
    }

    final cubit = context.read<DocumentListCubit>();
    final documents = state.filteredDocuments;
    final showFilterBar = _shouldShowAcademicFilterBar(state);
    final showFilteredEmpty =
        state.documents.isNotEmpty && documents.isEmpty;
    final headerCount = showFilterBar ? 1 : 0;
    final placeholderCount = showFilteredEmpty ? 1 : 0;
    final loadingCount = state.isLoading ? 1 : 0;
    final itemCount =
        headerCount + placeholderCount + documents.length + loadingCount;

    Widget buildItem(BuildContext context, int index) {
      if (showFilterBar) {
        if (index == 0) {
          return _buildAcademicFilterBar(state);
        }
        index -= 1;
      }

      if (showFilteredEmpty) {
        if (index == 0) {
          return _buildFilteredEmptyPlaceholder();
        }
        index -= 1;
      }

      if (index >= documents.length) {
        return _buildLoadingListItem();
      }

      final document = documents[index];
      final isSelected = _selectedDocumentIds.contains(document.documentId);

      return RepaintBoundary(
        child: AnimatedListItem(
          key: ValueKey(document.documentId),
          index: index,
          delay: const Duration(milliseconds: 30),
          child: DocumentListItem(
            key: ValueKey('item_${document.documentId}'),
            document: document,
            isSelected: isSelected,
            onTap: () => _handleItemTap(document.documentId),
            onLongPress: () => _enableSelectionMode(document.documentId),
            onMoveRequested: _isSelectionMode
                ? null
                : () => _showMoveDocumentDialog(document),
          ),
        ),
      );
    }

    final listView = hasCustomBackground
        ? OptimizedGlassmorphicListBuilder(
            blurGroup: 'document_list',
            itemCount: itemCount,
            controller: _scrollController,
            itemBuilder: buildItem,
          )
        : ListView.builder(
            controller: _scrollController,
            itemCount: itemCount,
            itemBuilder: buildItem,
          );

    return ScrollConfiguration(
      behavior: hasCustomBackground
          ? const GlassmorphicScrollBehavior()
          : ScrollConfiguration.of(context).copyWith(),
      child: RefreshIndicator(
        onRefresh: () => cubit.refresh(),
        child: listView,
      ),
    );
  }

  Widget _buildAcademicFilterBar(DocumentListState state) {
    final cubit = context.read<DocumentListCubit>();
    final theme = Theme.of(context);
    final sections = <Widget>[
      _buildFilterSection(
        label: '学科',
        options: state.availableSubjects,
        selectedValues: state.selectedSubjects,
        onSelected: cubit.toggleSubjectFilter,
      ),
      _buildFilterSection(
        label: '试卷/考试',
        options: state.availableExamTypes,
        selectedValues: state.selectedExamTypes,
        onSelected: cubit.toggleExamTypeFilter,
      ),
      _buildFilterSection(
        label: '章节 / 知识点',
        options: state.availableChapters,
        selectedValues: state.selectedChapters,
        onSelected: cubit.toggleChapterFilter,
      ),
      _buildFilterSection(
        label: '题型',
        options: state.availableQuestionTypes,
        selectedValues: state.selectedQuestionTypes,
        onSelected: cubit.toggleQuestionTypeFilter,
      ),
      _buildFilterSection(
        label: '难度',
        options: state.availableDifficultyLevels,
        selectedValues: state.selectedDifficultyLevels,
        onSelected: cubit.toggleDifficultyFilter,
      ),
    ].whereType<Widget>().toList();

    if (sections.isEmpty && !state.hasActiveAcademicFilters) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Material(
        elevation: theme.cardTheme.elevation ?? 1,
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.auto_awesome_outlined,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '学科筛选',
                    style: theme.textTheme.titleSmall,
                  ),
                  const Spacer(),
                  if (state.hasActiveAcademicFilters)
                    TextButton(
                      onPressed: cubit.clearAcademicFilters,
                      child: const Text('清除筛选'),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              for (int i = 0; i < sections.length; i++) ...[
                sections[i],
                if (i != sections.length - 1) const SizedBox(height: 12),
              ],
              if (sections.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    '当前没有可用的结构化元数据，但你可以先设置筛选条件，等待文档同步补齐元数据。',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection({
    required String label,
    required List<String> options,
    required List<String> selectedValues,
    required ValueChanged<String> onSelected,
  }) {
    if (options.isEmpty) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selectedValues.contains(option);
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (_) => onSelected(option),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFilteredEmptyPlaceholder() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        children: [
          Icon(
            Icons.filter_alt_off_outlined,
            size: 48,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Text(
            '没有符合当前筛选条件的文档',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '尝试调整学科、试卷或知识点等筛选条件，或者清空筛选重新查看所有档案。',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => context.read<DocumentListCubit>().clearAcademicFilters(),
            icon: const Icon(Icons.refresh),
            label: const Text('清除筛选'),
          ),
        ],
      ),
    );
  }

  bool _shouldShowAcademicFilterBar(DocumentListState state) {
    return state.hasActiveAcademicFilters ||
        state.availableSubjects.isNotEmpty ||
        state.availableExamTypes.isNotEmpty ||
        state.availableChapters.isNotEmpty ||
        state.availableQuestionTypes.isNotEmpty ||
        state.availableDifficultyLevels.isNotEmpty;
  }

  Widget _buildFolderTreePanel({
    required DocumentListState state,
    required bool isDrawer,
  }) {
    final theme = Theme.of(context);
    final tree = state.folderTree;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: const Icon(Icons.folder_special_outlined),
            title: const Text('Root'),
            subtitle: Text(
              AppLocalizations.of(context)?.myDocuments ?? 'My Documents',
            ),
            selected: state.selectedFolderId == kRootFolderGuid,
            onTap: () => _onFolderSelected(kRootFolderGuid, isDrawer),
            trailing: IconButton(
              icon: const Icon(Icons.create_new_folder_outlined),
              tooltip: 'Create folder',
              onPressed: () => _showCreateFolderDialog(),
            ),
          ),
          if (state.folderTreeError != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                state.folderTreeError!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          if (state.isFolderTreeLoading && tree == null)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (tree == null)
            Expanded(
              child: ListView(
                children: const [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No folders yet.'),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: ListView(
                children: [
                  if (tree.rootDocuments.isNotEmpty)
                    ...tree.rootDocuments.map(
                      (doc) =>
                          _buildDocumentNode(doc, depth: 0, isDrawer: isDrawer),
                    ),
                  ..._buildFolderTiles(
                    tree.folders,
                    state,
                    depth: 0,
                    isDrawer: isDrawer,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildFolderTiles(
    List<FolderDto> folders,
    DocumentListState state, {
    required int depth,
    required bool isDrawer,
  }) {
    final widgets = <Widget>[];
    for (final folder in folders) {
      final isSelected = state.selectedFolderId == folder.folderId;
      final paddingStart = 16.0 + depth * 20.0;

      widgets.add(
        ListTile(
          dense: true,
          contentPadding: EdgeInsetsDirectional.only(
            start: paddingStart,
            end: 8,
          ),
          leading: const Icon(Icons.folder_outlined),
          title: Text(
            folder.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: folder.documents.isEmpty
              ? null
              : Text('${folder.documents.length} documents'),
          selected: isSelected,
          onTap: () => _onFolderSelected(folder.folderId, isDrawer),
          trailing: Wrap(
            spacing: 4,
            children: [
              IconButton(
                tooltip: 'Create sub-folder',
                icon: const Icon(Icons.create_new_folder_outlined, size: 20),
                onPressed: () =>
                    _showCreateFolderDialog(parentFolderId: folder.folderId),
              ),
              PopupMenuButton<_FolderAction>(
                onSelected: (action) =>
                    _handleFolderAction(action, folder, isDrawer),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: _FolderAction.rename,
                    child: ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Rename'),
                      dense: true,
                    ),
                  ),
                  const PopupMenuItem(
                    value: _FolderAction.move,
                    child: ListTile(
                      leading: Icon(Icons.drive_file_move_outline),
                      title: Text('Move'),
                      dense: true,
                    ),
                  ),
                  const PopupMenuItem(
                    value: _FolderAction.delete,
                    child: ListTile(
                      leading: Icon(Icons.delete_outline),
                      title: Text('Delete'),
                      dense: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

      if (folder.documents.isNotEmpty) {
        widgets.addAll(
          folder.documents.map(
            (doc) =>
                _buildDocumentNode(doc, depth: depth + 1, isDrawer: isDrawer),
          ),
        );
      }

      if (folder.children.isNotEmpty) {
        widgets.addAll(
          _buildFolderTiles(
            folder.children,
            state,
            depth: depth + 1,
            isDrawer: isDrawer,
          ),
        );
      }
    }
    return widgets;
  }

  Widget _buildDocumentNode(
    Document document, {
    required int depth,
    required bool isDrawer,
  }) {
    final paddingStart = 36.0 + depth * 20.0;
    return ListTile(
      dense: true,
      contentPadding: EdgeInsetsDirectional.only(start: paddingStart, end: 16),
      leading: const Icon(Icons.description_outlined, size: 18),
      title: Text(document.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      onTap: () {
        if (isDrawer && mounted) {
          Navigator.of(context).maybePop();
        }
        _handleItemTap(document.documentId);
      },
      trailing: IconButton(
        icon: const Icon(Icons.drive_file_move_outline, size: 18),
        tooltip: 'Move to another folder',
        onPressed: () => _showMoveDocumentDialog(document),
      ),
    );
  }

  Widget _buildLoadingListItem() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }

  String _resolveOwnerName(DocumentListState state) {
    final userId = state.selectedOwnerUserId;
    if (userId == null) {
      return '全部用户';
    }
    final cachedUser = state.userInfoCache[userId];
    if (cachedUser != null) {
      return cachedUser.nickname.isNotEmpty
          ? cachedUser.nickname
          : cachedUser.username;
    }

    for (final adminUser in state.adminUsers) {
      if (adminUser.id == userId) {
        return adminUser.email;
      }
    }

    return userId;
  }
  // --- END: AppBar & Layout Helpers ---

  @override
  Widget build(BuildContext context) {
    final hasCustomBackground = context
        .watch<BackgroundImageNotifier>()
        .hasCustomBackground;

    return PopScope(
      canPop: !_isSelectionMode,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _isSelectionMode) {
          _disableSelectionMode();
        }
      },
      child: BlocBuilder<DocumentListCubit, DocumentListState>(
        builder: (context, state) {
          final mediaQuery = MediaQuery.of(context);
          final isWideLayout = mediaQuery.size.width >= 1100;
          final cubit = context.read<DocumentListCubit>();
          final backgroundColor = hasCustomBackground
              ? Colors.transparent
              : null;

          return Scaffold(
            backgroundColor: backgroundColor,
            drawer: isWideLayout
                ? null
                : Drawer(
                    child: _buildFolderTreePanel(state: state, isDrawer: true),
                  ),
            appBar: _isSelectionMode
                ? _buildContextualAppBar(
                    state: state,
                    hasCustomBackground: hasCustomBackground,
                  )
                : _buildNormalAppBar(
                    state: state,
                    cubit: cubit,
                    isWideLayout: isWideLayout,
                    hasCustomBackground: hasCustomBackground,
                  ),
            body: _buildBody(
              state: state,
              hasCustomBackground: hasCustomBackground,
              isWideLayout: isWideLayout,
            ),
            floatingActionButton: _isSelectionMode
                ? null
                : AnimatedFAB(
                    onPressed: () => _showCreateDocumentDialog(context),
                    tooltip:
                        AppLocalizations.of(context)?.createNewDocument ??
                        'Create New Document',
                    child: const Icon(Icons.add),
                  ),
          );
        },
      ),
    );
  }
}

enum _FolderAction { createChild, rename, move, delete }

class _FolderOption {
  const _FolderOption(this.id, this.displayName);
  final String id;
  final String displayName;
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
    _tempSelectedTags = List<String>.from(
      context.read<DocumentListCubit>().state.selectedTags,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentListCubit, DocumentListState>(
      builder: (context, state) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)?.filterByTags ?? 'Filter by Tags',
          ),
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
                      spacing: 8,
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
                context.read<DocumentListCubit>().applyTagFilter(
                  _tempSelectedTags,
                );
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
