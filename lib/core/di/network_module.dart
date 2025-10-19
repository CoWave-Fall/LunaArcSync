import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

/// 网络相关依赖注入模块
@module
abstract class NetworkModule {
  /// 提供 Connectivity 实例
  @lazySingleton
  Connectivity get connectivity => Connectivity();
}

