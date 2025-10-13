import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:luna_arc_sync/data/models/about_models.dart';

@lazySingleton
class ServerCacheService {
  static const String _serverCachePrefix = 'server_cache_';
  static const String _serverListKey = 'server_list';
  static const int _maxCacheSize = 20; // 最大缓存服务器数量

  // 生成服务器唯一标识符
  // 优先使用服务器返回的 serverId，如果没有则基于 URL 生成
  static String getServerId(AboutResponse aboutResponse, String serverUrl) {
    // 1. 优先使用服务器返回的 serverId
    if (aboutResponse.serverId != null && aboutResponse.serverId!.isNotEmpty) {
      debugPrint('🔍 服务器缓存 - 使用服务器返回的 serverId: ${aboutResponse.serverId}');
      return aboutResponse.serverId!;
    }
    
    // 2. 后备方案：基于 URL 生成（host:port）
    try {
      final uri = Uri.parse(serverUrl);
      final generatedId = '${uri.host}:${uri.port}';
      debugPrint('🔍 服务器缓存 - 服务器未返回 serverId，使用 URL 生成: $generatedId');
      return generatedId;
    } catch (e) {
      debugPrint('🔍 服务器缓存 - 生成serverId失败，使用hashCode: $e');
      return serverUrl.hashCode.toString();
    }
  }

