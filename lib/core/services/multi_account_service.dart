import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:luna_arc_sync/core/storage/secure_storage_service.dart';
import 'package:luna_arc_sync/data/models/auth_models.dart';

/// 多账号登录服务
/// 
/// 提供多账号登录管理功能，包括：
/// - 保存多个账号的登录信息
/// - 快速切换账号
/// - 账号信息管理
@lazySingleton
class MultiAccountService {
  final SecureStorageService _storageService;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  // 存储键前缀
  static const String _accountPrefix = 'multi_account_';
  static const String _currentAccountKey = 'current_account_id';
  static const String _accountsListKey = 'accounts_list';

  MultiAccountService(this._storageService);

  /// 保存账号信息
  /// 
  /// [accountId] 账号唯一标识
  /// [loginResponse] 登录响应信息
  /// [serverInfo] 服务器信息（可选）
  Future<void> saveAccount({
    required String accountId,
    required LoginResponse loginResponse,
    String? serverInfo,
  }) async {
    try {
      final accountData = {
        'accountId': accountId,
        'userId': loginResponse.userId,
        'email': loginResponse.email,
        'token': loginResponse.token,
        'role': loginResponse.role,
        'isAdmin': loginResponse.isAdmin,
        'serverInfo': serverInfo,
        'savedAt': DateTime.now().millisecondsSinceEpoch,
      };

      // 保存账号数据
      await _storage.write(
        key: '$_accountPrefix$accountId',
        value: accountData.toString(), // 这里应该序列化为JSON
      );

      // 更新账号列表
      await _addToAccountsList(accountId);

      debugPrint('🔐 MultiAccountService: Account saved - $accountId');
    } catch (e) {
      debugPrint('🔐 MultiAccountService: Failed to save account - $e');
      rethrow;
    }
  }

  /// 获取所有已保存的账号
  Future<List<SavedAccount>> getSavedAccounts() async {
    try {
      final accountsList = await _getAccountsList();
      final List<SavedAccount> accounts = [];

      for (final accountId in accountsList) {
        final accountData = await _getAccountData(accountId);
        if (accountData != null) {
          accounts.add(accountData);
        }
      }

      return accounts;
    } catch (e) {
      debugPrint('🔐 MultiAccountService: Failed to get saved accounts - $e');
      return [];
    }
  }

  /// 切换当前账号
  /// 
  /// [accountId] 要切换到的账号ID
  Future<void> switchToAccount(String accountId) async {
    try {
      final accountData = await _getAccountData(accountId);
      if (accountData == null) {
        throw Exception('Account not found: $accountId');
      }

      // 保存当前账号信息到主存储
      await _storageService.saveToken(accountData.token);
      await _storageService.saveUserId(accountData.userId);
      await _storageService.saveUserRole(accountData.role);
      await _storageService.saveIsAdmin(accountData.isAdmin);
      await _storageService.saveEmail(accountData.email);

      // 更新当前账号ID
      await _storage.write(key: _currentAccountKey, value: accountId);

      debugPrint('🔐 MultiAccountService: Switched to account - $accountId');
    } catch (e) {
      debugPrint('🔐 MultiAccountService: Failed to switch account - $e');
      rethrow;
    }
  }

  /// 获取当前活跃账号
  Future<SavedAccount?> getCurrentAccount() async {
    try {
      final currentAccountId = await _storage.read(key: _currentAccountKey);
      if (currentAccountId == null) {
        return null;
      }

      return await _getAccountData(currentAccountId);
    } catch (e) {
      debugPrint('🔐 MultiAccountService: Failed to get current account - $e');
      return null;
    }
  }

  /// 删除账号
  /// 
  /// [accountId] 要删除的账号ID
  Future<void> deleteAccount(String accountId) async {
    try {
      // 删除账号数据
      await _storage.delete(key: '$_accountPrefix$accountId');
      
      // 从账号列表中移除
      await _removeFromAccountsList(accountId);

      // 如果删除的是当前账号，清除当前账号信息
      final currentAccountId = await _storage.read(key: _currentAccountKey);
      if (currentAccountId == accountId) {
        await _storage.delete(key: _currentAccountKey);
      }

      debugPrint('🔐 MultiAccountService: Account deleted - $accountId');
    } catch (e) {
      debugPrint('🔐 MultiAccountService: Failed to delete account - $e');
      rethrow;
    }
  }

  /// 检查是否有多个账号
  Future<bool> hasMultipleAccounts() async {
    try {
      final accounts = await getSavedAccounts();
      return accounts.length > 1;
    } catch (e) {
      debugPrint('🔐 MultiAccountService: Failed to check multiple accounts - $e');
      return false;
    }
  }

