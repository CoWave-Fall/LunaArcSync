import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/core/api/api_client.dart';
import 'package:luna_arc_sync/data/models/job_models.dart';

abstract class IJobRepository {
  Future<Job> getJobStatus(String jobId);
  Future<List<Job>> getJobs();
  Future<void> deleteJob(String jobId);
}

@LazySingleton(as: IJobRepository)
class JobRepository implements IJobRepository {
  final ApiClient _apiClient;
  JobRepository(this._apiClient);

  @override
  Future<Job> getJobStatus(String jobId) async {
    try {
      final response = await _apiClient.dio.get('/api/jobs/$jobId');
      return Job.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to get job status: ${e.message}');
    }
  }

  @override
  Future<List<Job>> getJobs() async {
    try {
      final response = await _apiClient.dio.get('/api/jobs/my-active');
      return (response.data as List).map((job) => Job.fromJson(job)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to get active jobs: ${e.message}');
    }
  }

  @override
  Future<void> deleteJob(String jobId) async {
    try {
      await _apiClient.dio.delete('/api/jobs/$jobId');
    } on DioException catch (e) {
      throw Exception('Failed to delete job: ${e.message}');
    }
  }
}