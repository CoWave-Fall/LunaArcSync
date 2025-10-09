import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/core/api/api_client.dart';
import 'package:luna_arc_sync/data/models/page_models.dart' as page_models;
import 'package:luna_arc_sync/data/models/job_models.dart';

// 接口定义区
abstract class IPageRepository {
  // 返回分页结果
  Future<page_models.PaginatedResult<page_models.Page>> getPages({
    required int pageNumber,
    int pageSize = 10,
  });

  Future<page_models.Page> createPage({
    required String title,
    required Uint8List fileBytes,
    required String fileName,
  });

  Future<page_models.PageDetail> getPageById(String pageId);

  Future<JobQueuedResponse> startOcrJob(String versionId);

  Future<List<page_models.PageVersion>> getVersionHistory(String pageId);

  Future<void> revertToVersion({required String pageId, required String targetVersionId});

  // 返回一个 Page 列表，不是分页结果
  Future<List<page_models.Page>> getUnassignedPages();

  Future<void> deletePage(String pageId);

  Future<page_models.PageVersion> addVersionToPage({
    required String pageId,
    required Uint8List fileBytes,
    required String fileName,
  });

  Future<JobQueuedResponse> startStitchJob({
    required String pageId,
    required List<String> sourceVersionIds,
  });

  Future<void> updatePage(String pageId, Map<String, dynamic> data);

}


// 实现区
@LazySingleton(as: IPageRepository)
class PageRepository implements IPageRepository {
  final ApiClient _apiClient;

  PageRepository(this._apiClient);

  @override
  Future<page_models.PaginatedResult<page_models.Page>> getPages({
    required int pageNumber,
    int pageSize = 10,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '/api/pages',
        queryParameters: { 'pageNumber': pageNumber, 'pageSize': pageSize },
      );
      return page_models.PaginatedResult.fromJson(
        response.data,
        (json) => page_models.Page.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw Exception('Failed to load pages: ${e.message}');
    }
  }

  @override
  Future<page_models.Page> createPage({
    required String title,
    required Uint8List fileBytes,
    required String fileName,
  }) async {
    try {
      final formData = FormData.fromMap({
        'title': title,
        'file': MultipartFile.fromBytes(
          fileBytes,
          filename: fileName,
        ),
      });
      final response = await _apiClient.dio.post('/api/pages', data: formData);
      return page_models.Page.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to create page: ${e.message}');
    }
  }

  @override
  Future<page_models.PageDetail> getPageById(String pageId) async {
    try {
      final response = await _apiClient.dio.get('/api/pages/$pageId');
      return page_models.PageDetail.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Page not found.');
      }
      throw Exception('Failed to load page details: ${e.message}');
    }
  }

  @override
  Future<JobQueuedResponse> startOcrJob(String versionId) async {
    try {
      final response = await _apiClient.dio.post('/api/jobs/ocr/$versionId');
      return JobQueuedResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to start OCR job: ${e.message}');
    }
  }

  @override
  Future<List<page_models.PageVersion>> getVersionHistory(String pageId) async {
    try {
      final response = await _apiClient.dio.get('/api/pages/$pageId/versions');
      final List<dynamic> data = response.data as List;
      return data
          .map((json) => page_models.PageVersion.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to load version history: ${e.message}');
    }
  }
  
  @override
  Future<void> revertToVersion({required String pageId, required String targetVersionId}) async {
    try {
      final requestBody = {'targetVersionId': targetVersionId};
      await _apiClient.dio.post('/api/pages/$pageId/revert', data: requestBody);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception(e.response?.data['message'] ?? 'Invalid version specified.');
      }
      throw Exception('Failed to revert page version: ${e.message}');
    }
  }

  @override
  Future<List<page_models.Page>> getUnassignedPages() async {
    try {
      final response = await _apiClient.dio.get('/api/pages/unassigned');
      final List<dynamic> jsonList = response.data as List;
      return jsonList
          .map((json) => page_models.Page.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to load unassigned pages: ${e.message}');
    }
  }

  @override
  Future<void> deletePage(String pageId) async {
    try {
      await _apiClient.dio.delete('/api/pages/$pageId');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Page not found.');
      }
      throw Exception('An unexpected error occurred while deleting the page.');
    }
  }

  @override
  Future<page_models.PageVersion> addVersionToPage({
    required String pageId,
    required Uint8List fileBytes,
    required String fileName,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          fileBytes,
          filename: fileName,
        ),
      });
      final response = await _apiClient.dio.post('/api/pages/$pageId/versions', data: formData);
      return page_models.PageVersion.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to add version to page: ${e.message}');
    }
  }

  @override
  Future<JobQueuedResponse> startStitchJob({
    required String pageId,
    required List<String> sourceVersionIds,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/api/jobs/stitch/page/$pageId',
        data: {'sourceVersionIds': sourceVersionIds},
      );
      return JobQueuedResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to start stitch job: ${e.message}');
    }
  }

  @override
Future<void> updatePage(String pageId, Map<String, dynamic> data) async {
  try {
    await _apiClient.dio.put(
      '/api/pages/$pageId',
      data: data, // data 应该就是 {'title': 'new title'}
    );
  } catch (e) {
    // 错误处理
    rethrow;
  }



  
}

}