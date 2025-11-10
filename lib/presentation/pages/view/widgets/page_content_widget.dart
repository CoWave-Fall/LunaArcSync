import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luna_arc_sync/core/di/injection.dart';
import 'package:luna_arc_sync/data/models/job_models.dart';
import 'package:luna_arc_sync/l10n/app_localizations.dart';
import 'package:luna_arc_sync/presentation/pages/cubit/page_detail_cubit.dart';
import 'package:luna_arc_sync/presentation/pages/cubit/page_detail_state.dart';
import 'package:luna_arc_sync/presentation/pages/view/widgets/file_viewer_widget.dart';

/// 单个页面的内容widget
/// 使用AutomaticKeepAliveClientMixin保持状态，避免在滑动时重建
class PageContentWidget extends StatefulWidget {
  final String pageId;

  const PageContentWidget({required this.pageId, super.key});

  @override
  State<PageContentWidget> createState() => PageContentWidgetState();
}

/// PageContentWidget的公共接口
abstract class PageContentWidgetInterface {
  ValueNotifier<int> get stateNotifier;
  void search(String query);
  String get pageTitle;
  bool get hasOcrResult;
  void toggleDebugBorders();
  String get currentVersionId;
  void refreshPage();
  JobStatusEnum? get ocrStatus;
}

class PageContentWidgetState extends State<PageContentWidget>
    with AutomaticKeepAliveClientMixin
    implements PageContentWidgetInterface {
  late final GlobalKey _imageKey;
  Size? _renderedImageSize;
  JobStatusEnum? _previousOcrStatus;
  bool _showDebugBorders = false;
  PageDetailCubit? _cubit;
  final _stateNotifier = ValueNotifier<int>(0); // 用于通知父组件状态已更新

  @override
  bool get wantKeepAlive => true; // 保持状态，避免重建

  @override
  void initState() {
    super.initState();
    _imageKey = GlobalKey(debugLabel: 'page_image_${widget.pageId}');
  }

  @override
  void dispose() {
    _stateNotifier.dispose();
    super.dispose();
  }

  // 通知状态已更新
  void _notifyStateChanged() {
    _stateNotifier.value++;
  }

  // 公共接口供父组件调用
  @override
  String get pageTitle {
    return _cubit?.state.maybeWhen(
          success: (page, _, _, _, _) => page.title,
          orElse: () => 'Loading...',
        ) ??
        'Loading...';
  }

  @override
  bool get hasOcrResult {
    return _cubit?.state.maybeWhen(
          success: (page, _, _, _, _) => page.currentVersion?.ocrResult != null,
          orElse: () => false,
        ) ??
        false;
  }

  @override
  JobStatusEnum? get ocrStatus {
    return _cubit?.state.maybeWhen(
      success: (_, ocrStatus, _, _, _) => ocrStatus,
      orElse: () => null,
    );
  }

  @override
  String get currentVersionId {
    return _cubit?.state.maybeWhen(
          success: (page, _, _, _, _) => page.currentVersion?.versionId ?? '',
          orElse: () => '',
        ) ??
        '';
  }

  bool get showDebugBorders => _showDebugBorders;

  @override
  void search(String query) {
    _cubit?.search(query);
  }

  @override
  void toggleDebugBorders() {
    setState(() {
      _showDebugBorders = !_showDebugBorders;
    });
  }

  @override
  void refreshPage() {
    _cubit?.fetchPage(widget.pageId);
  }

  Future<void> startOcr() async {
    try {
      await _cubit?.startOcrJob();
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.ocrTaskStartFailed(e.toString())),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须调用以保持状态

    return BlocProvider(
      create: (context) {
        _cubit = getIt<PageDetailCubit>()..fetchPage(widget.pageId);
        return _cubit!;
      },
      child: BlocConsumer<PageDetailCubit, PageDetailState>(
        listener: (context, state) {
          // 通知父组件状态已更新
          _notifyStateChanged();

          state.whenOrNull(
            success: (_, ocrStatus, ocrErrorMessage, _, _) {
              final l10n = AppLocalizations.of(context)!;

              // Only show notification when transitioning from Processing to Completed/Failed
              if (_previousOcrStatus == JobStatusEnum.Processing) {
                if (ocrStatus == JobStatusEnum.Completed) {
                  // OCR完成通知
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(l10n.ocrTaskCompleted),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                } else if (ocrStatus == JobStatusEnum.Failed &&
                    ocrErrorMessage != null) {
                  // OCR失败通知
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(ocrErrorMessage),
                        backgroundColor: Colors.red,
                      ),
                    );
                }
              }

              // Update previous status for next comparison
              _previousOcrStatus = ocrStatus;
            },
          );
        },
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(child: CircularProgressIndicator()),
            failure: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(message),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _cubit?.fetchPage(widget.pageId),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            success: (page, ocrStatus, _, searchQuery, highlightedBboxes) {
              if (page.currentVersion == null) {
                return const Center(
                  child: Text('This page has no content yet.'),
                );
              }
              final versionId = page.currentVersion!.versionId;
              final fileUrl = '/api/images/$versionId';

              final ocrResult = page.currentVersion!.ocrResult;
              final l10n = AppLocalizations.of(context)!;

              return Column(
                children: [
                  // 顶部进度横幅（非阻塞式）
                  if (ocrStatus == JobStatusEnum.Processing)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).primaryColor.withValues(alpha: 0.1),
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(
                              context,
                            ).primaryColor.withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              l10n.ocrProcessingInProgress,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  // 页面内容区域
                  Expanded(
                    child: InteractiveViewer(
                      maxScale: 5,
                      child: SizedBox.expand(
                        child: FileViewerWidget(
                          fileUrl: fileUrl,
                          pageId: page.pageId,
                          versionId: versionId,
                          imageKey: _imageKey,
                          onImageRendered: (size) {
                            if (_renderedImageSize != size) {
                              setState(() {
                                _renderedImageSize = size;
                                if (kDebugMode) {
                                  if (kDebugMode) {
                                    debugPrint('Rendered image size: $size');
                                  }
                                }
                              });
                            }
                          },
                          ocrResult: ocrResult,
                          searchQuery: searchQuery,
                          highlightedBboxes: highlightedBboxes,
                          showDebugBorders: _showDebugBorders,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  // 实现PageContentWidgetInterface接口
  @override
  ValueNotifier<int> get stateNotifier => _stateNotifier;
}
