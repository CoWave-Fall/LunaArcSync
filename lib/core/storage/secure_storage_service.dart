import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const _tokenKey = 'auth_token';
  static const _userIdKey = 'user_id';
  static const _expirationKey = 'auth_expiration';
  static const _serverUrlKey = 'server_url';
  static const _emailKey = 'user_email';
  static const _passwordKey = 'user_password';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  Future<void> saveExpiration(DateTime expiration) async {
    await _storage.write(key: _expirationKey, value: expiration.toIso8601String());
  }

  Future<DateTime?> getExpiration() async {
    final expirationString = await _storage.read(key: _expirationKey);
    if (expirationString == null) {
      return null;
    }
    return DateTime.tryParse(expirationString);
  }

  Future<void> deleteExpiration() async {
    await _storage.delete(key: _expirationKey);
  }

  Future<void> saveServerUrl(String url) async {
    await _storage.write(key: _serverUrlKey, value: url);
  }

  Future<String?> getServerUrl() async {
    return await _storage.read(key: _serverUrlKey);
  }

  Future<void> deleteServerUrl() async {
    await _storage.delete(key: _serverUrlKey);
  }

  Future<void> saveEmail(String email) async {
    await _storage.write(key: _emailKey, value: email);
  }

  Future<String?> getEmail() async {
    return await _storage.read(key: _emailKey);
  }

  Future<void> savePassword(String password) async {
    await _storage.write(key: _passwordKey, value: password);
  }

  Future<String?> getPassword() async {
    return await _storage.read(key: _passwordKey);
  }

  Future<void> deleteEmail() async {
    await _storage.delete(key: _emailKey);
  }

  Future<void> deletePassword() async {
    await _storage.delete(key: _passwordKey);
  }
}