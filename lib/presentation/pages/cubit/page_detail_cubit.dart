import 'dart:async';
import 'package:flutter/foundation.dart';
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

  Future<String> startOcrJob() async {
    final result = await state.mapOrNull(
      success: (successState) async {
        // 防止在处理中时重复点击
        if (successState.ocrStatus == JobStatusEnum.Processing) {
          throw Exception('OCR任务正在处理中，请勿重复提交');
        }

        final currentVersion = successState.page.currentVersion;
        if (currentVersion == null) {
          throw Exception('无法启动OCR：没有可用的当前版本');
        }

        try {
          final response = await _pageRepository.startOcrJob(currentVersion.versionId);
          
          // 更新状态为处理中
          emit(successState.copyWith(
            ocrStatus: JobStatusEnum.Processing,
            ocrErrorMessage: null,
          ));
          
          // 开始轮询OCR任务状态
          _startOcrJobPolling(response.jobId);
          
          return response.jobId;
        } catch (e) {
          rethrow;
        }
      },
    );
    
    if (result == null) {
      throw Exception('页面未加载，无法启动OCR任务');
    }
    
    return result;
  }

  void _startOcrJobPolling(String jobId) {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      try {
        // 使用mapOrNull来处理success状态
        await state.mapOrNull(
          success: (successState) async {
            // 检查任务状态
            final job = await _jobRepository.getJobStatus(jobId);
            final jobStatus = job.status.toJobStatusEnum();
            
            if (jobStatus == JobStatusEnum.Completed) {
              timer.cancel();
              // 标记OCR已完成（触发完成通知）
              emit(successState.copyWith(
                ocrStatus: JobStatusEnum.Completed,
                ocrErrorMessage: null,
              ));
              // 重新获取页面数据以获取OCR结果
              await fetchPage(successState.page.pageId);
            } else if (jobStatus == JobStatusEnum.Failed) {
              timer.cancel();
              emit(successState.copyWith(
                ocrStatus: JobStatusEnum.Failed,
                ocrErrorMessage: job.errorMessage ?? 'OCR任务失败',
              ));
            }
          },
        );
      } catch (e) {
        // 轮询出错时继续轮询，但记录错误
        if (kDebugMode) {
          print('OCR轮询出错: $e');
        }
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

        final currentVersion = successState.page.currentVersion;
        if (currentVersion == null) return;

        final ocrResult = currentVersion.ocrResult;
        if (ocrResult == null) return;

        final List<Bbox> highlights = [];
        final searchTerms = _extractSearchTerms(query);
        if (searchTerms.isEmpty) return;

        for (final line in ocrResult.lines) {
          final lineText = line.text.toLowerCase();
          
          // 检查是否包含任何搜索词
          bool hasMatch = false;
          for (final term in searchTerms) {
            if (lineText.contains(term.toLowerCase())) {
              hasMatch = true;
              break;
            }
          }
          
          if (hasMatch) {
            // 添加整行的边界框用于高亮显示
            highlights.add(line.bbox);
            
            // 也可以添加匹配的单词边界框
            for (final word in line.words) {
              final wordText = word.text.toLowerCase();
              for (final term in searchTerms) {
                if (wordText.contains(term.toLowerCase())) {
                  highlights.add(word.bbox);
                }
              }
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

  List<String> _extractSearchTerms(String query) {
    // 提取搜索词，支持多个词搜索
    final terms = query.trim().split(RegExp(r'\s+'));
    return terms.where((term) => term.isNotEmpty).toList();
  }
  // --- END: OPTIMIZED SEARCH METHOD ---
}