import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:luna_arc_sync/core/di/injection.dart';
import 'package:luna_arc_sync/core/api/api_client.dart';
import 'package:luna_arc_sync/data/models/job_models.dart';
import 'package:luna_arc_sync/presentation/jobs/cubit/jobs_cubit.dart';
import 'package:luna_arc_sync/presentation/jobs/cubit/jobs_state.dart';
import 'package:luna_arc_sync/l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:luna_arc_sync/core/animations/animated_list_item.dart';
import 'package:luna_arc_sync/core/theme/background_image_notifier.dart';
import 'package:luna_arc_sync/presentation/widgets/optimized_glassmorphic_container.dart';
import 'package:luna_arc_sync/presentation/widgets/optimized_glassmorphic_list.dart';
import 'package:luna_arc_sync/core/theme/glassmorphic_performance_notifier.dart';
import 'package:luna_arc_sync/core/theme/no_overscroll_behavior.dart';
import 'package:luna_arc_sync/core/cache/glassmorphic_cache.dart';
import 'package:luna_arc_sync/core/config/glassmorphic_presets.dart';
import 'package:provider/provider.dart';

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  final ScrollController _scrollController = ScrollController();
  double _lastScrollPosition = 0.0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showDeleteDialog(BuildContext context, String jobId) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.deleteJobTitle),
          content: Text(l10n.deleteJobMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                // 使用原始的 context 来访问 JobsCubit
                context.read<JobsCubit>().deleteJob(jobId);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );
  }

  void _handleJobStatusChanged(BuildContext context, List<Job> changedJobs) {
    for (final job in changedJobs) {
      final status = job.status.toJobStatusEnum();
      
      if (status == JobStatusEnum.Completed) {
        _showJobCompletedNotification(context, job);
      } else if (status == JobStatusEnum.Failed) {
        _showJobFailedNotification(context, job);
      }
    }
  }

  void _showJobCompletedNotification(BuildContext context, Job job) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    String message = l10n.jobCompleted;
    if (job.type.toLowerCase().contains('pdf')) {
      message = l10n.pdfExportCompleted;
    } else if (job.type.toLowerCase().contains('ocr')) {
      message = l10n.ocrProcessingCompleted;
    } else if (job.type.toLowerCase().contains('batch')) {
      message = l10n.batchExportCompleted;
    }
    
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.jobsTaskCompletedWithId(message, job.jobId.substring(0, 8))),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: l10n.view,
          textColor: Colors.white,
          onPressed: () {
            // 可以滚动到特定任务或显示详情
          },
        ),
      ),
    );
  }

  void _showJobFailedNotification(BuildContext context, Job job) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    String message = l10n.jobFailed;
    if (job.type.toLowerCase().contains('pdf')) {
      message = l10n.pdfExportFailed;
    } else if (job.type.toLowerCase().contains('ocr')) {
      message = l10n.ocrProcessingFailed;
    } else if (job.type.toLowerCase().contains('batch')) {
      message = l10n.batchExportFailed;
    }
    
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text('$message：${job.errorMessage ?? l10n.unknownError}'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: l10n.view,
          textColor: Colors.white,
          onPressed: () {
            // 可以滚动到特定任务或显示详情
          },
        ),
      ),
    );
  }

  Future<void> _downloadResult(BuildContext context, Job job) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    try {
      // 显示下载进度
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(l10n.downloadingResult),
          duration: const Duration(seconds: 2),
        ),
      );

      // 构建下载URL
      final downloadUrl = getIt<ApiClient>().dio.options.baseUrl + job.resultUrl!;
      
      // 下载文件
      final response = await getIt<ApiClient>().dio.get(
        downloadUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      // 确定文件扩展名
      String extension = 'bin';
      if (job.type.toLowerCase().contains('pdf')) {
        extension = 'pdf';
      } else if (job.type.toLowerCase().contains('zip') || job.type.toLowerCase().contains('batch')) {
        extension = 'zip';
      }

      // 生成文件名
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final fileName = '${job.type}_${job.jobId.substring(0, 8)}_$timestamp.$extension';

      // 使用 FilePicker 让用户选择保存位置
      final filePath = await FilePicker.platform.saveFile(
        dialogTitle: l10n.saveFile,
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: [extension],
        bytes: Uint8List.fromList(response.data),
      );

      if (filePath != null) {
        // 显示成功信息
        final fileSize = (response.data.length / 1024 / 1024).toStringAsFixed(2);
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(l10n.downloadSuccess(fileName, fileSize)),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
          ),
        );
      } else {
        // 用户取消了保存
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(l10n.saveCancelled),
          ),
        );
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(l10n.downloadFailed(e.toString())),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasCustomBackground = context.watch<BackgroundImageNotifier>().hasCustomBackground;
    // 启动轮询
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JobsCubit>().startPolling();
    });
    
    return Scaffold(
        backgroundColor: hasCustomBackground ? Colors.transparent : null,
        appBar: AppBar(
          backgroundColor: hasCustomBackground ? Colors.transparent : null,
          title: Text(AppLocalizations.of(context)!.jobsPageTitle),
          actions: [
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () => context.read<JobsCubit>().loadLocalJobs(),
              tooltip: AppLocalizations.of(context)!.loadHistoryTooltip,
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                // 保存当前滚动位置
                _lastScrollPosition = _scrollController.hasClients 
                    ? _scrollController.offset 
                    : 0.0;
                // 使用 context.read 来获取正确的 context
                context.read<JobsCubit>().fetchJobs(forceUpdate: true);
              },
              tooltip: AppLocalizations.of(context)!.refreshTooltip,
            ),
                  ],
                ),
        body: BlocListener<JobsCubit, JobsState>(
          listener: (context, state) {
            // 在数据更新后恢复滚动位置
            state.whenOrNull(
              success: (jobs) {
                if (_scrollController.hasClients && _lastScrollPosition > 0) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollController.animateTo(
                      _lastScrollPosition,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  });
                }
              },
              jobStatusChanged: (changedJobs) {
                // 处理任务状态变化通知
                _handleJobStatusChanged(context, changedJobs);
              },
            );
          },
          child: BlocBuilder<JobsCubit, JobsState>(
            builder: (context, state) {
              return state.when(
                initial: () => _InitialLoadingState(),
                loading: () => _LoadingState(),
                failure: (message) => _ErrorState(
                  message: message,
                  onRetry: () => context.read<JobsCubit>().fetchJobs(forceUpdate: true),
                ),
                jobStatusChanged: (changedJobs) => const SizedBox.shrink(), // 这个状态由listener处理
                success: (jobs) {
                  if (jobs.isEmpty) {
                    return _EmptyJobsState(
                      onRefresh: () => context.read<JobsCubit>().fetchJobs(forceUpdate: true),
                      onLoadHistory: () => context.read<JobsCubit>().loadLocalJobs(),
                  );
                }
                return ScrollConfiguration(
                  behavior: hasCustomBackground 
                      ? const GlassmorphicScrollBehavior() 
                      : ScrollConfiguration.of(context).copyWith(),
                  child: RefreshIndicator(
                      onRefresh: () async {
                        _lastScrollPosition = _scrollController.hasClients 
                            ? _scrollController.offset 
                            : 0.0;
                        await context.read<JobsCubit>().fetchJobs(forceUpdate: true);
                      },
                    // 🚀 性能优化：使用共享模糊层提升Jobs列表渲染性能
                    child: hasCustomBackground
                        ? OptimizedGlassmorphicListBuilder(
                            blurGroup: 'jobs_list',
                            blur: GlassmorphicPresets.jobListBlur,
                            opacity: GlassmorphicPresets.jobListOpacity,
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount: jobs.length,
                            itemBuilder: (context, index) {
                              final job = jobs[index];
                              return AnimatedListItem(
                                index: index,
                                delay: const Duration(milliseconds: 40),
                                duration: const Duration(milliseconds: 400),
                                animationType: AnimationType.fadeSlideUp,
                                child: _JobCard(
                                  job: job,
                                  onDelete: (jobId) => _showDeleteDialog(context, jobId),
                                  onDownload: (job) => _downloadResult(context, job),
                                ),
                              );
                            },
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount: jobs.length,
                            itemBuilder: (context, index) {
                              final job = jobs[index];
                              return AnimatedListItem(
                                index: index,
                                delay: const Duration(milliseconds: 40),
                                duration: const Duration(milliseconds: 400),
                                animationType: AnimationType.fadeSlideUp,
                                child: _JobCard(
                                  job: job,
                                  onDelete: (jobId) => _showDeleteDialog(context, jobId),
                                  onDownload: (job) => _downloadResult(context, job),
                                ),
                              );
                            },
                          ),
                    ),
                  );
                },
              );
            },
          ),
        ),
    );
  }
}