  /// 获取账号数量
  Future<int> getAccountCount() async {
    try {
      final accounts = await getSavedAccounts();
      return accounts.length;
    } catch (e) {
      debugPrint('🔐 MultiAccountService: Failed to get account count - $e');
      return 0;
    }
  }

  /// 清除所有多账号数据
  Future<void> clearAllAccounts() async {
    try {
      final accountsList = await _getAccountsList();
      
      // 删除所有账号数据
      for (final accountId in accountsList) {
        await _storage.delete(key: '$_accountPrefix$accountId');
      }
      
      // 清除账号列表和当前账号
      await _storage.delete(key: _accountsListKey);
      await _storage.delete(key: _currentAccountKey);

      debugPrint('🔐 MultiAccountService: All accounts cleared');
    } catch (e) {
      debugPrint('🔐 MultiAccountService: Failed to clear all accounts - $e');
      rethrow;
    }
  }

  /// 更新账号信息
  /// 
  /// [accountId] 账号ID
  /// [updates] 要更新的信息
  Future<void> updateAccount(String accountId, Map<String, dynamic> updates) async {
    try {
      final accountData = await _getAccountData(accountId);
      if (accountData == null) {
        throw Exception('Account not found: $accountId');
      }

      // 合并更新数据
      final updatedData = {
        'accountId': accountData.accountId,
        'userId': accountData.userId,
        'email': accountData.email,
        'token': accountData.token,
        'role': accountData.role,
        'isAdmin': accountData.isAdmin,
        'serverInfo': accountData.serverInfo,
        'savedAt': accountData.savedAt,
        ...updates,
      };

      // 保存更新后的数据
      await _storage.write(
        key: '$_accountPrefix$accountId',
        value: updatedData.toString(), // 这里应该序列化为JSON
      );

      debugPrint('🔐 MultiAccountService: Account updated - $accountId');
    } catch (e) {
      debugPrint('🔐 MultiAccountService: Failed to update account - $e');
      rethrow;
    }
  }

  /// 获取账号列表
  Future<List<String>> _getAccountsList() async {
    try {
      final accountsListStr = await _storage.read(key: _accountsListKey);
      if (accountsListStr == null || accountsListStr.isEmpty) {
        return [];
      }
      
      // 这里应该解析JSON数组
      // 暂时返回空列表
      return [];
    } catch (e) {
      debugPrint('🔐 MultiAccountService: Failed to get accounts list - $e');
      return [];
    }
  }

  /// 添加到账号列表
  Future<void> _addToAccountsList(String accountId) async {
    try {
      final accountsList = await _getAccountsList();
      if (!accountsList.contains(accountId)) {
        accountsList.add(accountId);
        // 这里应该保存为JSON数组
        await _storage.write(key: _accountsListKey, value: accountsList.toString());
      }
    } catch (e) {
      debugPrint('🔐 MultiAccountService: Failed to add to accounts list - $e');
    }
  }

  /// 从账号列表中移除
  Future<void> _removeFromAccountsList(String accountId) async {
    try {
      final accountsList = await _getAccountsList();
      accountsList.remove(accountId);
      // 这里应该保存为JSON数组
      await _storage.write(key: _accountsListKey, value: accountsList.toString());
    } catch (e) {
      debugPrint('🔐 MultiAccountService: Failed to remove from accounts list - $e');
    }
  }

  /// 获取账号数据
  Future<SavedAccount?> _getAccountData(String accountId) async {
    try {
      final accountDataStr = await _storage.read(key: '$_accountPrefix$accountId');
      if (accountDataStr == null || accountDataStr.isEmpty) {
        return null;
      }

      // 这里应该解析JSON并创建SavedAccount对象
      // 暂时返回null
      return null;
    } catch (e) {
      debugPrint('🔐 MultiAccountService: Failed to get account data - $e');
      return null;
    }
  }
}

/// 已保存的账号信息
class SavedAccount {
  final String accountId;
  final String userId;
  final String email;
  final String token;
  final String role;
  final bool isAdmin;
  final String? serverInfo;
  final DateTime savedAt;

  const SavedAccount({
    required this.accountId,
    required this.userId,
    required this.email,
    required this.token,
    required this.role,
    required this.isAdmin,
    this.serverInfo,
    required this.savedAt,
  });

  /// 获取显示名称
  String get displayName {
    // 从邮箱中提取用户名部分
    final emailParts = email.split('@');
    return emailParts.isNotEmpty ? emailParts[0] : email;
  }

  /// 获取服务器信息显示
  String get serverDisplay {
    return serverInfo ?? '默认服务器';
  }

  /// 是否为管理员
  bool get isAdminUser => isAdmin;

  /// 账号状态描述
  String get statusDescription {
    if (isAdmin) {
      return '管理员';
    }
    return '普通用户';
  }
}
