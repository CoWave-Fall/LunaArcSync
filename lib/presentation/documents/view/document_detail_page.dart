import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luna_arc_sync/core/di/injection.dart';
import 'package:luna_arc_sync/data/models/document_models.dart';
import 'package:luna_arc_sync/data/models/page_models.dart' as page_models;
import 'package:luna_arc_sync/presentation/documents/cubit/document_detail_cubit.dart';
import 'package:luna_arc_sync/presentation/documents/cubit/document_detail_state.dart';
import 'package:luna_arc_sync/presentation/pages/cubit/page_list_cubit.dart';
import 'package:luna_arc_sync/presentation/pages/cubit/page_list_state.dart';
import 'package:luna_arc_sync/presentation/pages/view/page_detail_page.dart';
import 'package:luna_arc_sync/presentation/pages/widgets/page_list_item.dart';
import 'package:material_tag_editor/tag_editor.dart';

class DocumentDetailPage extends StatefulWidget {
  final String documentId;

  const DocumentDetailPage({super.key, required this.documentId});

  @override
  State<DocumentDetailPage> createState() => _DocumentDetailPageState();
}

class _DocumentDetailPageState extends State<DocumentDetailPage> {
  bool _isEditMode = false;

  // *** NEW ***: Controller for local page list to enable reordering UI
  List<page_models.Page> _pages = [];

  // --- DIALOGS and HELPER METHODS ---

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
    // *** MODIFIED ***: Get current page count to determine the next order
    final int nextOrder = _pages.length;

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
                            // *** MODIFIED ***: Use insertPage method with the new order
                            await docDetailCubit.insertPage(
                                page.pageId, nextOrder);
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
    final result = await FilePicker.platform.pickFiles();
    // *** MODIFIED ***: Get current page count to determine the next order
    final int nextOrder = _pages.length;

    if (result != null) {
      final fileBytes = result.files.single.bytes;
      final fileName = result.files.single.name;
      if (fileBytes != null) {
        final title = await _showTitleDialog(context, fileName);
        if (title != null) {
          try {
            // *** MODIFIED ***: Pass newOrder to the cubit method
            await cubit.createPageAndAddToDocument(
              title: title,
              fileBytes: fileBytes,
              fileName: fileName,
              newOrder: nextOrder,
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

  // *** NEW ***: Dialog to edit a page's title.
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
    return BlocProvider(
      create: (context) =>
          getIt<DocumentDetailCubit>()..fetchDocument(widget.documentId),
      // *** MODIFIED ***: Use BlocConsumer to listen for state changes and update local list
      child: BlocConsumer<DocumentDetailCubit, DocumentDetailState>(
        listener: (context, state) {
          // Update local page list whenever the success state is emitted.
          state.whenOrNull(success: (document, _) {
            // *** NEW ***: Sort pages by order before updating the state
            final sortedPages = List<page_models.Page>.from(document.pages)
              ..sort((a, b) => a.order.compareTo(b.order));
            setState(() {
              _pages = sortedPages;
            });
          });
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: state.whenOrNull(success: (doc, _) => Text(doc.title)) ??
                  const Text('Loading Document...'),
              actions: [
                IconButton(
                  icon: Icon(_isEditMode ? Icons.done : Icons.edit),
                  onPressed: () {
                    // *** MODIFIED ***: When exiting edit mode, if changes were made, reorder.
                    if (_isEditMode) {
                      final cubit = context.read<DocumentDetailCubit>();
                      // Create the payload for the reorder API
                      final pageOrders = _pages
                          .asMap()
                          .entries
                          .map((entry) => {
                                'pageId': entry.value.pageId,
                                'order': entry.key, // Use index as the new order
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
              failure: (message) => Center(
                child: Text(message),
              ),
              success: (document, _) {
                if (_pages.isEmpty) {
                  return const Center(
                    child: Text(
                        'This document is empty. Add a page to get started!'),
                  );
                }

                // *** MODIFIED ***: Use ReorderableListView when in edit mode
                if (_isEditMode) {
                  return ReorderableListView.builder(
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      final page = _pages[index];
                      // Each item in ReorderableListView needs a unique Key.
                      return Container(
                        key: ValueKey(page.pageId),
                        child: Row(
                          children: [
                            // Drag handle
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Icon(Icons.drag_handle),
                            ),
                            Expanded(
                              child: PageListItem(
                                page: page,
                                onTap: () {
                                  // No action on tap in edit mode
                                },
                              ),
                            ),
                            // Edit Title Button
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Colors.blueGrey),
                              onPressed: () =>
                                  _showEditPageTitleDialog(context, page),
                              tooltip: 'Edit Title',
                            ),
                            // Delete Button
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red),
                              onPressed: () =>
                                  _showDeleteConfirmationDialog(context, page),
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
                } else {
                  // Original ListView for normal mode
                  return ListView.builder(
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      final page = _pages[index];
                      return PageListItem(
                        page: page,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  PageDetailPage(pageId: page.pageId),
                            ),
                          );
                        },
                      );
                    },
                  );
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
}