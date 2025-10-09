import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:luna_arc_sync/data/models/job_models.dart';

@lazySingleton
class JobHistoryService {
  static const String _keyPrefix = 'job_history_';
  static const String _maxRecordsKey = 'job_history_max_records';
  static const String _pollingIntervalKey = 'job_polling_interval_seconds';
  static const int _defaultMaxRecords = 100;
  static const int _defaultPollingInterval = 5;

  // 获取最大记录数
  Future<int> getMaxRecords() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_maxRecordsKey) ?? _defaultMaxRecords;
  }

  // 设置最大记录数
  Future<void> setMaxRecords(int maxRecords) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_maxRecordsKey, maxRecords);
    // 如果当前记录数超过新的最大值，需要清理旧记录
    await _cleanupOldRecords();
  }

  // 获取轮询间隔
  Future<int> getPollingInterval() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_pollingIntervalKey) ?? _defaultPollingInterval;
  }

  // 设置轮询间隔
  Future<void> setPollingInterval(int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_pollingIntervalKey, seconds);
  }

  // 保存任务到历史记录
  Future<void> saveJob(Job job) async {
    final prefs = await SharedPreferences.getInstance();
    final maxRecords = await getMaxRecords();
    
    // 获取现有记录
    final existingJobs = await getAllJobs();
    
    // 检查是否已存在相同ID的任务
    final existingIndex = existingJobs.indexWhere((j) => j.jobId == job.jobId);
    
    if (existingIndex != -1) {
      // 更新现有记录
      existingJobs[existingIndex] = job;
    } else {
      // 添加新记录
      existingJobs.insert(0, job); // 新记录放在最前面
    }
    
    // 按提交时间排序（最新的在前）
    existingJobs.sort((a, b) => b.submittedAt.compareTo(a.submittedAt));
    
    // 限制记录数量
    final jobsToSave = existingJobs.take(maxRecords).toList();
    
    // 保存到本地存储
    final jobStrings = jobsToSave.map((job) => jsonEncode(job.toJson())).toList();
    await prefs.setStringList('${_keyPrefix}all', jobStrings);
  }

  // 获取所有历史任务
  Future<List<Job>> getAllJobs() async {
    final prefs = await SharedPreferences.getInstance();
    final jobStrings = prefs.getStringList('${_keyPrefix}all') ?? [];
    
    return jobStrings.map((jobString) {
      final jobJson = jsonDecode(jobString) as Map<String, dynamic>;
      return Job.fromJson(jobJson);
    }).toList();
  }

  // 获取已完成的任务
  Future<List<Job>> getCompletedJobs() async {
    final allJobs = await getAllJobs();
    return allJobs.where((job) {
      final status = job.status.toJobStatusEnum();
      return status == JobStatusEnum.Completed || 
             status == JobStatusEnum.Success ||
             status == JobStatusEnum.Failed ||
             status == JobStatusEnum.Error;
    }).toList();
  }

  // 获取活跃的任务（未完成）
  Future<List<Job>> getActiveJobs() async {
    final allJobs = await getAllJobs();
    return allJobs.where((job) {
      final status = job.status.toJobStatusEnum();
      return status == JobStatusEnum.Queued || 
             status == JobStatusEnum.Pending ||
             status == JobStatusEnum.Processing ||
             status == JobStatusEnum.Running;
    }).toList();
  }

  // 删除特定任务
  Future<void> deleteJob(String jobId) async {
    final prefs = await SharedPreferences.getInstance();
    final existingJobs = await getAllJobs();
    
    // 移除指定ID的任务
    existingJobs.removeWhere((job) => job.jobId == jobId);
    
    // 保存更新后的列表
    final jobStrings = existingJobs.map((job) => jsonEncode(job.toJson())).toList();
    await prefs.setStringList('${_keyPrefix}all', jobStrings);
  }

  // 清理旧记录
  Future<void> _cleanupOldRecords() async {
    final maxRecords = await getMaxRecords();
    final allJobs = await getAllJobs();
    
    if (allJobs.length > maxRecords) {
      // 按提交时间排序，保留最新的记录
      allJobs.sort((a, b) => b.submittedAt.compareTo(a.submittedAt));
      final jobsToKeep = allJobs.take(maxRecords).toList();
      
      final prefs = await SharedPreferences.getInstance();
      final jobStrings = jobsToKeep.map((job) => jsonEncode(job.toJson())).toList();
      await prefs.setStringList('${_keyPrefix}all', jobStrings);
    }
  }

  // 清空所有历史记录
  Future<void> clearAllJobs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('${_keyPrefix}all');
  }

  // 获取任务统计信息
  Future<Map<String, int>> getJobStats() async {
    final allJobs = await getAllJobs();
    final completedJobs = await getCompletedJobs();
    final activeJobs = await getActiveJobs();
    
    return {
      'total': allJobs.length,
      'completed': completedJobs.length,
      'active': activeJobs.length,
    };
  }
}
