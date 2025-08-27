import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/core/api/api_client.dart';
import 'package:luna_arc_sync/data/models/search_models.dart';

abstract class ISearchRepository {
  Future<List<SearchResultItem>> search(String query);
}

@LazySingleton(as: ISearchRepository)
class SearchRepository implements ISearchRepository {
  final ApiClient _apiClient;

  SearchRepository(this._apiClient);

  @override
  Future<List<SearchResultItem>> search(String query) async {
    if (query.isEmpty) {
      return [];
    }
    try {
      final response = await _apiClient.dio.get(
        '/api/search',
        queryParameters: {'query': query},
      );
      final data = response.data as List;
      return data.map((item) => SearchResultItem.fromJson(item)).toList();
    } on DioException catch (e) {
      throw Exception('Search failed: ${e.message}');
    }
  }
}
