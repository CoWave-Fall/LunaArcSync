import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/core/api/api_client.dart';
import 'package:luna_arc_sync/data/models/job_models.dart';

abstract class IJobRepository {
  Future<Job> getJobStatus(String jobId);
}

@LazySingleton(as: IJobRepository)
class JobRepository implements IJobRepository {
  final ApiClient _apiClient;
  JobRepository(this._apiClient);

  @override
  Future<Job> getJobStatus(String jobId) async {
    try {
      final response = await _apiClient.dio.get('/jobs/$jobId');
      return Job.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to get job status: ${e.message}');
    }
  }
}