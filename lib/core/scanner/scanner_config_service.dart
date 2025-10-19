import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'scanner_service.dart';

/// 扫描仪配置数据
class SavedScannerConfig {
  final String id;
  final String name;
  final ScannerType type;
  final String? ipAddress;
  final int? port;
  final String? connectionType;
  final bool isDefault;
  final DateTime lastUsed;
  
  // 默认扫描设置
  final int defaultDpi;
  final String defaultColorMode;
  final bool defaultAdf;
  
  SavedScannerConfig({
    required this.id,
    required this.name,
    required this.type,
    this.ipAddress,
    this.port,
    this.connectionType,
    this.isDefault = false,
    required this.lastUsed,
    this.defaultDpi = 300,
    this.defaultColorMode = 'color',
    this.defaultAdf = false,
  });
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type.toString(),
    'ipAddress': ipAddress,
    'port': port,
    'connectionType': connectionType,
    'isDefault': isDefault,
    'lastUsed': lastUsed.toIso8601String(),
    'defaultDpi': defaultDpi,
    'defaultColorMode': defaultColorMode,
    'defaultAdf': defaultAdf,
  };
  
  factory SavedScannerConfig.fromJson(Map<String, dynamic> json) {
    return SavedScannerConfig(
      id: json['id'] as String,
      name: json['name'] as String,
      type: ScannerType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => ScannerType.network,
      ),
      ipAddress: json['ipAddress'] as String?,
      port: json['port'] as int?,
      connectionType: json['connectionType'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
      lastUsed: DateTime.parse(json['lastUsed'] as String),
      defaultDpi: json['defaultDpi'] as int? ?? 300,
      defaultColorMode: json['defaultColorMode'] as String? ?? 'color',
      defaultAdf: json['defaultAdf'] as bool? ?? false,
    );
  }
  
  factory SavedScannerConfig.fromScannerInfo(ScannerInfo info) {
    return SavedScannerConfig(
      id: info.id,
      name: info.name,
      type: info.type,
      ipAddress: info.ipAddress,
      port: info.port,
      connectionType: info.connectionType,
      lastUsed: DateTime.now(),
    );
  }
  
  ScannerInfo toScannerInfo() {
    return ScannerInfo(
      id: id,
      name: name,
      type: type,
      ipAddress: ipAddress,
      port: port,
      connectionType: connectionType,
    );
  }
  
  SavedScannerConfig copyWith({
    String? name,
    bool? isDefault,
    int? defaultDpi,
    String? defaultColorMode,
    bool? defaultAdf,
  }) {
    return SavedScannerConfig(
      id: id,
      name: name ?? this.name,
      type: type,
      ipAddress: ipAddress,
      port: port,
      connectionType: connectionType,
      isDefault: isDefault ?? this.isDefault,
      lastUsed: DateTime.now(),
      defaultDpi: defaultDpi ?? this.defaultDpi,
      defaultColorMode: defaultColorMode ?? this.defaultColorMode,
      defaultAdf: defaultAdf ?? this.defaultAdf,
    );
  }
}

/// 扫描仪配置存储服务
class ScannerConfigService {
  static const String _savedScannersKey = 'saved_scanners';
  
  final SharedPreferences _prefs;
  
  ScannerConfigService(this._prefs);
  
  /// 获取所有已保存的扫描仪
  List<SavedScannerConfig> getSavedScanners() {
    final jsonList = _prefs.getStringList(_savedScannersKey) ?? [];
    return jsonList
        .map((json) {
          try {
            return SavedScannerConfig.fromJson(jsonDecode(json) as Map<String, dynamic>);
          } catch (e) {
            return null;
          }
        })
        .whereType<SavedScannerConfig>()
        .toList()
      ..sort((a, b) => b.lastUsed.compareTo(a.lastUsed));
  }
  
  /// 保存扫描仪配置
  Future<void> saveScannerConfig(SavedScannerConfig config) async {
    final scanners = getSavedScanners();
    
    // 如果设置为默认，清除其他默认设置
    if (config.isDefault) {
      for (int i = 0; i < scanners.length; i++) {
        if (scanners[i].id != config.id && scanners[i].isDefault) {
          scanners[i] = scanners[i].copyWith(isDefault: false);
        }
      }
    }
    
    // 更新或添加扫描仪
    final index = scanners.indexWhere((s) => s.id == config.id);
    if (index >= 0) {
      scanners[index] = config;
    } else {
      scanners.add(config);
    }
    
    // 保存
    final jsonList = scanners.map((s) => jsonEncode(s.toJson())).toList();
    await _prefs.setStringList(_savedScannersKey, jsonList);
  }
  
  /// 删除扫描仪配置
  Future<void> removeScannerConfig(String scannerId) async {
    final scanners = getSavedScanners();
    scanners.removeWhere((s) => s.id == scannerId);
    
    final jsonList = scanners.map((s) => jsonEncode(s.toJson())).toList();
    await _prefs.setStringList(_savedScannersKey, jsonList);
  }
  
  /// 获取特定扫描仪配置
  SavedScannerConfig? getScannerConfig(String scannerId) {
    try {
      return getSavedScanners().firstWhere((s) => s.id == scannerId);
    } catch (e) {
      return null;
    }
  }
  
  /// 获取默认扫描仪
  SavedScannerConfig? getDefaultScanner() {
    try {
      return getSavedScanners().firstWhere((s) => s.isDefault);
    } catch (e) {
      return null;
    }
  }
  
  /// 设置默认扫描仪
  Future<void> setDefaultScanner(String scannerId) async {
    final scanners = getSavedScanners();
    
    for (int i = 0; i < scanners.length; i++) {
      scanners[i] = scanners[i].copyWith(
        isDefault: scanners[i].id == scannerId,
      );
    }
    
    final jsonList = scanners.map((s) => jsonEncode(s.toJson())).toList();
    await _prefs.setStringList(_savedScannersKey, jsonList);
  }
  
  /// 更新扫描仪使用时间
  Future<void> updateLastUsed(String scannerId) async {
    final config = getScannerConfig(scannerId);
    if (config != null) {
      await saveScannerConfig(
        SavedScannerConfig(
          id: config.id,
          name: config.name,
          type: config.type,
          ipAddress: config.ipAddress,
          port: config.port,
          connectionType: config.connectionType,
          isDefault: config.isDefault,
          lastUsed: DateTime.now(),
          defaultDpi: config.defaultDpi,
          defaultColorMode: config.defaultColorMode,
          defaultAdf: config.defaultAdf,
        ),
      );
    }
  }
  
  /// 清除所有扫描仪配置
  Future<void> clearAll() async {
    await _prefs.remove(_savedScannersKey);
  }
}

