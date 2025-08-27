import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/core/api/api_client.dart';

abstract class IUserRepository {
  Future<int> getUserCount();
}

@LazySingleton(as: IUserRepository)
class UserRepository implements IUserRepository {
  // ignore: unused_field
  final ApiClient _apiClient;

  UserRepository(this._apiClient);

  @override
  Future<int> getUserCount() async {
    try {
      // final response = await _apiClient.dio.get('/users/count');
      // return response.data as int;
      return 1;
    } on DioException catch (e) {
      throw Exception('Failed to get user count: ${e.message}');
    }
  }
}
