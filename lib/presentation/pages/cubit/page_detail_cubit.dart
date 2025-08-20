import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/data/models/job_models.dart';
import 'package:luna_arc_sync/data/repositories/page_repository.dart';
import 'package:luna_arc_sync/data/repositories/job_repository.dart';
import 'package:luna_arc_sync/data/models/page_models.dart'; 
import 'package:luna_arc_sync/presentation/pages/cubit/page_detail_state.dart';

@injectable
class PageDetailCubit extends Cubit<PageDetailState> {
  final IPageRepository _pageRepository;
  final IJobRepository _jobRepository;
  Timer? _pollingTimer;

  PageDetailCubit(this._pageRepository, this._jobRepository)
      : super(const PageDetailState.initial());

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }

  // --- START: METHOD IMPLEMENTATIONS (补全) ---

  Future<void> fetchPage(String pageId) async {
    _pollingTimer?.cancel(); // 获取新文档前，取消可能存在的旧轮询
    emit(const PageDetailState.loading());
    try {
      final page = await _pageRepository.getPageById(pageId);
      emit(PageDetailState.success(page: page));
    } catch (e) {
      emit(PageDetailState.failure(message: e.toString()));
    }
  }

  Future<void> startOcr() async {
    await state.mapOrNull(
      success: (successState) async {
        // 防止在处理中时重复点击
        if (successState.ocrStatus == JobStatusEnum.Processing) return;

        try {
          // 立即更新UI状态为“处理中”
          emit(successState.copyWith(
            ocrStatus: JobStatusEnum.Processing,
            ocrErrorMessage: null, // 清除旧的错误信息
          ));

          final response = await _pageRepository
              .startOcrJob(successState.page.currentVersion.versionId);
          
          // 启动后台轮询
          _startPolling(response.jobId, successState.page.pageId);
        } catch (e) {
          // 如果提交任务失败，立即更新UI状态
          emit(successState.copyWith(
            ocrStatus: JobStatusEnum.Failed,
            ocrErrorMessage: e.toString(),
          ));
        }
      },
    );
  }

  void _startPolling(String jobId, String pageId) {
    _pollingTimer?.cancel(); // 先取消任何可能存在的旧计时器

    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      // 如果Cubit已经关闭，则停止计时器并返回
      if (isClosed) {
        timer.cancel();
        return;
      }

      try {
        final job = await _jobRepository.getJobStatus(jobId);

        if (job.status == JobStatusEnum.Completed) {
          timer.cancel(); // 任务完成，停止轮询
          await fetchPage(pageId); // 重新获取文档数据以刷新UI
        } else if (job.status == JobStatusEnum.Failed) {
          timer.cancel(); // 任务失败，停止轮旬
          state.mapOrNull(
            success: (successState) {
              if (!isClosed) {
                emit(successState.copyWith(
                  ocrStatus: JobStatusEnum.Failed,
                  ocrErrorMessage: job.errorMessage ?? 'OCR processing failed.',
                ));
              }
            },
          );
        }
        // 如果状态是 Queued 或 Processing，则不执行任何操作，等待下一次轮询
      } catch (e) {
        timer.cancel(); // 轮询过程中发生错误，停止轮询
        state.mapOrNull(
          success: (successState) {
            if (!isClosed) {
              emit(successState.copyWith(
                ocrStatus: JobStatusEnum.Failed,
                ocrErrorMessage: 'Failed to poll job status: ${e.toString()}',
              ));
            }
          },
        );
      }
    });
  }

  // --- END: METHOD IMPLEMENTATIONS ---


  // --- START: OPTIMIZED SEARCH METHOD ---

  void search(String query) {
    state.mapOrNull(
      success: (successState) {
        if (query.isEmpty) {
          emit(successState.copyWith(
            searchQuery: '',
            highlightedBboxes: [],
          ));
          return;
        }

        final ocrResult = successState.page.currentVersion.ocrResult;
        if (ocrResult == null) return;

        final List<Bbox> highlights = [];
        
        final processedQuery = query.toLowerCase().replaceAll(' ', '');
        if (processedQuery.isEmpty) return;

        for (final line in ocrResult.lines) {
          final processedLineText = line.text.toLowerCase().replaceAll(' ', '');
          
          if (processedLineText.contains(processedQuery)) {
            for (final word in line.words) {
              highlights.add(word.bbox);
            }
          }
        }
        
        emit(successState.copyWith(
          searchQuery: query,
          highlightedBboxes: highlights,
        ));
      },
    );
  }
  // --- END: OPTIMIZED SEARCH METHOD ---
}