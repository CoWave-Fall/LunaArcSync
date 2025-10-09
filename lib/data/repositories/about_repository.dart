import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/core/api/api_client.dart';
import 'package:luna_arc_sync/data/models/about_models.dart';

abstract class IAboutRepository {
  Future<AboutResponse> getAbout();
}

@LazySingleton(as: IAboutRepository)
class AboutRepository implements IAboutRepository {
  final ApiClient _apiClient;

  AboutRepository(this._apiClient);

  @override
  Future<AboutResponse> getAbout() async {
    final response = await _apiClient.dio.get('/api/about');
    return AboutResponse.fromJson(response.data);
  }
}
