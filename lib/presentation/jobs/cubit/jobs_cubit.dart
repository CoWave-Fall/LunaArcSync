import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/core/storage/job_history_service.dart';
import 'package:luna_arc_sync/core/storage/secure_storage_service.dart';
import 'package:luna_arc_sync/data/models/job_models.dart';
import 'package:luna_arc_sync/data/repositories/job_repository.dart';
import 'package:luna_arc_sync/presentation/jobs/cubit/jobs_state.dart';
import 'package:flutter/widgets.dart';

@injectable
class JobsCubit extends Cubit<JobsState> {
  final IJobRepository _jobRepository;
  final JobHistoryService _jobHistoryService;
  final SecureStorageService _storageService;
  Timer? _timer;
  List<Job> _lastKnownJobs = [];
  bool _isUpdating = false;
  int _pollingIntervalSeconds = 5; // 默认5秒
  AppLifecycleState _currentLifecycleState = AppLifecycleState.resumed;
  JobsCubit(this._jobRepository, this._jobHistoryService, this._storageService) : super(const JobsState.initial()) {
    _loadPollingInterval();
    _setupLifecycleListener();
  }

  Future<void> _loadPollingInterval() async {
    _pollingIntervalSeconds = await _jobHistoryService.getPollingInterval();


  }
  void _setupLifecycleListener() {
    // 使用WidgetsBindingObserver来监听生命周期变化
    WidgetsBinding.instance.addObserver(_LifecycleObserver(this));


    
  }

  /// 根据应用状态调整轮询频率
  void _adjustPollingFrequency() {
    if (_timer == null || !_timer!.isActive) return;

    final newInterval = _getPollingInterval();
    if (newInterval != _pollingIntervalSeconds) {
      debugPrint('🔍 JobsCubit: 调整轮询频率 - 状态: $_currentLifecycleState, 间隔: $newInterval秒');
      _pollingIntervalSeconds = newInterval;
      startPolling(); // 重新启动轮询
    }
  }

  /// 根据应用状态获取轮询间隔
  int _getPollingInterval() {
    switch (_currentLifecycleState) {
      case AppLifecycleState.resumed:
        return 5; // 前台活跃时5秒
      case AppLifecycleState.inactive:
        return 15; // 非活跃时15秒
      case AppLifecycleState.paused:
        return 60; // 后台时60秒
      case AppLifecycleState.detached:
        return 300; // 分离时5分钟
      case AppLifecycleState.hidden:
        return 30; // 隐藏时30秒
    }
  }

  Future<bool> _isAuthenticated() async {
    final token = await _storageService.getToken();
    final userId = await _storageService.getUserId();
    return token != null && token.isNotEmpty && userId != null && userId.isNotEmpty;
  }

  Future<void> fetchJobs({bool forceUpdate = false}) async {
    if (_isUpdating && !forceUpdate) return;
    
    // 检查是否已认证，如果未认证则停止轮询
    final isAuth = await _isAuthenticated();
    if (!isAuth) {
      debugPrint('🔍 JobsCubit: 用户未认证，停止job刷新');
      stopPolling();
      return;
    }
    
    _isUpdating = true;
    
    // 只有在强制更新或首次加载时才显示加载状态
    if ((forceUpdate || _lastKnownJobs.isEmpty) && !isClosed) {
      emit(const JobsState.loading());
    }
    
    try {
      // 获取服务器上的活跃任务
      final activeJobs = await _jobRepository.getJobs();
      
      // 保存到本地历史记录（即使为空数组也要处理）
      for (final job in activeJobs) {
        await _jobHistoryService.saveJob(job);
      }
      
      // 获取本地所有任务（包括已完成的）
      final allJobs = await _jobHistoryService.getAllJobs();
      
      // 比较是否有变化
      final hasChanged = _hasJobsChanged(allJobs);
      
      // 如果是第一次加载、有变化、或者强制更新，都要更新UI
      if (hasChanged || _lastKnownJobs.isEmpty || forceUpdate) {
        // 检查状态变化的任务
        final statusChangedJobs = _getStatusChangedJobs(allJobs);
        
        _lastKnownJobs = List.from(allJobs);
        if (!isClosed) {
          emit(JobsState.success(allJobs));
          
          // 发出状态变化通知
          if (statusChangedJobs.isNotEmpty) {
            emit(JobsState.jobStatusChanged(statusChangedJobs));
          }
        }
      }
    } catch (e) {
      // 如果服务器请求失败，尝试从本地获取
      try {
        final localJobs = await _jobHistoryService.getAllJobs();
        if (_hasJobsChanged(localJobs) || _lastKnownJobs.isEmpty || forceUpdate) {
          _lastKnownJobs = List.from(localJobs);
          if (!isClosed) {
            emit(JobsState.success(localJobs));
          }
        }
      } catch (localError) {
        if ((forceUpdate || _lastKnownJobs.isEmpty) && !isClosed) {
          emit(JobsState.failure(e.toString()));
        }
      }
    } finally {
      _isUpdating = false;
    }
  }

