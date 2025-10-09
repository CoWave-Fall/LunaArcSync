
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/core/api/api_client.dart';
import 'package:luna_arc_sync/data/models/document_models.dart';
import 'package:luna_arc_sync/data/models/page_models.dart' as page_models;

abstract class IDocumentRepository {
  Future<PagedResult<Document>> getDocuments({
    required int pageNumber,
    String? sortBy,
    List<String>? tags,
  });
  Future<DocumentDetail> getDocumentById(String documentId);
  Future<page_models.PaginatedResult<page_models.Page>> getPagesForDocument(String documentId, {required int page, required int limit});
  Future<Document> createDocument(String title);
  Future<void> updateDocument({
    required String documentId,
    required String title,
    required List<String> tags,
  });
  Future<void> deleteDocument(String documentId);
  Future<void> addPageToDocument({
    required String documentId,
    required String pageId,
  });
  Future<void> reorderPages(String documentId, List<Map<String, dynamic>> pageOrders);
  Future<void> insertPage(String documentId, String pageId, int newOrder);
  Future<List<String>> getAllTags();
  Future<DocumentStats> getStats();
  Future<void> createPagesFromPdf({
    required String documentId,
    required String filePath, // Changed from fileBytes
    required String fileName,
  });
  Future<String> startPdfExportJob(String documentId);
  Future<String> startBatchExportJob(List<String> documentIds);
}

@LazySingleton(as: IDocumentRepository)
class DocumentRepository implements IDocumentRepository {
  final ApiClient _apiClient;

  DocumentRepository(this._apiClient);

  @override
  Future<PagedResult<Document>> getDocuments({
    required int pageNumber,
    String? sortBy,
    List<String>? tags,
  }) async {
    final queryParams = <String, dynamic>{'pageNumber': pageNumber};
    if (sortBy != null) {
      queryParams['sortBy'] = sortBy;
    }
    if (tags != null && tags.isNotEmpty) {
      queryParams['tags'] = tags.join(',');
    }
    final response = await _apiClient.dio.get(
      '/api/documents',
      queryParameters: queryParams,
    );
    return PagedResult.fromJson(
        response.data, (json) => Document.fromJson(json as Map<String, dynamic>));
  }

  @override
  Future<DocumentDetail> getDocumentById(String documentId) async {
    final response = await _apiClient.dio.get('/api/documents/$documentId');
    return DocumentDetail.fromJson(response.data);
  }

  @override
  Future<page_models.PaginatedResult<page_models.Page>> getPagesForDocument(String documentId, {required int page, required int limit}) async {
    final response = await _apiClient.dio.get(
      '/api/documents/$documentId/pages',
      queryParameters: {'pageNumber': page, 'pageSize': limit}, // Match API doc parameters
      options: Options(headers: {'Cache-Control': 'no-cache'}),
    );
    return page_models.PaginatedResult.fromJson(
      response.data,
      (json) => page_models.Page.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<Document> createDocument(String title) async {
    final response = await _apiClient.dio.post(
      '/api/documents',
      data: {'title': title},
    );
    return Document.fromJson(response.data);
  }

  @override
  Future<void> updateDocument({
    required String documentId,
    required String title,
    required List<String> tags,
  }) async {
    await _apiClient.dio.put('/api/documents/$documentId', data: {'title': title, 'tags': tags});
  }

  @override
  Future<void> deleteDocument(String documentId) async {
    await _apiClient.dio.delete('/api/documents/$documentId');
  }

  @override
  Future<void> addPageToDocument({
    required String documentId,
    required String pageId,
  }) async {
    await _apiClient.dio.post(
      '/api/documents/$documentId/pages',
      data: {'pageId': pageId},
    );
  }

  @override
  Future<void> reorderPages(
      String documentId, List<Map<String, dynamic>> pageOrders) async {
    await _apiClient.dio.post(
      '/api/documents/$documentId/pages/reorder/set',
      data: {'pageOrders': pageOrders},
    );
  }

  @override
  Future<void> insertPage(String documentId, String pageId, int newOrder) async {
    await _apiClient.dio.post(
      '/api/documents/$documentId/pages/reorder/insert',
      data: {'pageId': pageId, 'newOrder': newOrder},
    );
  }

  @override
  Future<List<String>> getAllTags() async {
    final response = await _apiClient.dio.get('/api/documents/tags');
    return List<String>.from(response.data);
  }

  @override
  Future<DocumentStats> getStats() async {
    final response = await _apiClient.dio.get('/api/documents/stats');
    return DocumentStats.fromJson(response.data);
  }

  @override
  Future<void> createPagesFromPdf({
    required String documentId,
    required String filePath,
    required String fileName,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
    });
    await _apiClient.dio.post(
      '/api/documents/$documentId/pages/from-pdf',
      data: formData,
    );
  }

  @override
  Future<String> startPdfExportJob(String documentId) async {
    final response = await _apiClient.dio.post(
      '/api/documents/batch-export',
      data: {'documentIds': [documentId]},
    );
    // Assuming the backend returns a jobId directly in the response data
    return response.data['jobId'] as String;
  }

  @override
  Future<String> startBatchExportJob(List<String> documentIds) async {
    final response = await _apiClient.dio.post(
      '/api/documents/batch-export',
      data: {'documentIds': documentIds},
    );
    return response.data['jobId'] as String;
  }
}
