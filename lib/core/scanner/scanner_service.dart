import 'dart:typed_data';

/// 扫描仪类型枚举
enum ScannerType {
  network,      // 网络扫描仪 (eSCL/IPP)
  twain,        // TWAIN (Windows)
  wia,          // WIA (Windows)
  sane,         // SANE (Linux)
  imageCapture, // ImageCaptureCore (macOS)
  camera,       // 移动设备摄像头 (现有)
  usb,          // USB 连接的扫描仪
}

/// 扫描仪信息
class ScannerInfo {
  final String id;
  final String name;
  final String? manufacturer;
  final String? model;
  final ScannerType type;
  final String? ipAddress;      // 网络扫描仪
  final int? port;               // 网络扫描仪端口
  final bool isAvailable;
  final List<String> capabilities; // 支持的功能
  final String? connectionType;   // 连接类型描述

  ScannerInfo({
    required this.id,
    required this.name,
    this.manufacturer,
    this.model,
    required this.type,
    this.ipAddress,
    this.port,
    this.isAvailable = true,
    this.capabilities = const [],
    this.connectionType,
  });

  @override
  String toString() {
    return 'ScannerInfo(name: $name, type: $type, ip: $ipAddress, manufacturer: $manufacturer)';
  }
}

/// 扫描配置
class ScanConfig {
  final int dpi;                  // 分辨率 (75, 150, 300, 600, 1200)
  final String colorMode;         // 'color', 'grayscale', 'blackwhite'
  final String format;            // 'jpeg', 'png', 'pdf', 'tiff'
  final bool autoDocumentFeeder; // 是否使用自动进纸器 (ADF)
  final bool duplexMode;         // 双面扫描
  
  const ScanConfig({
    this.dpi = 300,
    this.colorMode = 'color',
    this.format = 'jpeg',
    this.autoDocumentFeeder = false,
    this.duplexMode = false,
  });

  @override
  String toString() {
    return 'ScanConfig(dpi: $dpi, colorMode: $colorMode, format: $format, adf: $autoDocumentFeeder)';
  }
}

/// 扫描结果
class ScanResult {
  final List<Uint8List> images;
  final String format;
  final Map<String, dynamic>? metadata;

  ScanResult({
    required this.images,
    required this.format,
    this.metadata,
  });

  @override
  String toString() {
    return 'ScanResult(images: ${images.length} pages, format: $format)';
  }
}

/// 扫描仪服务抽象接口
abstract class IScannerService {
  /// 发现可用的扫描仪
  Future<List<ScannerInfo>> discoverScanners({Duration timeout = const Duration(seconds: 5)});
  
  /// 获取扫描仪能力
  Future<Map<String, dynamic>> getScannerCapabilities(String scannerId);
  
  /// 执行扫描
  Future<ScanResult> scan(String scannerId, ScanConfig config);
  
  /// 取消扫描
  Future<void> cancelScan(String scannerId);
  
  /// 释放资源
  void dispose();
}


