import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/core/api/api_client.dart';
import 'package:luna_arc_sync/core/storage/secure_storage_service.dart';
import 'package:luna_arc_sync/data/models/auth_models.dart';
import 'package:flutter/foundation.dart';

// Abstract definition of the repository
abstract class IAuthRepository {
  Future<LoginResponse> login(String email, String password);
  Future<void> register(String email, String password, String confirmPassword);
  Future<void> logout();
}

// Concrete implementation of the repository
@LazySingleton(as: IAuthRepository) // Register this implementation for the IAuthRepository interface
class AuthRepository implements IAuthRepository {
  final ApiClient _apiClient;
  final SecureStorageService _storageService;

  AuthRepository(this._apiClient, this._storageService);

  @override
  Future<LoginResponse> login(String email, String password) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _apiClient.dio.post(
        '/api/accounts/login',
        data: request.toJson(),
      );

      final loginResponse = LoginResponse.fromJson(response.data);

      // After a successful login, save the token and user ID
      // await _storageService.saveToken(loginResponse.token);
      // await _storageService.saveUserId(loginResponse.userId);

      debugPrint('--- AuthRepository.login SUCCESS ---');
      if (loginResponse.token.isNotEmpty) {
        debugPrint('Token received from server. Length: ${loginResponse.token.length}');
        debugPrint('Token starts with: ${loginResponse.token.substring(0, 15)}...');
        
        debugPrint('Attempting to save token to secure storage...');
        await _storageService.saveToken(loginResponse.token);
        debugPrint('saveToken call completed.');

        // 立即回读一次，进行验证
        final storedToken = await _storageService.getToken();
        if (storedToken != null && storedToken == loginResponse.token) {
          debugPrint('VERIFICATION SUCCESS: Token read back from storage matches the received token.');
        } else {
          debugPrint('VERIFICATION FAILED: Token read back from storage is null or does not match!');
        }

      } else {
        debugPrint('Token received from server is EMPTY!');
      }
      
      await _storageService.saveUserId(loginResponse.userId);
      debugPrint('User ID saved: ${loginResponse.userId}');
      debugPrint('------------------------------------');
      
      return loginResponse;

    } on DioException catch (e) {
      // Handle specific API errors, e.g., 401 Unauthorized
      if (e.response?.statusCode == 401) {
        throw Exception('Invalid email or password.');
      }
      // Handle other network errors
      throw Exception('Failed to connect to the server. Please try again.');
    }
  }

  @override
  Future<void> register(String email, String password, String confirmPassword) async {
     try {
      final request = RegisterRequest(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );
      await _apiClient.dio.post(
        '/api/accounts/register',
        data: request.toJson(),
      );
    } on DioException catch (e) {
       // Handle specific API errors, e.g., 400 Bad Request for email already exists
      if (e.response?.statusCode == 400) {
        throw Exception(e.response?.data['message'] ?? 'Registration failed.');
      }
      throw Exception('Failed to connect to the server. Please try again.');
    }
  }

  @override
  Future<void> logout() async {
    // Clear token, userId and expiration from secure storage
    await _storageService.deleteToken();
    await _storageService.deleteUserId();
    await _storageService.deleteExpiration();
    // Here you might also call a backend logout endpoint if it exists
  }
}