class _JobCard extends StatelessWidget {
  final Job job;
  final Function(String) onDelete;
  final Function(Job) onDownload;

  const _JobCard({
    required this.job, 
    required this.onDelete,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final status = job.status.toJobStatusEnum();
    final isProcessing = status == JobStatusEnum.Processing || status == JobStatusEnum.Running;
    final hasCustomBackground = context.watch<BackgroundImageNotifier>().hasCustomBackground;
    
    final cardContent = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                      Text(
                        job.type,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${AppLocalizations.of(context)!.jobId}: ${job.jobId}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                _JobStatusChip(status: status),
                if (isProcessing) ...[
                            const SizedBox(width: 8),
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                          ],
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete') {
                      onDelete(job.jobId);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text(AppLocalizations.of(context)!.delete),
                        ],
                      ),
                    ),
                  ],
                  child: const Icon(Icons.more_vert),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _JobInfoRow(
              icon: Icons.schedule,
              label: AppLocalizations.of(context)!.submitted,
              value: _formatDateTime(job.submittedAt),
            ),
            if (job.startedAt != null)
              _JobInfoRow(
                icon: Icons.play_arrow,
                label: AppLocalizations.of(context)!.started,
                value: _formatDateTime(job.startedAt!),
              ),
            if (job.completedAt != null)
              _JobInfoRow(
                icon: Icons.check_circle,
                label: AppLocalizations.of(context)!.completed,
                value: _formatDateTime(job.completedAt!),
              ),
            if (job.associatedPageId != null)
              _JobInfoRow(
                icon: Icons.description,
                label: AppLocalizations.of(context)!.pageId,
                value: job.associatedPageId!,
              ),
            if (job.errorMessage != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        job.errorMessage!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (job.resultUrl != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => onDownload(job),
                  icon: const Icon(Icons.download),
                  label: Text(AppLocalizations.of(context)!.downloadResult),
                ),
              ),
            ],
          ],
        );

    // 如果有自定义背景，使用优化的毛玻璃卡片
    if (hasCustomBackground) {
       return Consumer<GlassmorphicPerformanceNotifier>(
         builder: (context, performanceNotifier, child) {
           final config = performanceNotifier.config;
           // 使用任务列表预设（更强的毛玻璃效果）
           final blur = config.getActualBlur(GlassmorphicPresets.jobListBlur);
           final opacity = config.getActualOpacity(GlassmorphicPresets.jobListOpacity);
          
          return OptimizedGlassmorphicCard(
            blur: blur,
            opacity: opacity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 12),
            useSharedBlur: true,  // 🚀 使用共享模糊，由 OptimizedGlassmorphicListBuilder 提供
            blurGroup: 'jobs_list',
            blurMethod: config.blurMethod,
            kawaseConfig: config.blurMethod == BlurMethod.kawase ? config.getKawaseConfig() : null,
            child: cardContent,
          );
        },
      );
    }

    // 没有自定义背景时，使用普通卡片
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: cardContent,
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy HH:mm:ss').format(dateTime);
  }
}

