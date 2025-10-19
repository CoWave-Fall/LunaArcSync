import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'scanner_service.dart';

/// 平台扫描仪服务，用于桌面平台的本地扫描仪
/// 支持 Windows (WIA/TWAIN)、macOS (ImageCaptureCore)、Linux (SANE)
class PlatformScannerService implements IScannerService {
  static const MethodChannel _channel = MethodChannel('com.lunaarcsync/scanner');
  bool _isChannelAvailable = false;
  
  PlatformScannerService() {
    _checkChannelAvailability();
  }
  
  /// 检查平台通道是否可用
  Future<void> _checkChannelAvailability() async {
    try {
      await _channel.invokeMethod('ping');
      _isChannelAvailable = true;
      print('Platform scanner channel is available');
    } catch (e) {
      _isChannelAvailable = false;
      print('Platform scanner channel not available: $e');
    }
  }
  
  /// 判断当前平台是否支持本地扫描仪
  static bool isSupported() {
    return !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
  }
  
  @override
  Future<List<ScannerInfo>> discoverScanners({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    if (!isSupported() || !_isChannelAvailable) {
      print('Platform scanner not supported or channel not available');
      return [];
    }
    
    try {
      final List<dynamic>? scanners = await _channel
          .invokeMethod('discoverScanners')
          .timeout(timeout);
      
      if (scanners == null || scanners.isEmpty) {
        print('No platform scanners discovered');
        return [];
      }
      
      return scanners.map((s) {
        final Map<dynamic, dynamic> scannerMap = s as Map<dynamic, dynamic>;
        return ScannerInfo(
          id: scannerMap['id'] as String,
          name: scannerMap['name'] as String,
          manufacturer: scannerMap['manufacturer'] as String?,
          model: scannerMap['model'] as String?,
          type: _determineScannerType(),
          isAvailable: scannerMap['isAvailable'] as bool? ?? true,
          capabilities: (scannerMap['capabilities'] as List<dynamic>?)
              ?.map((c) => c.toString())
              .toList() ?? [],
          connectionType: scannerMap['connectionType'] as String?,
        );
      }).toList();
    } catch (e) {
      print('Platform scanner discovery error: $e');
      return [];
    }
  }
  
  ScannerType _determineScannerType() {
    if (Platform.isWindows) {
      return ScannerType.wia; // 或 TWAIN，取决于实现
    } else if (Platform.isMacOS) {
      return ScannerType.imageCapture;
    } else if (Platform.isLinux) {
      return ScannerType.sane;
    }
    return ScannerType.usb;
  }
  
  @override
  Future<Map<String, dynamic>> getScannerCapabilities(String scannerId) async {
    if (!isSupported() || !_isChannelAvailable) {
      return {};
    }
    
    try {
      final Map<dynamic, dynamic>? caps = await _channel.invokeMethod(
        'getScannerCapabilities',
        {'scannerId': scannerId},
      );
      
      if (caps == null) return {};
      
      return Map<String, dynamic>.from(caps);
    } catch (e) {
      print('Failed to get capabilities: $e');
      return {};
    }
  }
  
  @override
  Future<ScanResult> scan(String scannerId, ScanConfig config) async {
    if (!isSupported() || !_isChannelAvailable) {
      throw UnsupportedError('Platform scanner not supported on this platform');
    }
    
    try {
      print('Starting platform scan: $scannerId with config: $config');
      
      final Map<dynamic, dynamic>? result = await _channel.invokeMethod('scan', {
        'scannerId': scannerId,
        'dpi': config.dpi,
        'colorMode': config.colorMode,
        'format': config.format,
        'adf': config.autoDocumentFeeder,
        'duplex': config.duplexMode,
      });
      
      if (result == null) {
        throw Exception('Scan returned null result');
      }
      
      final List<dynamic>? imagesData = result['images'] as List<dynamic>?;
      if (imagesData == null || imagesData.isEmpty) {
        throw Exception('No images in scan result');
      }
      
      final List<Uint8List> images = imagesData
          .map((bytes) => Uint8List.fromList(List<int>.from(bytes as List<dynamic>)))
          .toList();
      
      print('Platform scan completed: ${images.length} images');
      
      return ScanResult(
        images: images,
        format: config.format,
        metadata: result['metadata'] != null 
            ? Map<String, dynamic>.from(result['metadata'] as Map<dynamic, dynamic>)
            : null,
      );
    } catch (e) {
      print('Platform scan failed: $e');
      rethrow;
    }
  }
  
  @override
  Future<void> cancelScan(String scannerId) async {
    if (!isSupported() || !_isChannelAvailable) {
      return;
    }
    
    try {
      await _channel.invokeMethod('cancelScan', {'scannerId': scannerId});
      print('Platform scan canceled: $scannerId');
    } catch (e) {
      print('Failed to cancel platform scan: $e');
    }
  }
  
  @override
  void dispose() {
    // Platform channels don't need explicit disposal
  }
}

/// Linux SANE 扫描仪服务实现
/// 使用 scanimage 命令行工具
class LinuxSaneService implements IScannerService {
  @override
  Future<List<ScannerInfo>> discoverScanners({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    if (!Platform.isLinux) return [];
    
    try {
      final result = await Process.run('scanimage', ['-L'])
          .timeout(timeout);
      
      if (result.exitCode == 0) {
        return _parseSaneDevices(result.stdout as String);
      }
    } catch (e) {
      print('SANE scanner discovery error: $e');
    }
    
    return [];
  }
  
  List<ScannerInfo> _parseSaneDevices(String output) {
    final scanners = <ScannerInfo>[];
    final lines = output.split('\n');
    
    for (final line in lines) {
      if (line.trim().isEmpty) continue;
      
      // 解析格式: device `name' is a Manufacturer Model
      final match = RegExp(r"device `(.+?)' is a (.+)").firstMatch(line);
      if (match != null) {
        final deviceId = match.group(1)!;
        final description = match.group(2)!;
        
        scanners.add(ScannerInfo(
          id: deviceId,
          name: description,
          type: ScannerType.sane,
          connectionType: 'USB/SANE',
        ));
      }
    }
    
    return scanners;
  }
  
  @override
  Future<Map<String, dynamic>> getScannerCapabilities(String scannerId) async {
    // SANE 能力查询可以通过 scanimage --help -d deviceId 获取
    // 这里返回默认值
    return {
      'resolutions': [75, 150, 300, 600],
      'colorModes': ['color', 'grayscale', 'lineart'],
      'inputSources': ['Flatbed'],
    };
  }
  
  @override
  Future<ScanResult> scan(String scannerId, ScanConfig config) async {
    if (!Platform.isLinux) {
      throw UnsupportedError('SANE is only supported on Linux');
    }
    
    try {
      // 创建临时文件
      final outputFile = '${Directory.systemTemp.path}/scan_${DateTime.now().millisecondsSinceEpoch}.${config.format}';
      
      print('Starting SANE scan to $outputFile');
      
      // 构建 scanimage 命令
      final args = [
        '--device-name=$scannerId',
        '--resolution=${config.dpi}',
        '--mode=${_mapColorModeForSane(config.colorMode)}',
        '--format=${config.format}',
        '--output-file=$outputFile',
      ];
      
      final result = await Process.run('scanimage', args);
      
      if (result.exitCode == 0) {
        final file = File(outputFile);
        if (await file.exists()) {
          final bytes = await file.readAsBytes();
          await file.delete();
          
          return ScanResult(
            images: [bytes],
            format: config.format,
          );
        } else {
          throw Exception('Scan output file not found');
        }
      } else {
        throw Exception('Scan failed: ${result.stderr}');
      }
    } catch (e) {
      print('SANE scan error: $e');
      rethrow;
    }
  }
  
  String _mapColorModeForSane(String mode) {
    switch (mode) {
      case 'color':
        return 'Color';
      case 'grayscale':
        return 'Gray';
      case 'blackwhite':
        return 'Lineart';
      default:
        return 'Color';
    }
  }
  
  @override
  Future<void> cancelScan(String scannerId) async {
    // SANE 取消需要终止进程，这里暂不实现
  }
  
  @override
  void dispose() {
    // 无需清理
  }
}