  bool _hasJobsChanged(List<Job> newJobs) {
    if (_lastKnownJobs.length != newJobs.length) {
      return true;
    }
    
    // 比较每个任务的状态和关键字段
    for (int i = 0; i < newJobs.length; i++) {
      final newJob = newJobs[i];
      final oldJob = _lastKnownJobs[i];
      
      if (newJob.jobId != oldJob.jobId ||
          newJob.status != oldJob.status ||
          newJob.startedAt != oldJob.startedAt ||
          newJob.completedAt != oldJob.completedAt ||
          newJob.errorMessage != oldJob.errorMessage ||
          newJob.resultUrl != oldJob.resultUrl) {
        return true;
      }
    }
    
    return false;
  }

  // 检查是否有任务状态发生变化，用于通知
  List<Job> _getStatusChangedJobs(List<Job> newJobs) {
    final changedJobs = <Job>[];
    
    for (final newJob in newJobs) {
      final oldJob = _lastKnownJobs.firstWhere(
        (job) => job.jobId == newJob.jobId,
        orElse: () => newJob, // 如果是新任务，也视为状态变化
      );
      
      // 检查状态是否发生变化
      if (oldJob.status != newJob.status) {
        changedJobs.add(newJob);
      }
    }
    
    return changedJobs;
  }

  void startPolling() async {
    // 检查认证状态，如果未认证则不开始轮询
    final isAuth = await _isAuthenticated();
    if (!isAuth) {
      debugPrint('🔍 JobsCubit: 用户未认证，不开始job轮询');
      return;
    }
    
    _timer?.cancel();
    _timer = Timer.periodic(
      Duration(seconds: _pollingIntervalSeconds), 
      (_) => fetchJobs()
    );
    fetchJobs(); // Initial fetch
  }

  Future<void> updatePollingInterval(int seconds) async {
    _pollingIntervalSeconds = seconds;
    await _jobHistoryService.setPollingInterval(seconds);
    // 如果正在轮询，重新启动以应用新间隔
    if (_timer != null && _timer!.isActive) {
      startPolling();
    }
  }

  int get pollingIntervalSeconds => _pollingIntervalSeconds;

  Future<void> deleteJob(String jobId) async {
    try {
      // 从服务器删除
      await _jobRepository.deleteJob(jobId);
      
      // 从本地存储删除
      await _jobHistoryService.deleteJob(jobId);
      
      // 刷新任务列表
      await fetchJobs(forceUpdate: true);
    } catch (e) {
      // 检查是否是服务器限制错误
      final errorMessage = e.toString();
      if (!isClosed) {
        if (errorMessage.contains('Cannot delete queued or processing jobs')) {
          emit(JobsState.failure('Cannot delete jobs that are queued or processing. Please wait for them to complete.'));
        } else {
          emit(JobsState.failure('Failed to delete job: $errorMessage'));
        }
      }
    }
  }

  Future<void> loadLocalJobs() async {
    if (!isClosed) {
      emit(const JobsState.loading());
    }
    try {
      final localJobs = await _jobHistoryService.getAllJobs();
      if (!isClosed) {
        emit(JobsState.success(localJobs));
      }
    } catch (e) {
      if (!isClosed) {
        emit(JobsState.failure(e.toString()));
      }
    }
  }

  Future<Map<String, int>> getJobStats() async {
    return await _jobHistoryService.getJobStats();
  }

  void stopPolling() {
    _timer?.cancel();
  }

  @override
  Future<void> close() {
    stopPolling();
    WidgetsBinding.instance.removeObserver(_LifecycleObserver(this));
    return super.close();
  }
}

class _LifecycleObserver extends WidgetsBindingObserver {
  final JobsCubit _cubit;

  _LifecycleObserver(this._cubit);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _cubit._currentLifecycleState = state;
    _cubit._adjustPollingFrequency();
  }
}
