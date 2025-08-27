import 'dart:async';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luna_arc_sync/core/api/api_client.dart';
import 'package:luna_arc_sync/core/api/authenticated_image_provider.dart';
import 'package:luna_arc_sync/core/di/injection.dart';
import 'package:luna_arc_sync/data/models/document_models.dart';
import 'package:luna_arc_sync/data/models/page_models.dart' as page_models;
import 'package:luna_arc_sync/presentation/documents/cubit/document_detail_cubit.dart';
import 'package:luna_arc_sync/presentation/documents/cubit/document_detail_state.dart';
import 'package:luna_arc_sync/presentation/pages/cubit/page_list_cubit.dart';
import 'package:luna_arc_sync/presentation/pages/cubit/page_list_state.dart';
import 'package:luna_arc_sync/presentation/pages/view/page_detail_page.dart';
import 'package:luna_arc_sync/presentation/pages/widgets/page_list_item.dart';
import 'package:luna_arc_sync/presentation/settings/notifiers/grid_settings_notifier.dart';
import 'package:material_tag_editor/tag_editor.dart';
import 'package:provider/provider.dart';

enum DocumentViewType { list, grid }

class DocumentDetailPage extends StatefulWidget {
  final String documentId;

  const DocumentDetailPage({super.key, required this.documentId});

  @override
  State<DocumentDetailPage> createState() => _DocumentDetailPageState();
}

class _DocumentDetailPageState extends State<DocumentDetailPage> {
  bool _isEditMode = false;
  DocumentViewType _viewType = DocumentViewType.list;
  List<page_models.Page> _pages = [];
  bool _thumbnailsEnriched = false;

  // Gesture state
  double _scaleStart = 1.0;
  late int _gridCountStart;

  // --- DIALOGS and HELPER METHODS ---