  // 保存服务器信息到缓存
  Future<void> cacheServerInfo(AboutResponse aboutResponse, {required String serverUrl}) async {
    final serverId = getServerId(aboutResponse, serverUrl);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '$_serverCachePrefix$serverId';
      
      // 创建包含服务器URL的完整信息
      final serverData = {
        'about': aboutResponse.toJson(),
        'serverUrl': serverUrl,
        'cachedAt': DateTime.now().toIso8601String(),
      };
      
      final jsonString = jsonEncode(serverData);
      
      // 保存服务器信息
      await prefs.setString(cacheKey, jsonString);
      
      // 更新服务器列表
      await _updateServerList(serverId);
      
      debugPrint('🔍 服务器缓存 - 已缓存服务器: $serverId (URL: $serverUrl, Name: ${aboutResponse.serverName})');
    } catch (e) {
      debugPrint('🔍 服务器缓存 - 缓存失败: $e');
    }
  }

  // 获取缓存的服务器信息
  Future<AboutResponse?> getCachedServerInfo(String serverId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '$_serverCachePrefix$serverId';
      final jsonString = prefs.getString(cacheKey);
      
      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        final aboutJson = json['about'] as Map<String, dynamic>;
        return AboutResponse.fromJson(aboutJson);
      }
    } catch (e) {
      debugPrint('🔍 服务器缓存 - 获取缓存失败: $e');
    }
    return null;
  }

  // 获取缓存的服务器URL
  Future<String?> getCachedServerUrl(String serverId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '$_serverCachePrefix$serverId';
      final jsonString = prefs.getString(cacheKey);
      
      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return json['serverUrl'] as String?;
      }
    } catch (e) {
      debugPrint('🔍 服务器缓存 - 获取服务器URL失败: $e');
    }
    return null;
  }

  // 获取所有缓存的服务器列表
  Future<List<ServerInfo>> getAllCachedServers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final serverListJson = prefs.getString(_serverListKey);
      
      if (serverListJson != null) {
        final List<dynamic> serverList = jsonDecode(serverListJson);
        return serverList.map((json) => ServerInfo.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('🔍 服务器缓存 - 获取服务器列表失败: $e');
    }
    return [];
  }

  // 获取完整的服务器信息（包含AboutResponse和URL）
  Future<CachedServerInfo?> getFullServerInfo(String serverId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '$_serverCachePrefix$serverId';
      final jsonString = prefs.getString(cacheKey);
      
      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        final aboutJson = json['about'] as Map<String, dynamic>;
        final serverUrl = json['serverUrl'] as String?;
        final cachedAt = DateTime.parse(json['cachedAt'] as String);
        
        return CachedServerInfo(
          about: AboutResponse.fromJson(aboutJson),
          serverUrl: serverUrl,
          cachedAt: cachedAt,
        );
      }
    } catch (e) {
      debugPrint('🔍 服务器缓存 - 获取完整服务器信息失败: $e');
    }
    return null;
  }

  // 获取所有完整的服务器信息
  Future<List<CachedServerInfo>> getAllFullServerInfo() async {
    try {
      final serverList = await getAllCachedServers();
      final List<CachedServerInfo> fullServerInfo = [];
      
      for (final server in serverList) {
        final fullInfo = await getFullServerInfo(server.serverId);
        if (fullInfo != null) {
          fullServerInfo.add(fullInfo);
        }
      }
      
      return fullServerInfo;
    } catch (e) {
      debugPrint('🔍 服务器缓存 - 获取所有完整服务器信息失败: $e');
      return [];
    }
  }

  // 更新服务器列表
  Future<void> _updateServerList(String serverId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final serverListJson = prefs.getString(_serverListKey);
      
      List<ServerInfo> serverList = [];
      if (serverListJson != null) {
        final List<dynamic> jsonList = jsonDecode(serverListJson);
        serverList = jsonList.map((json) => ServerInfo.fromJson(json)).toList();
      }
      
      // 检查服务器是否已存在
      final existingIndex = serverList.indexWhere((server) => server.serverId == serverId);
      
      if (existingIndex >= 0) {
        // 更新现有服务器的时间戳
        serverList[existingIndex] = serverList[existingIndex].copyWith(
          lastAccessed: DateTime.now(),
        );
      } else {
        // 添加新服务器
        serverList.add(ServerInfo(
          serverId: serverId,
          lastAccessed: DateTime.now(),
        ));
      }
      
      // 按最后访问时间排序，最新的在前
      serverList.sort((a, b) => b.lastAccessed.compareTo(a.lastAccessed));
      
      // 限制缓存大小
      if (serverList.length > _maxCacheSize) {
        serverList = serverList.take(_maxCacheSize).toList();
      }
      
      // 保存更新后的列表
      final updatedJson = jsonEncode(serverList.map((server) => server.toJson()).toList());
      await prefs.setString(_serverListKey, updatedJson);
      
    } catch (e) {
      debugPrint('🔍 服务器缓存 - 更新服务器列表失败: $e');
    }
  }

  // 删除服务器缓存
  Future<void> removeServerCache(String serverId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '$_serverCachePrefix$serverId';
      
      // 删除服务器信息
      await prefs.remove(cacheKey);
      
      // 从服务器列表中移除
      final serverListJson = prefs.getString(_serverListKey);
      if (serverListJson != null) {
        final List<dynamic> jsonList = jsonDecode(serverListJson);
        final serverList = jsonList.map((json) => ServerInfo.fromJson(json)).toList();
        
        serverList.removeWhere((server) => server.serverId == serverId);
        
        final updatedJson = jsonEncode(serverList.map((server) => server.toJson()).toList());
        await prefs.setString(_serverListKey, updatedJson);
      }
      
      debugPrint('🔍 服务器缓存 - 已删除服务器: $serverId');
    } catch (e) {
      debugPrint('🔍 服务器缓存 - 删除缓存失败: $e');
    }
  }

  // 清理过期缓存
  Future<void> cleanExpiredCache({Duration maxAge = const Duration(days: 30)}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final serverListJson = prefs.getString(_serverListKey);
      
      if (serverListJson != null) {
        final List<dynamic> jsonList = jsonDecode(serverListJson);
        final serverList = jsonList.map((json) => ServerInfo.fromJson(json)).toList();
        
        final now = DateTime.now();
        final expiredServers = serverList.where((server) {
          return now.difference(server.lastAccessed) > maxAge;
        }).toList();
        
        // 删除过期的服务器
        for (final server in expiredServers) {
          await removeServerCache(server.serverId);
        }
        
        debugPrint('🔍 服务器缓存 - 已清理 ${expiredServers.length} 个过期服务器');
      }
    } catch (e) {
      debugPrint('🔍 服务器缓存 - 清理过期缓存失败: $e');
    }
  }
}

// 服务器信息模型
class ServerInfo {
  final String serverId;
  final DateTime lastAccessed;

  ServerInfo({
    required this.serverId,
    required this.lastAccessed,
  });

  ServerInfo copyWith({
    String? serverId,
    DateTime? lastAccessed,
  }) {
    return ServerInfo(
      serverId: serverId ?? this.serverId,
      lastAccessed: lastAccessed ?? this.lastAccessed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serverId': serverId,
      'lastAccessed': lastAccessed.toIso8601String(),
    };
  }

  factory ServerInfo.fromJson(Map<String, dynamic> json) {
    return ServerInfo(
      serverId: json['serverId'] as String,
      lastAccessed: DateTime.parse(json['lastAccessed'] as String),
    );
  }
}

// 完整的服务器信息模型
class CachedServerInfo {
  final AboutResponse about;
  final String? serverUrl;
  final DateTime cachedAt;

  CachedServerInfo({
    required this.about,
    this.serverUrl,
    required this.cachedAt,
  });
}
