import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';

import 'package:luna_arc_sync/core/api/authenticated_image_provider.dart';
import 'package:luna_arc_sync/presentation/documents/widgets/batch_image_editor_page.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luna_arc_sync/core/api/api_client.dart';
import 'package:luna_arc_sync/core/di/injection.dart';
import 'package:luna_arc_sync/data/models/document_models.dart';
import 'package:luna_arc_sync/l10n/app_localizations.dart';
import 'package:luna_arc_sync/data/models/page_models.dart' as page_models;
import 'package:luna_arc_sync/presentation/documents/cubit/document_detail_cubit.dart';
import 'package:luna_arc_sync/presentation/documents/cubit/document_detail_state.dart';
import 'package:luna_arc_sync/presentation/pages/view/page_detail_page.dart';
import 'package:luna_arc_sync/presentation/pages/widgets/page_list_item.dart';
import 'package:luna_arc_sync/presentation/settings/notifiers/grid_settings_notifier.dart';

enum DocumentViewType { list, grid }

// The threshold at which we switch from drag-and-drop to interactive reordering.
const _reorderThreshold = 200;

class DocumentDetailPage extends StatefulWidget {
  final String documentId;

  const DocumentDetailPage({super.key, required this.documentId});

  @override
  State<DocumentDetailPage> createState() => _DocumentDetailPageState();
}

class _DocumentDetailPageState extends State<DocumentDetailPage> {
  final _scrollController = ScrollController();
  late final DocumentDetailCubit _cubit;

  bool _isEditMode = false;
  DocumentViewType _viewType = DocumentViewType.list;

  // This local list is now only used for the drag-and-drop reordering mode.
  List<page_models.Page> _reorderablePages = [];

