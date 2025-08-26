import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/core/api/api_client.dart';
import 'package:luna_arc_sync/data/models/document_models.dart';

abstract class IDocumentRepository {
  Future<PagedResult<Document>> getDocuments({
    required int pageNumber,
    String? sortBy,
    List<String>? tags,
  });
  Future<DocumentDetail> getDocumentById(String documentId);
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
      '/documents',
      queryParameters: queryParams,
    );
    return PagedResult.fromJson(
        response.data, (json) => Document.fromJson(json as Map<String, dynamic>));
  }

  @override
  Future<DocumentDetail> getDocumentById(String documentId) async {
    final response = await _apiClient.dio.get('/documents/$documentId');
    return DocumentDetail.fromJson(response.data);
  }

  @override
  Future<Document> createDocument(String title) async {
    final response = await _apiClient.dio.post(
      '/documents',
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
    await _apiClient.dio.put('/documents/$documentId', data: {'title': title, 'tags': tags});
  }

  @override
  Future<void> deleteDocument(String documentId) async {
    await _apiClient.dio.delete('/documents/$documentId');
  }

  @override
  Future<void> addPageToDocument({
    required String documentId,
    required String pageId,
  }) async {
    await _apiClient.dio.post(
      '/documents/$documentId/pages',
      data: {'pageId': pageId},
    );
  }

  @override
  Future<void> reorderPages(
      String documentId, List<Map<String, dynamic>> pageOrders) async {
    await _apiClient.dio.post(
      '/documents/$documentId/pages/reorder/set',
      data: {'pageOrders': pageOrders},
    );
  }

  @override
  Future<void> insertPage(String documentId, String pageId, int newOrder) async {
    await _apiClient.dio.post(
      '/documents/$documentId/pages/reorder/insert',
      data: {'pageId': pageId, 'newOrder': newOrder},
    );
  }

  @override
  Future<List<String>> getAllTags() async {
    final response = await _apiClient.dio.get('/documents/tags');
    return List<String>.from(response.data);
  }

  @override
  Future<DocumentStats> getStats() async {
    final response = await _apiClient.dio.get('/documents/stats');
    return DocumentStats.fromJson(response.data);
  }
}