  Future<void> _showGridSettingsDialog(BuildContext context) async {
    final gridSettings = context.read<GridSettingsNotifier>();
    await showDialog(
      context: context,
      builder: (context) {
        return Consumer<GridSettingsNotifier>(
          builder: (context, notifier, child) {
            return AlertDialog(
              title: const Text('Grid Layout Settings'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Columns: ${notifier.crossAxisCount}'),
                  Slider(
                    value: notifier.crossAxisCount.toDouble(),
                    min: 2,
                    max: 5,
                    divisions: 3,
                    label: notifier.crossAxisCount.toString(),
                    onChanged: (value) {
                      notifier.updateCrossAxisCount(value.toInt());
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showEditDocumentDialog(
    BuildContext context,
    DocumentDetail document,
  ) async {
    final titleController = TextEditingController(text: document.title);
    final List<String> tags = List.from(document.tags);
    final formKey = GlobalKey<FormState>();
    final cubit = context.read<DocumentDetailCubit>();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        bool isLoading = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Document Info'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                        validator: (value) =>
                            value!.isEmpty ? 'Title cannot be empty' : null,
                      ),
                      const SizedBox(height: 20),
                      TagEditor(
                        length: tags.length,
                        delimiters: const [',', ' '],
                        hasAddButton: true,
                        resetTextOnSubmitted: true,
                        textStyle: Theme.of(context).textTheme.bodyMedium!,
                        onTagChanged: (newValue) {
                          setState(() {
                            tags.add(newValue);
                          });
                        },
                        tagBuilder: (context, index) => Chip(
                          label: Text(tags[index]),
                          onDeleted: () {
                            setState(() {
                              tags.removeAt(index);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              await cubit.updateDocument(
                                title: titleController.text,
                                tags: tags,
                              );
                              if (mounted) Navigator.of(dialogContext).pop();
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(e.toString()),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } finally {
                              if (mounted) {
                                setState(() {
                                  isLoading = false;
                                });
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
                      : const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showAddPageDialog(BuildContext context) async {
    final docDetailCubit = context.read<DocumentDetailCubit>();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider(
          create: (context) => getIt<PageListCubit>()..fetchUnassignedPages(),
          child: AlertDialog(
            title: const Text('Add Page to Document'),
            content: SizedBox(
              width: double.maxFinite,
              child: BlocBuilder<PageListCubit, PageListState>(
                builder: (context, state) {
                  if (state.status == PageListStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.status == PageListStatus.failure) {
                    return Center(
                        child: Text(
                            state.errorMessage ?? 'Failed to load pages'));
                  }
                  if (state.pages.isEmpty) {
                    return const Center(
                      child: Text('No unassigned pages found.'),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.pages.length,
                    itemBuilder: (context, index) {
                      final page = state.pages[index];
                      return PageListItem(
                        page: page,
                        onTap: () async {
                          try {
                            await docDetailCubit.addPageToDocument(page.pageId);
                            if (dialogContext.mounted) {
                              Navigator.of(dialogContext).pop();
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to add page: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickAndUploadFile(BuildContext context) async {
    final cubit = context.read<DocumentDetailCubit>();
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      final fileBytes = result.files.single.bytes;
      final fileName = result.files.single.name;
      if (fileBytes != null) {
        final title = await _showTitleDialog(context, fileName);
        if (title != null) {
          try {
            await cubit.createPageAndAddToDocument(
              title: title,
              fileBytes: fileBytes,
              fileName: fileName,
            );
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to upload file: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        }
      }
    }
  }

  Future<void> _pickAndStitchFiles(BuildContext context) async {
    final cubit = context.read<DocumentDetailCubit>();
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );

    if (result != null && result.files.isNotEmpty) {
      final title = await _showTitleDialog(context, 'Stitched Page');
      if (title != null) {
        try {
          await cubit.createPageByStitching(
            title: title,
            files: result.files,
          );
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to start stitching process: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    }
  }

  Future<String?> _showTitleDialog(BuildContext context, String initialTitle) {
    final titleController = TextEditingController(text: initialTitle);
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Page Title'),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(titleController.text);
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, page_models.Page page) async {
    final cubit = context.read<DocumentDetailCubit>();
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Page'),
          content: Text(
              'Are you sure you want to delete "${page.title}"? This action cannot be undone.'),
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
                  await cubit.deletePage(page.pageId);
                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop();
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to delete page: $e'),
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

  Future<void> _showEditPageTitleDialog(
      BuildContext context, page_models.Page page) async {
    final cubit = context.read<DocumentDetailCubit>();
    final titleController = TextEditingController(text: page.title);
    final formKey = GlobalKey<FormState>();

    return showDialog<void>(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Edit Page Title'),
            content: Form(
              key: formKey,
              child: TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value!.isEmpty ? 'Title cannot be empty' : null,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(dialogContext).pop(),
              ),
              ElevatedButton(
                child: const Text('Save'),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    try {
                      await cubit.updatePageTitle(
                          page.pageId, titleController.text);
                      if (dialogContext.mounted) {
                        Navigator.of(dialogContext).pop();
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to update title: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                },
              ),
            ],
          );
        });
  }

  // --- WIDGET BUILD ---

  @override
  Widget build(BuildContext context) {
    final gridSettings = context.watch<GridSettingsNotifier>();

    return BlocProvider(
      create: (context) =>
          getIt<DocumentDetailCubit>()..fetchDocument(widget.documentId),
      child: BlocConsumer<DocumentDetailCubit, DocumentDetailState>(
        listener: (context, state) {
          state.whenOrNull(success: (document, _) {
            final sortedPages = List<page_models.Page>.from(document.pages)
              ..sort((a, b) => a.order.compareTo(b.order));
            setState(() {
              _pages = sortedPages;
            });

            if (!_thumbnailsEnriched && _pages.isNotEmpty) {
              _thumbnailsEnriched = true;
              context.read<DocumentDetailCubit>().enrichPagesWithThumbnails();
            }
          });
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: state.whenOrNull(success: (doc, _) => Text(doc.title)) ??
                  const Text('Loading Document...'),
              actions: [
                if (!_isEditMode)
                  IconButton(
                    icon: Icon(_viewType == DocumentViewType.list
                        ? Icons.view_module
                        : Icons.view_list),
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
                    tooltip: 'Grid Settings',
                  ),
                IconButton(
                  icon: Icon(_isEditMode ? Icons.done : Icons.edit),
                  onPressed: () {
                    if (_isEditMode) {
                      final cubit = context.read<DocumentDetailCubit>();
                      final pageOrders = _pages
                          .asMap()
                          .entries
                          .map((entry) => {
                                'pageId': entry.value.pageId,
                                'order': entry.key,
                              })
                          .toList();
                      cubit.reorderPages(pageOrders);
                    }
                    setState(() {
                      _isEditMode = !_isEditMode;
                    });
                  },
                ),
                state.whenOrNull(
                      success: (doc, _) => IconButton(
                        icon: const Icon(Icons.edit_note),
                        onPressed: () => _showEditDocumentDialog(context, doc),
                        tooltip: 'Edit Document Info',
                      ),
                    ) ??
                    const SizedBox.shrink(),
              ],
            ),
            body: state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const Center(child: CircularProgressIndicator()),
              failure: (message) => Center(child: Text(message)),
              success: (document, _) {
                if (_pages.isEmpty) {
                  return const Center(
                    child: Text(
                        'This document is empty. Add a page to get started!'),
                  );
                }

                if (_isEditMode) {
                  return _buildReorderableList(context);
                } else {
                  switch (_viewType) {
                    case DocumentViewType.list:
                      return _buildListView(context);
                    case DocumentViewType.grid:
                      return _buildGridView(context, gridSettings);
                  }
                }
              },
            ),
            floatingActionButton: PopupMenuButton<Function>(
              icon: const Icon(Icons.add),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text('Add from existing pages'),
                  value: () => _showAddPageDialog(context),
                ),
                PopupMenuItem(
                  child: const Text('Upload new file'),
                  value: () => _pickAndUploadFile(context),
                ),
                PopupMenuItem(
                  child: const Text('Upload and Stitch Images'),
                  value: () => _pickAndStitchFiles(context),
                ),
              ],
              onSelected: (Function callback) {
                callback();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildListView(BuildContext context) {
    return ListView.builder(
      itemCount: _pages.length,
      itemBuilder: (context, index) {
        final page = _pages[index];
        return PageListItem(
          page: page,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PageDetailPage(pageId: page.pageId),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildGridView(
      BuildContext context, GridSettingsNotifier gridSettings) {
    return Listener(
      onPointerSignal: (signal) {
        if (signal is PointerScrollEvent &&
            (signal.kind == PointerDeviceKind.mouse &&
                (HardwareKeyboard.instance.isControlPressed ||
                    HardwareKeyboard.instance.isMetaPressed))) {
          if (signal.scrollDelta.dy < 0) {
            gridSettings.updateCrossAxisCount(gridSettings.crossAxisCount - 1);
          } else {
            gridSettings.updateCrossAxisCount(gridSettings.crossAxisCount + 1);
          }
        }
      },
      child: GestureDetector(
        onScaleStart: (details) {
          _scaleStart = 1.0;
          _gridCountStart = gridSettings.crossAxisCount;
        },
        onScaleUpdate: (details) {
          final scale = details.scale.clamp(0.5, 2.0);
          if ((scale - _scaleStart).abs() > 0.2) {
            final newCount = (_gridCountStart / scale).round();
            gridSettings.updateCrossAxisCount(newCount);
          }
        },
        child: GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridSettings.crossAxisCount,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.75,
          ),
          itemCount: _pages.length,
          itemBuilder: (context, index) {
            final page = _pages[index];
            return _PageGridItem(
              page: page,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PageDetailPage(pageId: page.pageId),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildReorderableList(BuildContext context) {
    return ReorderableListView.builder(
      itemCount: _pages.length,
      itemBuilder: (context, index) {
        final page = _pages[index];
        return Container(
          key: ValueKey(page.pageId),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.drag_handle),
              ),
              Expanded(
                child: PageListItem(
                  page: page,
                  onTap: () {},
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blueGrey),
                onPressed: () => _showEditPageTitleDialog(context, page),
                tooltip: 'Edit Title',
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => _showDeleteConfirmationDialog(context, page),
                tooltip: 'Delete Page',
              ),
            ],
          ),
        );
      },
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final page = _pages.removeAt(oldIndex);
          _pages.insert(newIndex, page);
        });
      },
    );
  }
}

class _PageGridItem extends StatelessWidget {
  final page_models.Page page;
  final VoidCallback onTap;

  const _PageGridItem({required this.page, required this.onTap});

  @override
  Widget build(BuildContext context) {
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
                child: page.thumbnailUrl != null && page.thumbnailUrl!.isNotEmpty
                    ? Image(
                        image: AuthenticatedImageProvider(
                          page.thumbnailUrl!,
                          getIt<ApiClient>(),
                        ),
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image, size: 48);
                        },
                      )
                    : const Icon(Icons.image, size: 48, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                page.title,
                style: Theme.of(context).textTheme.titleSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
