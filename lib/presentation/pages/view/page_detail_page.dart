import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luna_arc_sync/core/api/api_client.dart';
import 'package:luna_arc_sync/core/api/authenticated_image_provider.dart';
import 'package:luna_arc_sync/core/di/injection.dart';
import 'package:luna_arc_sync/data/models/job_models.dart';
import 'package:luna_arc_sync/presentation/pages/cubit/page_detail_cubit.dart';
import 'package:luna_arc_sync/presentation/pages/cubit/page_detail_state.dart';
import 'package:luna_arc_sync/presentation/pages/view/version_history_Page.dart';
import 'package:luna_arc_sync/presentation/pages/widgets/highlight_overlay.dart';
import 'package:luna_arc_sync/presentation/pages/widgets/ocr_text_overlay.dart';

class PageDetailPage extends StatefulWidget {
  final String pageId;
  const PageDetailPage({super.key, required this.pageId});

  @override
  State<PageDetailPage> createState() => _PageDetailPageState();
}

class _PageDetailPageState extends State<PageDetailPage> {
  bool _isSearchVisible = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PageDetailCubit>()..fetchPage(widget.pageId),
      child: BlocConsumer<PageDetailCubit, PageDetailState>(
        listener: (context, state) {
          state.whenOrNull(
            success: (_, ocrStatus, ocrErrorMessage, _, _) {
              if (ocrStatus == JobStatusEnum.Failed && ocrErrorMessage != null) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(ocrErrorMessage), backgroundColor: Colors.red));
              }
            },
          );
        },
        builder: (context, state) {
          final docTitle = state.whenOrNull(success: (doc, _, __, ___, ____) => doc.title) ?? 'Loading...';

          return Scaffold(
            appBar: AppBar(
              title: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
                child: _isSearchVisible
                    ? TextField(
                        key: const ValueKey('SearchField'),
                        controller: _searchController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Search in page...',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                        onChanged: (query) => context.read<PageDetailCubit>().search(query),
                      )
                    : Text(docTitle, key: const ValueKey('TitleText')),
              ),
              actions: [
                state.whenOrNull(success: (doc, _, __, ___, ____) {
                  if (doc.currentVersion.ocrResult != null) {
                    return IconButton(
                      icon: Icon(_isSearchVisible ? Icons.close : Icons.search),
                      tooltip: 'Search in page',
                      onPressed: () {
                        setState(() {
                          _isSearchVisible = !_isSearchVisible;
                          if (!_isSearchVisible) {
                            context.read<PageDetailCubit>().search('');
                            _searchController.clear();
                          }
                        });
                      },
                    );
                  }
                  return const SizedBox.shrink();
                }) ?? const SizedBox.shrink(),
                state.whenOrNull(success: (doc, _, __, ___, ____) {
                  return IconButton(
                    icon: const Icon(Icons.history),
                    tooltip: 'View version history',
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => VersionHistoryPage(
                            pageId: doc.pageId,
                            currentVersionId: doc.currentVersion.versionId,
                          ),
                        ),
                      );
                      if (mounted) {
                        context.read<PageDetailCubit>().fetchPage(widget.pageId);
                      }
                    },
                  );
                }) ?? const SizedBox.shrink(),
                state.whenOrNull(success: (doc, ocrStatus, _, __, ___) {
                  if (ocrStatus != JobStatusEnum.Processing) {
                    return IconButton(
                      icon: const Icon(Icons.document_scanner_outlined),
                      tooltip: 'Start OCR',
                      onPressed: () => context.read<PageDetailCubit>().startOcr(),
                    );
                  }
                  return const SizedBox.shrink();
                }) ?? const SizedBox.shrink(),
              ],
            ),
            body: state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const Center(child: CircularProgressIndicator()),
              failure: (message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(message),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => context.read<PageDetailCubit>().fetchPage(widget.pageId),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              success: (page, ocrStatus, _, searchQuery, highlightedBboxes) {
                final apiClient = getIt<ApiClient>();
                final baseUrl = apiClient.dio.options.baseUrl;
                final imageUrl = '$baseUrl/images/${page.currentVersion.versionId}';
                final ocrResult = page.currentVersion.ocrResult;

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    InteractiveViewer(
                      maxScale: 5.0,
                      child: Center(
                        child: Stack(
                          children: [
                            Image(
                              image: AuthenticatedImageProvider(imageUrl, apiClient),
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return const Center(child: CircularProgressIndicator());
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.error, color: Colors.red, size: 50),
                                      SizedBox(height: 8),
                                      Text("Failed to load image."),
                                    ],
                                  ),
                                );
                              },
                            ),
                            if (ocrResult != null) ...[
                              if (highlightedBboxes.isNotEmpty)
                                Positioned.fill(
                                  child: HighlightOverlay(
                                    bboxes: highlightedBboxes,
                                    imageWidth: ocrResult.imageWidth,
                                    imageHeight: ocrResult.imageHeight,
                                  ),
                                ),
                              Positioned.fill(
                                child: OcrTextOverlay(
                                  ocrResult: ocrResult,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    if (ocrStatus == JobStatusEnum.Processing)
                      Container(
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(color: Colors.white),
                              SizedBox(height: 16),
                              Text('Processing OCR...', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
