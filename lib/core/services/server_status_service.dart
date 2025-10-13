import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/core/storage/server_cache_service.dart';

/// 服务器状态
enum ServerStatus {
  online,   // 在线
  offline,  // 离线
  checking, // 检查中
  unknown,  // 未知
}

/// 服务器状态信息
class ServerStatusInfo {
  final String serverId;
  final ServerStatus status;
  final DateTime checkedAt;
  final String? errorMessage;

  ServerStatusInfo({
    required this.serverId,
    required this.status,
    required this.checkedAt,
    this.errorMessage,
  });

  ServerStatusInfo copyWith({
    String? serverId,
    ServerStatus? status,
    DateTime? checkedAt,
    String? errorMessage,
  }) {
    return ServerStatusInfo(
      serverId: serverId ?? this.serverId,
      status: status ?? this.status,
      checkedAt: checkedAt ?? this.checkedAt,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// 服务器状态检查服务
@lazySingleton
class ServerStatusService {
  final Dio _dio;
  
  // 缓存服务器状态（serverId -> ServerStatusInfo）
  final Map<String, ServerStatusInfo> _statusCache = {};

  ServerStatusService() : _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
    sendTimeout: const Duration(seconds: 5),
  ));

  /// 检查单个服务器的状态
  Future<ServerStatusInfo> checkServerStatus(CachedServerInfo serverInfo) async {
    final serverId = serverInfo.serverUrl != null
        ? ServerCacheService.getServerId(serverInfo.about, serverInfo.serverUrl!)
        : (serverInfo.about.serverId ?? serverInfo.about.serverName.hashCode.toString());

    debugPrint('🔍 服务器状态检查 - 开始检查: $serverId (${serverInfo.about.serverName})');

    if (serverInfo.serverUrl == null || serverInfo.serverUrl!.isEmpty) {
      debugPrint('🔍 服务器状态检查 - 服务器URL为空: $serverId');
      final statusInfo = ServerStatusInfo(
        serverId: serverId,
        status: ServerStatus.offline,
        checkedAt: DateTime.now(),
        errorMessage: 'Server URL is empty',
      );
      _statusCache[serverId] = statusInfo;
      return statusInfo;
    }

    try {
      final response = await _dio.get('${serverInfo.serverUrl}/api/about');
      
      if (response.statusCode == 200) {
        debugPrint('🔍 服务器状态检查 - 在线: $serverId');
        final statusInfo = ServerStatusInfo(
          serverId: serverId,
          status: ServerStatus.online,
          checkedAt: DateTime.now(),
        );
        _statusCache[serverId] = statusInfo;
        return statusInfo;
      } else {
        debugPrint('🔍 服务器状态检查 - 离线 (状态码: ${response.statusCode}): $serverId');
        final statusInfo = ServerStatusInfo(
          serverId: serverId,
          status: ServerStatus.offline,
          checkedAt: DateTime.now(),
          errorMessage: 'HTTP ${response.statusCode}',
        );
        _statusCache[serverId] = statusInfo;
        return statusInfo;
      }
    } catch (e) {
      debugPrint('🔍 服务器状态检查 - 离线 (错误: $e): $serverId');
      final statusInfo = ServerStatusInfo(
        serverId: serverId,
        status: ServerStatus.offline,
        checkedAt: DateTime.now(),
        errorMessage: _getErrorMessage(e),
      );
      _statusCache[serverId] = statusInfo;
      return statusInfo;
    }
  }

  /// 批量检查服务器状态
  Future<Map<String, ServerStatusInfo>> checkMultipleServers(
    List<CachedServerInfo> servers,
  ) async {
    debugPrint('🔍 服务器状态检查 - 开始批量检查 ${servers.length} 个服务器');
    
    final results = <String, ServerStatusInfo>{};
    
    // 并发检查所有服务器
    final futures = servers.map((server) => checkServerStatus(server));
    final statusList = await Future.wait(futures);
    
    for (final status in statusList) {
      results[status.serverId] = status;
    }
    
    debugPrint('🔍 服务器状态检查 - 批量检查完成');
    return results;
  }

  /// 获取缓存的服务器状态
  ServerStatusInfo? getCachedStatus(String serverId) {
    return _statusCache[serverId];
  }

  /// 清除状态缓存
  void clearCache() {
    _statusCache.clear();
  }

  /// 清除单个服务器的状态缓存
  void clearServerCache(String serverId) {
    _statusCache.remove(serverId);
  }

  /// 获取错误信息
  String _getErrorMessage(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return 'Connection timeout';
        case DioExceptionType.sendTimeout:
          return 'Send timeout';
        case DioExceptionType.receiveTimeout:
          return 'Receive timeout';
        case DioExceptionType.connectionError:
          return 'Connection error';
        case DioExceptionType.badResponse:
          return 'Bad response: ${error.response?.statusCode}';
        default:
          return 'Network error';
      }
    }
    return error.toString();
  }
}

