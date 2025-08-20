import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/core/api/api_client.dart';
import 'package:luna_arc_sync/data/models/document_models.dart' as doc_models;
import 'package:luna_arc_sync/data/models/page_models.dart' as page_models;

// 定义新的抽象接口 IDocumentRepository
abstract class IDocumentRepository {
  Future<page_models.PaginatedResult<doc_models.Document>> getDocuments({
    required int pageNumber,
    int pageSize = 10,
  });

  Future<doc_models.Document> createDocument({
    required String title,
    required List<String> tags,
  });

  Future<doc_models.DocumentDetail> getDocumentById(String documentId);

  Future<void> updateDocument({
    required String documentId,
    required String title,
    required List<String> tags,
  });

  Future<void> addPageToDocument({
    required String documentId,
    required String pageId,
  });

  Future<void> removePageFromDocument({
    required String documentId,
    required String pageId,
  });

  Future<void> deleteDocument(String documentId);

  Future<void> reorderPages(String documentId, List<Map<String, dynamic>> pageOrders);

  /// 使用 "insert" 模式将一个 Page 添加到文档的指定顺序
  Future<void> insertPage(String documentId, String pageId, int newOrder);

  Future<doc_models.DocumentStats> getStats();
}

// 实现具体的 DocumentRepository
@LazySingleton(as: IDocumentRepository)
class DocumentRepository implements IDocumentRepository {
  final ApiClient _apiClient;

  DocumentRepository(this._apiClient);

  @override
  Future<page_models.PaginatedResult<doc_models.Document>> getDocuments({
    required int pageNumber,
    int pageSize = 10,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '/documents',
        queryParameters: {
          'pageNumber': pageNumber,
          'pageSize': pageSize,
        },
      );
      return page_models.PaginatedResult.fromJson(
        response.data,
        (json) => doc_models.Document.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw Exception('Failed to load documents: ${e.message}');
    }
  }

  @override
  Future<doc_models.Document> createDocument({
    required String title,
    required List<String> tags,
  }) async {
    try {
      final requestBody = {
        'title': title,
        'tags': tags,
      };

      final response = await _apiClient.dio.post(
        '/documents',
        data: requestBody,
      );

      return doc_models.Document.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to create document: ${e.message}');
    }
  }

  @override
  Future<doc_models.DocumentDetail> getDocumentById(String documentId) async {
    try {
      final response = await _apiClient.dio.get('/documents/$documentId');
      return doc_models.DocumentDetail.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Document not found.');
      }
      throw Exception('Failed to load document details: ${e.message}');
    }
  }

  @override
  Future<void> updateDocument({
    required String documentId,
    required String title,
    required List<String> tags,
  }) async {
    try {
      final requestBody = {
        'title': title,
        'tags': tags,
      };

      // 修复：将 .get 修改为 .put
      await _apiClient.dio.put(
        '/documents/$documentId', // 使用 PUT 方法，并传入 documentId
        data: requestBody,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Document not found for update.');
      }
      throw Exception('Failed to update document: ${e.message}');
    }
  }

  @override
  Future<void> addPageToDocument({
    required String documentId,
    required String pageId,
  }) async {
    try {
      final requestBody = {
        'pageId': pageId,
      };

      await _apiClient.dio.post(
        '/documents/$documentId/pages', // 使用 POST 方法
        data: requestBody,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception(e.response?.data?.toString() ?? 'Failed to add page to document.');
      }
      throw Exception('An unexpected error occurred while adding the page.');
    }
  }

  @override
  Future<void> removePageFromDocument({
    required String documentId,
    required String pageId,
  }) async {
    try {
      await _apiClient.dio.delete(
        '/documents/$documentId/pages/$pageId',
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Page or document not found.');
      }
      throw Exception('An unexpected error occurred while removing the page.');
    }
  }

  @override
  Future<void> deleteDocument(String documentId) async {
    try {
      await _apiClient.dio.delete('/documents/$documentId');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Document not found.');
      }
      throw Exception('An unexpected error occurred while deleting the document.');
    }
  }

  @override
  Future<void> reorderPages(String documentId, List<Map<String, dynamic>> pageOrders) async {
    try {
      await _apiClient.dio.post(
        '/api/documents/$documentId/pages/reorder/set',
        data: {'pageOrders': pageOrders},
      );
    } on DioException catch (e) {
      // 捕获 DioException 以提供更具体的错误信息
      throw Exception('Failed to reorder pages: ${e.message}');
    } catch (e) {
      // 捕获其他未知错误
      rethrow;
    }
  }

  @override
  Future<void> insertPage(String documentId, String pageId, int newOrder) async {
    try {
      await _apiClient.dio.post(
        '/api/documents/$documentId/pages/reorder/insert',
        data: {'pageId': pageId, 'newOrder': newOrder},
      );
    } on DioException catch (e) {
      // 捕获 DioException 以提供更具体的错误信息
      throw Exception('Failed to insert page: ${e.message}');
    } catch (e) {
      // 捕获其他未知错误
      rethrow;
    }
  }

  @override
  Future<doc_models.DocumentStats> getStats() async {
    try {
      final response = await _apiClient.dio.get('/Documents/stats');
      return doc_models.DocumentStats.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to get document stats: ${e.message}');
    }
  }
}