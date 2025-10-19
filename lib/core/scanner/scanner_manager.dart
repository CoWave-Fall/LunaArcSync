import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'scanner_service.dart';
import 'network_scanner_service.dart';
import 'platform_scanner_service.dart';

/// 统一扫描仪管理器
/// 整合网络扫描仪、平台扫描仪和移动设备摄像头扫描
class ScannerManager {
  final NetworkScannerService _networkService = NetworkScannerService();
  final IScannerService? _platformService;
  
  ScannerManager() : _platformService = _createPlatformService();
  
  /// 创建平台扫描仪服务
  static IScannerService? _createPlatformService() {
    if (kIsWeb) return null;
    
    if (Platform.isLinux) {
      // 在 Linux 上，优先使用 SANE 命令行工具
      return LinuxSaneService();
    } else if (Platform.isWindows || Platform.isMacOS) {
      // 在 Windows 和 macOS 上使用平台通道
      return PlatformScannerService();
    }
    
    return null;
  }
  
  /// 发现所有类型的扫描仪
  Future<List<ScannerInfo>> discoverAllScanners({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final List<ScannerInfo> allScanners = [];
    
    print('Starting scanner discovery...');
    
    // 1. 发现网络扫描仪 (所有平台)
    try {
      print('Discovering network scanners...');
      final networkScanners = await _networkService.discoverScanners(timeout: timeout);
      allScanners.addAll(networkScanners);
      print('Found ${networkScanners.length} network scanners');
    } catch (e) {
      print('Network scanner discovery error: $e');
    }
    
    // 2. 发现本地扫描仪 (桌面平台)
    if (_platformService != null) {
      try {
        print('Discovering platform scanners...');
        final localScanners = await _platformService.discoverScanners(timeout: timeout);
        allScanners.addAll(localScanners);
        print('Found ${localScanners.length} platform scanners');
      } catch (e) {
        print('Local scanner discovery error: $e');
      }
    }
    
    // 3. 添加移动设备摄像头扫描选项 (Android/iOS)
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      allScanners.add(ScannerInfo(
        id: 'camera',
        name: 'Device Camera Scanner',
        type: ScannerType.camera,
        connectionType: 'Camera',
        capabilities: ['Document Detection', 'Auto Crop'],
      ));
      print('Added camera scanner option');
    }
    
    print('Scanner discovery complete: ${allScanners.length} total scanners found');
    return allScanners;
  }
  
  /// 获取扫描仪能力
  Future<Map<String, dynamic>> getScannerCapabilities(ScannerInfo scanner) async {
    switch (scanner.type) {
      case ScannerType.network:
        return await _networkService.getScannerCapabilities(scanner.id);
        
      case ScannerType.twain:
      case ScannerType.wia:
      case ScannerType.sane:
      case ScannerType.imageCapture:
      case ScannerType.usb:
        if (_platformService != null) {
          return await _platformService.getScannerCapabilities(scanner.id);
        }
        return {};
        
      case ScannerType.camera:
        return {
          'colorModes': ['color'],
          'formats': ['jpeg', 'png'],
        };
    }
  }
  
  /// 执行扫描
  Future<ScanResult> scan(ScannerInfo scanner, ScanConfig config) async {
    print('Starting scan with ${scanner.name} (${scanner.type})');
    
    switch (scanner.type) {
      case ScannerType.network:
        return await _networkService.scan(scanner.id, config);
        
      case ScannerType.twain:
      case ScannerType.wia:
      case ScannerType.sane:
      case ScannerType.imageCapture:
      case ScannerType.usb:
        if (_platformService != null) {
          return await _platformService.scan(scanner.id, config);
        }
        throw UnsupportedError('Platform scanner not available');
        
      case ScannerType.camera:
        return await _scanWithCamera();
    }
  }
  
  /// 使用摄像头扫描文档
  Future<ScanResult> _scanWithCamera() async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
      throw UnsupportedError('Camera scanning is only supported on Android and iOS');
    }
    
    try {
      print('Starting camera document scan...');
      final pictures = await CunningDocumentScanner.getPictures();
      
      if (pictures == null || pictures.isEmpty) {
        throw Exception('No images captured from camera');
      }
      
      print('Camera captured ${pictures.length} images');
      
      // 读取图像数据
      final images = await Future.wait(
        pictures.map((path) async {
          final file = File(path);
          return await file.readAsBytes();
        }),
      );
      
      return ScanResult(
        images: images,
        format: 'jpeg',
        metadata: {
          'source': 'camera',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      print('Camera scan error: $e');
      rethrow;
    }
  }
  
  /// 取消扫描
  Future<void> cancelScan(ScannerInfo scanner) async {
    switch (scanner.type) {
      case ScannerType.network:
        await _networkService.cancelScan(scanner.id);
        
      case ScannerType.twain:
      case ScannerType.wia:
      case ScannerType.sane:
      case ScannerType.imageCapture:
      case ScannerType.usb:
        if (_platformService != null) {
          await _platformService.cancelScan(scanner.id);
        }
        
      case ScannerType.camera:
        // 摄像头扫描无需取消
        break;
    }
  }
  
  /// 释放资源
  void dispose() {
    _networkService.dispose();
    _platformService?.dispose();
  }
  
  /// 获取支持的扫描仪类型描述
  static String getScannerTypeDescription(ScannerType type) {
    switch (type) {
      case ScannerType.network:
        return 'Network Scanner';
      case ScannerType.twain:
        return 'TWAIN Scanner';
      case ScannerType.wia:
        return 'WIA Scanner';
      case ScannerType.sane:
        return 'SANE Scanner';
      case ScannerType.imageCapture:
        return 'Image Capture Scanner';
      case ScannerType.usb:
        return 'USB Scanner';
      case ScannerType.camera:
        return 'Camera Scanner';
    }
  }
  
  /// 检查是否支持网络扫描仪
  static bool supportsNetworkScanners() {
    return true; // 所有平台都支持
  }
  
  /// 检查是否支持本地扫描仪
  static bool supportsLocalScanners() {
    return !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
  }
  
  /// 检查是否支持摄像头扫描
  static bool supportsCameraScanning() {
    return !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  }
}

