import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// 网络状态信息
class NetworkStatus {
  final bool isConnected;
  final NetworkConnectionType type;
  final DateTime timestamp;

  NetworkStatus({
    required this.isConnected,
    required this.type,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'NetworkStatus(isConnected: $isConnected, type: $type, timestamp: $timestamp)';
  }
}

/// 网络连接类型
enum NetworkConnectionType {
  wifi,
  mobile,
  ethernet,
  none,
  unknown,
}

/// 网络状态监听服务
/// 
/// 此服务负责：
/// 1. 监听设备网络连接状态变化
/// 2. 提供当前网络状态查询
/// 3. 通知网络状态变化
@lazySingleton
class NetworkStatusService {
  final Connectivity _connectivity;
  final StreamController<NetworkStatus> _statusController = StreamController<NetworkStatus>.broadcast();
  
  NetworkStatus? _lastStatus;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  NetworkStatusService(this._connectivity) {
    _initialize();
  }

  /// 网络状态变化流
  Stream<NetworkStatus> get statusStream => _statusController.stream;

  /// 当前网络状态
  NetworkStatus? get currentStatus => _lastStatus;

  /// 是否已连接到网络
  bool get isConnected => _lastStatus?.isConnected ?? false;

  /// 初始化服务
  void _initialize() {
    // 监听网络状态变化
    _subscription = _connectivity.onConnectivityChanged.listen(
      _onConnectivityChanged,
      onError: (error) {
        debugPrint('🌐 NetworkStatusService: Error listening to connectivity - $error');
      },
    );

    // 获取初始状态
    _checkInitialConnectivity();
  }

  /// 检查初始网络状态
  Future<void> _checkInitialConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _onConnectivityChanged(results);
    } catch (e) {
      debugPrint('🌐 NetworkStatusService: Error checking initial connectivity - $e');
    }
  }

  /// 处理网络状态变化
  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
    
    final isConnected = result != ConnectivityResult.none;
    final type = _mapConnectivityResult(result);
    
    final status = NetworkStatus(
      isConnected: isConnected,
      type: type,
      timestamp: DateTime.now(),
    );

    // 只有当状态真正变化时才通知
    if (_lastStatus == null || 
        _lastStatus!.isConnected != status.isConnected ||
        _lastStatus!.type != status.type) {
      debugPrint('🌐 NetworkStatusService: Status changed - $status');
      _lastStatus = status;
      _statusController.add(status);
    }
  }

  /// 映射网络连接结果到自定义类型
  NetworkConnectionType _mapConnectivityResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return NetworkConnectionType.wifi;
      case ConnectivityResult.mobile:
        return NetworkConnectionType.mobile;
      case ConnectivityResult.ethernet:
        return NetworkConnectionType.ethernet;
      case ConnectivityResult.none:
        return NetworkConnectionType.none;
      default:
        return NetworkConnectionType.unknown;
    }
  }

  /// 手动检查网络状态
  Future<NetworkStatus> checkStatus() async {
    try {
      final results = await _connectivity.checkConnectivity();
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      
      final isConnected = result != ConnectivityResult.none;
      final type = _mapConnectivityResult(result);
      
      final status = NetworkStatus(
        isConnected: isConnected,
        type: type,
        timestamp: DateTime.now(),
      );

      _lastStatus = status;
      return status;
    } catch (e) {
      debugPrint('🌐 NetworkStatusService: Error checking status - $e');
      return NetworkStatus(
        isConnected: false,
        type: NetworkConnectionType.unknown,
        timestamp: DateTime.now(),
      );
    }
  }

  /// 释放资源
  void dispose() {
    _subscription?.cancel();
    _statusController.close();
  }
}


