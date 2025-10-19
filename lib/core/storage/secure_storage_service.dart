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
  static const _userRoleKey = 'user_role';
  static const _isAdminKey = 'is_admin';

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
    await _storage.write(key: _expirationKey, value: expiration.millisecondsSinceEpoch.toString());
  }

  Future<DateTime?> getExpiration() async {
    final expirationString = await _storage.read(key: _expirationKey);
    if (expirationString == null) {
      return null;
    }
    final timestamp = int.tryParse(expirationString);
    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    // 兼容旧的 ISO8601 格式
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

  Future<void> deleteUserId() async {
    await _storage.delete(key: _userIdKey);
  }

  Future<void> saveUserRole(String role) async {
    await _storage.write(key: _userRoleKey, value: role);
  }

  Future<String?> getUserRole() async {
    return await _storage.read(key: _userRoleKey);
  }

  Future<void> deleteUserRole() async {
    await _storage.delete(key: _userRoleKey);
  }

  Future<void> saveIsAdmin(bool isAdmin) async {
    await _storage.write(key: _isAdminKey, value: isAdmin.toString());
  }

  Future<bool?> getIsAdmin() async {
    final isAdminString = await _storage.read(key: _isAdminKey);
    if (isAdminString == null) {
      return null;
    }
    return isAdminString.toLowerCase() == 'true';
  }

  Future<void> deleteIsAdmin() async {
    await _storage.delete(key: _isAdminKey);
  }

  /// 清除所有认证相关的数据
  Future<void> clearAllAuthData() async {
    await Future.wait([
      deleteToken(),
      deleteUserId(),
      deleteExpiration(),
      deleteEmail(),
      deletePassword(),
      deleteUserRole(),
      deleteIsAdmin(),
    ]);
  }

  /// 检查是否有有效的认证会话
  Future<bool> hasValidSession() async {
    final token = await getToken();
    final userId = await getUserId();
    
    if (token == null || token.isEmpty || userId == null || userId.isEmpty) {
      return false;
    }

    // 检查token是否过期
    final expiration = await getExpiration();
    if (expiration != null && expiration.isBefore(DateTime.now())) {
      return false;
    }

    return true;
  }
}