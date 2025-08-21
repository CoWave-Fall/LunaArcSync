// lib/data/repositories/document_repository.dart

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/core/api/api_client.dart';
import 'package:luna_arc_sync/data/models/document_models.dart' as doc_models;
import 'package:luna_arc_sync/data/models/page_models.dart' as page_models;
// 导入 state 文件以使用枚举
import 'package:luna_arc_sync/presentation/documents/cubit/document_list_state.dart';


// 定义新的抽象接口 IDocumentRepository
abstract class IDocumentRepository {
  // --- 1. 更新 getDocuments 签名 ---
  Future<page_models.PaginatedResult<doc_models.Document>> getDocuments({
    required int pageNumber,
    int pageSize = 10,
    SortBy sortBy = SortBy.updatedAt,
    SortOrder sortOrder = SortOrder.desc,
    List<String> filterTags = const [],
  });

  // ... 其他方法签名保持不变 ...
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

  Future<void> insertPage(String documentId, String pageId, int newOrder);

  Future<doc_models.DocumentStats> getStats();
}

// 实现具体的 DocumentRepository
@LazySingleton(as: IDocumentRepository)
class DocumentRepository implements IDocumentRepository {
  final ApiClient _apiClient;

  DocumentRepository(this._apiClient);

  @override
  // --- 2. 实现新的 getDocuments ---
  Future<page_models.PaginatedResult<doc_models.Document>> getDocuments({
    required int pageNumber,
    int pageSize = 10,
    SortBy sortBy = SortBy.updatedAt,
    SortOrder sortOrder = SortOrder.desc,
    List<String> filterTags = const [],
  }) async {
    try {
      // 构建查询参数
      final queryParameters = {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
        'sortBy': sortBy.name, // 使用枚举的名称，例如 'updatedAt'
        'sortOrder': sortOrder.name, // 'asc' or 'desc'
      };

      // 如果有标签过滤，则添加到查询中
      // Dio 会自动将 List 格式化为多个同名参数 (e.g., tags=work&tags=urgent)
      if (filterTags.isNotEmpty) {
        queryParameters['tags'] = filterTags;
      }
      
      final response = await _apiClient.dio.get(
        '/documents',
        queryParameters: queryParameters,
      );
      return page_models.PaginatedResult.fromJson(
        response.data,
        (json) => doc_models.Document.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw Exception('Failed to load documents: ${e.message}');
    }
  }

  // ... 其他方法的实现保持不变 ...
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

      await _apiClient.dio.put(
        '/documents/$documentId',
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
        '/documents/$documentId/pages',
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
      throw Exception('Failed to reorder pages: ${e.message}');
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
      throw Exception('Failed to insert page: ${e.message}');
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