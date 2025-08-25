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
  }) {
    return _apiClient.getDocuments(
      pageNumber: pageNumber,
      sortBy: sortBy,
      tags: tags,
    );
  }

  @override
  Future<DocumentDetail> getDocumentById(String documentId) {
    return _apiClient.getDocumentById(documentId);
  }
  
  @override
  Future<Document> createDocument(String title) {
    return _apiClient.createDocument(title);
  }

  @override
  Future<void> updateDocument({
    required String documentId,
    required String title,
    required List<String> tags,
  }) {
    return _apiClient.updateDocument(documentId, {'title': title, 'tags': tags});
  }

  @override
  Future<void> deleteDocument(String documentId) {
    return _apiClient.deleteDocument(documentId);
  }

  @override
  Future<void> addPageToDocument({
    required String documentId,
    required String pageId,
  }) {
    return _apiClient.addPageToDocument(documentId, pageId);
  }

  @override
  Future<void> reorderPages(String documentId, List<Map<String, dynamic>> pageOrders) {
    return _apiClient.reorderPages(documentId, pageOrders);
  }

  @override
  Future<void> insertPage(String documentId, String pageId, int newOrder) {
    return _apiClient.insertPage(documentId, pageId, newOrder);
  }

  @override
  Future<List<String>> getAllTags() {
    return _apiClient.getAllTags();
  }

  @override
  Future<DocumentStats> getStats() {
    return _apiClient.getStats();
  }
}