  @override
  void initState() {
    super.initState();
    _cubit = getIt<DocumentDetailCubit>();
    _scrollController.addListener(_onScroll);
    _cubit.fetchDocument(widget.documentId);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _onScroll() {
    // Trigger fetching more pages when user scrolls to 90% of the list end.
    if (_isEndOfList) {
      _cubit.fetchMorePages();
    }
  }

  bool get _isEndOfList {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return currentScroll >= (maxScroll * 0.9);
  }

  // --- DIALOGS and HELPER METHODS ---

  Future<void> _showMovePageDialog(BuildContext context, page_models.Page page, int totalPages) async {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController();

    final newPosition = await showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Move Page'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'New position (1 - $totalPages)',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a position';
                }
                final pos = int.tryParse(value);
                if (pos == null || pos < 1 || pos > totalPages) {
                  return 'Position must be between 1 and $totalPages';
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
                  Navigator.of(dialogContext).pop(int.parse(controller.text));
                }
              },
              child: const Text('Move'),
            ),
          ],
        );
      },
    );

    if (newPosition != null) {
      // User-facing position is 1-based, API is 0-based.
      await _cubit.movePage(page.pageId, newPosition - 1);
    }
  }

  Future<void> _showGridSettingsDialog(BuildContext context) async {
    final notifier = context.read<GridSettingsNotifier>();
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)?.gridSettings ?? 'Grid Settings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context)?.numberOfColumns ?? 'Number of Columns'),
              StatefulBuilder(builder: (context, setState) {
                return Slider(
                  value: notifier.crossAxisCount.toDouble(),
                  min: 2,
                  max: 5,
                  divisions: 3,
                  label: notifier.crossAxisCount.toString(),
                  onChanged: (value) {
                    notifier.updateCrossAxisCount(value.toInt());
                    setState(() {}); // Rebuild the slider to show the new value
                  },
                );
              }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditDocumentDialog(BuildContext context, DocumentDetail doc) async {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController(text: doc.title);
    final tags = List<String>.from(doc.tags);

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)?.editDocumentInfo ?? 'Edit Document Info'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleController,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)?.documentTitle ?? 'Document Title',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _TagEditor(
                    initialTags: tags,
                    onTagsChanged: (updatedTags) {
                      tags.clear();
                      tags.addAll(updatedTags);
                    },
                  ),
                ],
              ),
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
                  Navigator.of(dialogContext).pop({
                    'title': titleController.text,
                    'tags': tags,
                  });
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      await _cubit.updateDocument(
        title: result['title'] as String,
        tags: result['tags'] as List<String>,
      );
    }
  }

  void _showAddPageOptions(BuildContext pageContext, String documentId) {
    showModalBottomSheet(
      context: pageContext,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.file_upload),
                title: Text(AppLocalizations.of(context)?.selectFromFiles ?? 'Select from Files'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickFiles(pageContext, documentId);
                },
              ),
              // Conditionally show the scan button only on supported platforms
              if (!kIsWeb && (Platform.isAndroid || Platform.isIOS))
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: Text(AppLocalizations.of(context)?.scanDocument ?? 'Scan Document'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _scanDocuments(pageContext, documentId);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickFiles(BuildContext context, String documentId) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (result == null || result.files.isEmpty) return;

      // Check for the special case of a single PDF upload
      if (result.files.length == 1 &&
          result.files.single.extension?.toLowerCase() == 'pdf') {
        final singleFile = result.files.single;
        if (!context.mounted) return;
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)?.uploadingAndProcessingPdf ?? 'Uploading and processing PDF...')),
        );

        try {
          await _cubit.createPagesFromPdf(
            filePath: singleFile.path!,
            fileName: singleFile.name,
          );
          
          // 显示成功提示
          if (context.mounted) {
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)?.pdfUploadedSuccessfully ?? 'PDF uploaded successfully! Processing pages...'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );
          }
          
          // 延迟刷新以确保服务器处理完成
          Future.delayed(const Duration(seconds: 3), () {
            if (context.mounted) {
              _cubit.refreshDocument();
            }
          });
        } catch (e) {
          if (!context.mounted) return;
          scaffoldMessenger.showSnackBar(
            SnackBar(content: Text('${AppLocalizations.of(context)?.pdfUploadFailed ?? 'PDF upload failed'}: $e'), backgroundColor: Colors.red),
          );
        }
      } else {
        // For multiple files or single images, go to the stitching page
        final paths = result.paths.where((p) => p != null).cast<String>().toList();
        if (paths.isNotEmpty) {
          if (!context.mounted) return;
          _navigateToStitchingPage(context, documentId, paths);
        }
      }
    } on PlatformException catch (e) {
      if (!context.mounted) return;
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error picking files: ${e.message}')),
      );
    }
  }

  Future<void> _scanDocuments(BuildContext context, String documentId) async {
    try {
      final pictures = await CunningDocumentScanner.getPictures();
      if (pictures != null && pictures.isNotEmpty) {
        if (!context.mounted) return;
        _navigateToStitchingPage(context, documentId, pictures);
      }
    } on PlatformException catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error scanning: ${e.message}')),
      );
    }
  }

  void _navigateToStitchingPage(BuildContext context, String documentId, List<String> paths) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: _cubit, // Pass the existing cubit instance
          child: BatchImageEditorPage(
            documentId: documentId,
            filePaths: paths,
          ),
        ),
      ),
    ).then((didUpload) {
      if (didUpload == true) {
        // 优雅地刷新文档详情页，显示加载状态
        _cubit.refreshDocument();
        
        // 显示成功提示
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)?.pagesUploadedSuccessfully ?? 'Pages uploaded successfully!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    });
  }

  Future<void> _exportDocumentAsPdf(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final doc = _cubit.state.whenOrNull(success: (d, hasReachedMax, _, _) => d);
    if (doc == null) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.documentNotLoadedCannotExport),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 检查文档是否有页面
    if (doc.pages.isEmpty) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.documentEmptyCannotExportPdf),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 显示确认对话框
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.documentExportAsPdf),
          content: Text(
            AppLocalizations.of(context)!.documentExportAsPdfDescription(doc.title) +
            AppLocalizations.of(context)!.documentExportAsPdfAdditionalInfo(doc.pages.length.toString())
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(AppLocalizations.of(context)!.documentStartExport),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      // 启动PDF导出任务（非阻塞）
      final jobId = await _cubit.startPdfExportJob();
      
      if (!context.mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.documentPdfExportTaskStarted(jobId.substring(0, 8))),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: '查看任务',
            textColor: Colors.white,
            onPressed: () {
              // 导航到任务页面
              Navigator.of(context).pushNamed('/jobs');
            },
          ),
        ),
      );
    } catch (e) {
      String errorMessage = '启动PDF导出任务时发生错误';
      if (e.toString().contains('timeout')) {
        errorMessage = '启动导出任务超时，请检查网络连接后重试';
      } else if (e.toString().contains('network')) {
        errorMessage = '网络错误，请检查网络连接';
      } else if (e.toString().contains('server')) {
        errorMessage = '服务器错误，请稍后重试';
      }
      
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('$errorMessage: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  // --- WIDGET BUILD ---

  @override
  Widget build(BuildContext context) {
    final gridSettings = context.watch<GridSettingsNotifier>();

    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<DocumentDetailCubit, DocumentDetailState>(
        listener: (context, state) {
          // After a successful load, check if we need to fetch more pages to fill the screen.
          state.mapOrNull(success: (successState) {
            if (successState.document.pages.isEmpty) return;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              // Check if the scroll controller is attached and the view is not scrollable.
              if (_scrollController.hasClients &&
                  _scrollController.position.maxScrollExtent == 0 &&
                  !successState.hasReachedMax) {
                _cubit.fetchMorePages();
              }
            });
          });
        },
        child: BlocBuilder<DocumentDetailCubit, DocumentDetailState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: state.whenOrNull(success: (doc, _, _, isRefreshing) => 
                  Row(
                    children: [
                      Text(doc.title),
                      if (isRefreshing) ...[
                        const SizedBox(width: 8),
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ],
                    ],
                  )
                ) ?? Text(AppLocalizations.of(context)?.loadingDocuments ?? 'Loading Documents...'),
                actions: _buildAppBarActions(context, state),
              ),
              body: state.when(
                initial: () => const SizedBox.shrink(),
                loading: () => const Center(child: CircularProgressIndicator()),
                failure: (message) => Center(child: Text(message)),
                success: (document, hasReachedMax, _, isRefreshing) {
                  final pages = document.pages;
                  if (pages.isEmpty) {
                    return Center(
                      child: Text(AppLocalizations.of(context)?.thisDocumentIsEmpty ?? 'This document is empty. Add a page to get started!'),
                    );
                  }

                  if (_isEditMode) {
                    return _buildEditModeList(context, document, pages);
                  } else {
                    switch (_viewType) {
                      case DocumentViewType.list:
                        return _buildListView(context, pages, hasReachedMax);
                      case DocumentViewType.grid:
                        return _buildGridView(context, gridSettings, pages, hasReachedMax);
                    }
                  }
                },
              ),
              floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () => _showAddPageOptions(context, widget.documentId),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildAppBarActions(BuildContext context, DocumentDetailState state) {
    return [
      // 刷新按钮 - 始终显示
      IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: () => _cubit.refreshDocument(),
        tooltip: AppLocalizations.of(context)?.refresh ?? 'Refresh',
      ),
      if (!_isEditMode)
        IconButton(
          icon: Icon(_viewType == DocumentViewType.list ? Icons.view_module : Icons.view_list),
          onPressed: () {
            setState(() {
              _viewType = _viewType == DocumentViewType.list
                  ? DocumentViewType.grid
                  : DocumentViewType.list;
            });
          },
          tooltip: 'Switch View',
        ),
      if (!_isEditMode && _viewType == DocumentViewType.grid)
        IconButton(
          icon: const Icon(Icons.grid_view_rounded),
          onPressed: () => _showGridSettingsDialog(context),
          tooltip: AppLocalizations.of(context)?.gridSettings ?? 'Grid Settings',
        ),
      if (!_isEditMode)
        IconButton(
          icon: const Icon(Icons.ios_share),
          onPressed: () => _exportDocumentAsPdf(context),
          tooltip: 'Export as PDF',
        ),
      // The Edit button is now always visible, but its behavior changes.
      IconButton(
        icon: Icon(_isEditMode ? Icons.done : Icons.edit),
        onPressed: () {
          final doc = state.whenOrNull(success: (d, _, _, _) => d)!;
          final canDragAndDrop = doc.pages.length < _reorderThreshold;

          if (_isEditMode && canDragAndDrop) {
            // Save drag-and-drop order
            final pageOrders = _reorderablePages.asMap().entries.map((e) => {'pageId': e.value.pageId, 'order': e.key + 1}).toList();
            _cubit.reorderPages(pageOrders);
          }
          
          setState(() {
            if (!_isEditMode && canDragAndDrop) {
              // Entering drag-and-drop mode, so we need a local copy.
              _reorderablePages = List.from(doc.pages);
            }
            _isEditMode = !_isEditMode;
          });
        },
      ),
      state.whenOrNull(
            success: (doc, _, _, _) => IconButton(
              icon: const Icon(Icons.edit_note),
              onPressed: () => _showEditDocumentDialog(context, doc),
              tooltip: AppLocalizations.of(context)?.editDocumentInfo ?? 'Edit Document Info',
            ),
          ) ??
          const SizedBox.shrink(),
    ];
  }

  Widget _buildListView(BuildContext context, List<page_models.Page> pages, bool hasReachedMax) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: hasReachedMax ? pages.length : pages.length + 1,
      itemBuilder: (context, index) {
        if (index >= pages.length) {
          return const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator()));
        }
        final page = pages[index];
        return PageListItem(
          page: page,
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PageDetailPage(pageId: page.pageId))),
        );
      },
    );
  }

  Widget _buildGridView(BuildContext context, GridSettingsNotifier gridSettings, List<page_models.Page> pages, bool hasReachedMax) {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gridSettings.crossAxisCount,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.75,
      ),
      itemCount: hasReachedMax ? pages.length : pages.length + 1,
      itemBuilder: (context, index) {
        if (index >= pages.length) {
          return const Center(child: CircularProgressIndicator());
        }
        final page = pages[index];
        return _PageGridItem(
          page: page,
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PageDetailPage(pageId: page.pageId))),
        );
      },
    );
  }

  // This widget now decides which type of edit list to show.
  Widget _buildEditModeList(BuildContext context, DocumentDetail document, List<page_models.Page> pages) {
    final canDragAndDrop = pages.length < _reorderThreshold;

    if (canDragAndDrop) {
      return _buildReorderableList(context);
    } else {
      return _buildInteractiveInsertList(context, document, pages);
    }
  }

  // The classic drag-and-drop list for small documents.
  Widget _buildReorderableList(BuildContext context) {
    return ReorderableListView.builder(
      itemCount: _reorderablePages.length,
      itemBuilder: (context, index) {
        final page = _reorderablePages[index];
        return Container(
          key: ValueKey(page.pageId),
          child: Row(children: [
            const Padding(padding: EdgeInsets.symmetric(horizontal: 8.0), child: Icon(Icons.drag_handle)),
            Expanded(child: PageListItem(page: page, onTap: () {})),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _showDeletePageConfirmationDialog(context, page),
              tooltip: 'Delete Page',
            ),
          ]),
        );
      },
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (oldIndex < newIndex) newIndex -= 1;
          final page = _reorderablePages.removeAt(oldIndex);
          _reorderablePages.insert(newIndex, page);
        });
      },
    );
  }

  // The new interactive list for large documents.
  Widget _buildInteractiveInsertList(BuildContext context, DocumentDetail document, List<page_models.Page> pages) {
    return ListView.builder(
      // Note: No infinite scroll in this mode, as it complicates reordering.
      // We assume the user wants to see all pages to make a decision.
      itemCount: pages.length,
      itemBuilder: (context, index) {
        final page = pages[index];
        return Row(
          key: ValueKey(page.pageId),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('${index + 1}', style: Theme.of(context).textTheme.titleMedium),
            ),
            Expanded(child: PageListItem(page: page, onTap: () {})),
            IconButton(
              icon: const Icon(Icons.move_up_rounded, color: Colors.blueAccent),
              onPressed: () => _showMovePageDialog(context, page, document.pages.length),
              tooltip: 'Move Page',
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _showDeletePageConfirmationDialog(context, page),
              tooltip: 'Delete Page',
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeletePageConfirmationDialog(BuildContext context, page_models.Page page) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Page'),
          content: Text('Are you sure you want to delete the page "${page.title}"? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _cubit.deletePage(page.pageId);
    }
  }
}

class _PageGridItem extends StatelessWidget {
  final page_models.Page page;
  final VoidCallback onTap;

  const _PageGridItem({required this.page, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final apiClient = getIt<ApiClient>();
    // Construct the URL using the pageId, as per the new logic.
    final imageUrl = '/api/images/thumbnail/${page.pageId}';

    // DEBUG: Print the URL we are trying to load
    if (kDebugMode) {
      print('Attempting to load image from URL (relative): $imageUrl');
    }

    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                color: Colors.grey[300],
                child: Image(
                  image: AuthenticatedImageProvider(imageUrl, apiClient),
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    // DEBUG: Print detailed error information
                    if (kDebugMode) {
                      print('--- IMAGE LOAD ERROR ---');
                      print('URL (relative): $imageUrl');
                      print('Error: $error');
                      print('Stack trace: $stackTrace');
                      print('------------------------');
                    }
                    return const Icon(Icons.broken_image, size: 48);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(page.title, style: Theme.of(context).textTheme.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
    )
    );
  }
}

class _TagEditor extends StatefulWidget {
  final List<String> initialTags;
  final ValueChanged<List<String>> onTagsChanged;

  const _TagEditor({required this.initialTags, required this.onTagsChanged});

  @override
  _TagEditorState createState() => _TagEditorState();
}

class _TagEditorState extends State<_TagEditor> {
  late List<String> _tags;
  final _tagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tags = List.from(widget.initialTags);
  }

  void _addTag() {
    final text = _tagController.text.trim();
    if (text.isNotEmpty && !_tags.contains(text)) {
      setState(() {
        _tags.add(text);
        widget.onTagsChanged(_tags);
      });
      _tagController.clear();
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
      widget.onTagsChanged(_tags);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)?.tags ?? 'Tags', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: _tags.map((tag) {
            return Chip(
              label: Text(tag),
              onDeleted: () => _removeTag(tag),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _tagController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)?.addTag ?? 'Add a tag',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => _addTag(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addTag,
            ),
          ],
        ),
      ],
    );
  }
}