class _InitialLoadingState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.loadingJobs,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.refreshingJobs,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 错误图标
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),
            
            // 错误标题
            Text(
              AppLocalizations.of(context)!.failedToLoadJobs,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 16),
            
            // 错误消息
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.error.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            
            // 重试按钮
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(AppLocalizations.of(context)!.tryAgain),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyJobsState extends StatelessWidget {
  final VoidCallback onRefresh;
  final VoidCallback onLoadHistory;

  const _EmptyJobsState({
    required this.onRefresh,
    required this.onLoadHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 动画图标
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.8 + (0.2 * value),
                  child: Opacity(
                    opacity: value,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.work_outline,
                        size: 80,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            
            // 标题
            Text(
              AppLocalizations.of(context)!.noJobsFound,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            
            // 描述文本
            Text(
              AppLocalizations.of(context)!.noJobsDescription,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // 操作按钮
            Column(
              children: [
                // 刷新按钮
                FilledButton.icon(
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh),
                  label: Text(AppLocalizations.of(context)!.refreshJobs),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),
                
                // 查看历史按钮
                OutlinedButton.icon(
                  onPressed: onLoadHistory,
                  icon: const Icon(Icons.history),
                  label: Text(AppLocalizations.of(context)!.viewJobHistory),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // 提示信息
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.jobsInfo,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JobInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _JobInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _JobStatusChip extends StatelessWidget {
  final JobStatusEnum status;

  const _JobStatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (status) {
      case JobStatusEnum.Completed:
      case JobStatusEnum.Success:
        backgroundColor = Colors.green.withValues(alpha: 0.2);
        textColor = Colors.green.shade700;
        icon = Icons.check_circle;
        break;
      case JobStatusEnum.Failed:
      case JobStatusEnum.Error:
        backgroundColor = Colors.red.withValues(alpha: 0.2);
        textColor = Colors.red.shade700;
        icon = Icons.error;
        break;
      case JobStatusEnum.Processing:
      case JobStatusEnum.Running:
        backgroundColor = Colors.blue.withValues(alpha: 0.2);
        textColor = Colors.blue.shade700;
        icon = Icons.sync;
        break;
      case JobStatusEnum.Queued:
      case JobStatusEnum.Pending:
        backgroundColor = Colors.orange.withValues(alpha: 0.2);
        textColor = Colors.orange.shade700;
        icon = Icons.schedule;
        break;
      case JobStatusEnum.Cancelled:
        backgroundColor = Colors.grey.withValues(alpha: 0.2);
        textColor = Colors.grey.shade700;
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            status.name,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
