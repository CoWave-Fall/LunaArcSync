import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/core/di/injection.dart'; // Import getIt
import 'package:luna_arc_sync/data/models/document_models.dart'; // New import
import 'auth_interceptor.dart'; // Import the interceptor

@lazySingleton
class ApiClient {
  final Dio _dio;

  ApiClient()
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://localhost:7135/api',
          connectTimeout: const Duration(milliseconds: 5000),
          receiveTimeout: const Duration(milliseconds: 3000),
        )) {
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
    // Add our custom AuthInterceptor
    // We resolve it from getIt because it has its own dependencies
    _dio.interceptors.add(getIt<AuthInterceptor>());
  }

  Dio get dio => _dio;

  // --- Document Endpoints ---

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
      queryParams['tags'] = tags.join(','); // API expects comma-separated tags
    }
    final response = await _dio.get(
      '/documents',
      queryParameters: queryParams,
    );
    // PagedResult.fromJson needs a function to deserialize its generic type T
    return PagedResult.fromJson(response.data, (json) => Document.fromJson(json as Map<String, dynamic>));
  }

  Future<DocumentDetail> getDocumentById(String documentId) async {
    final response = await _dio.get('/documents/$documentId');
    return DocumentDetail.fromJson(response.data);
  }

  Future<Document> createDocument(String title) async {
    final response = await _dio.post(
      '/documents',
      data: {'title': title},
    );
    return Document.fromJson(response.data);
  }

  Future<void> updateDocument(String documentId, Map<String, dynamic> data) async {
    await _dio.put('/documents/$documentId', data: data);
  }

  Future<void> deleteDocument(String documentId) async {
    await _dio.delete('/documents/$documentId');
  }

  Future<void> addPageToDocument(String documentId, String pageId) async {
    await _dio.post(
      '/documents/$documentId/pages',
      data: {'pageId': pageId},
    );
  }

  Future<void> reorderPages(String documentId, List<Map<String, dynamic>> pageOrders) async {
    await _dio.post(
      '/documents/$documentId/pages/reorder/set',
      data: {'pageOrders': pageOrders},
    );
  }

  Future<void> insertPage(String documentId, String pageId, int newOrder) async {
    await _dio.post(
      '/documents/$documentId/pages/reorder/insert',
      data: {'pageId': pageId, 'newOrder': newOrder},
    );
  }

  Future<List<String>> getAllTags() async {
    final response = await _dio.get('/documents/tags');
    // Assuming the API returns a List<String> directly
    return List<String>.from(response.data);
  }

  Future<DocumentStats> getStats() async {
    final response = await _dio.get('/documents/stats');
    return DocumentStats.fromJson(response.data);
  }
}
