import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import 'package:multicast_dns/multicast_dns.dart';
import 'scanner_service.dart';

/// 网络扫描仪服务，支持 eSCL (AirPrint) 和 IPP 协议
class NetworkScannerService implements IScannerService {
  final http.Client _httpClient = http.Client();
  final Map<String, String> _activeScanJobs = {}; // scannerId -> jobUrl
  
  /// 通过 mDNS 发现网络扫描仪
  @override
  Future<List<ScannerInfo>> discoverScanners({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final List<ScannerInfo> scanners = [];
    final Set<String> discoveredIds = {}; // 避免重复
    
    try {
      final MDnsClient client = MDnsClient();
      await client.start();
      
      // 查找 eSCL 服务 (_uscan._tcp, _uscans._tcp)
      // 查找 IPP 服务 (_ipp._tcp, _ipps._tcp)
      final services = [
        '_uscan._tcp',   // eSCL (Unencrypted)
        '_uscans._tcp',  // eSCL (TLS)
        '_ipp._tcp',     // IPP
        '_ipps._tcp',    // IPP over TLS
      ];
      
      for (final service in services) {
        try {
          await for (final PtrResourceRecord ptr in client
              .lookup<PtrResourceRecord>(
                ResourceRecordQuery.serverPointer(service),
              )
              .timeout(timeout, onTimeout: (sink) => sink.close())) {
            
            // 解析服务实例
            try {
              await for (final SrvResourceRecord srv in client
                  .lookup<SrvResourceRecord>(
                    ResourceRecordQuery.service(ptr.domainName),
                  )
                  .timeout(const Duration(seconds: 2), onTimeout: (sink) => sink.close())) {
                
                // 获取 IP 地址
                try {
                  await for (final IPAddressResourceRecord ip in client
                      .lookup<IPAddressResourceRecord>(
                        ResourceRecordQuery.addressIPv4(srv.target),
                      )
                      .timeout(const Duration(seconds: 2), onTimeout: (sink) => sink.close())) {
                    
                    final scannerId = '${ip.address.address}:${srv.port}';
                    
                    // 避免重复添加
                    if (discoveredIds.contains(scannerId)) continue;
                    discoveredIds.add(scannerId);
                    
                    final info = ScannerInfo(
                      id: scannerId,
                      name: ptr.domainName,
                      type: ScannerType.network,
                      ipAddress: ip.address.address,
                      port: srv.port,
                      capabilities: _determineCapabilities(service),
                      connectionType: _getConnectionType(service),
                    );
                    
                    scanners.add(info);
                    print('Discovered scanner: ${info.name} at ${info.ipAddress}:${info.port}');
                  }
                } catch (e) {
                  // IPv4 查询超时或失败，继续下一个
                  continue;
                }
              }
            } catch (e) {
              // SRV 查询超时或失败，继续下一个
              continue;
            }
          }
        } catch (e) {
          // PTR 查询超时或失败，继续下一个服务类型
          continue;
        }
      }
      
      client.stop();
      print('Network scanner discovery complete: found ${scanners.length} scanners');
    } catch (e) {
      print('mDNS discovery error: $e');
    }
    
    // 如果没有发现扫描仪，尝试直接连接常见端口
    if (scanners.isEmpty) {
      print('No scanners found via mDNS, attempting direct connection...');
      final directScanners = await _tryDirectConnection();
      scanners.addAll(directScanners);
    }
    
    return scanners;
  }
  
  /// 尝试直接连接本地网络中可能的扫描仪
  Future<List<ScannerInfo>> _tryDirectConnection() async {
    final scanners = <ScannerInfo>[];
    
    try {
      // 获取本地 IP 地址
      final interfaces = await NetworkInterface.list();
      for (final interface in interfaces) {
        for (final addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
            // 尝试同一子网的常见 IP
            final subnet = addr.address.substring(0, addr.address.lastIndexOf('.'));
            
            // 尝试几个常见的 IP 地址 (broadcast 除外)
            for (final lastOctet in [1, 2, 100, 101, 102, 150, 200]) {
              final testIp = '$subnet.$lastOctet';
              if (testIp == addr.address) continue; // 跳过自己
              
              // 尝试 eSCL 端口 80
              final scanner = await _probeScanner(testIp, 80);
              if (scanner != null && !scanners.any((s) => s.id == scanner.id)) {
                scanners.add(scanner);
              }
            }
          }
        }
      }
    } catch (e) {
      print('Direct connection probe error: $e');
    }
    
    return scanners;
  }
  
  /// 探测特定 IP 和端口是否有扫描仪
  Future<ScannerInfo?> _probeScanner(String ip, int port) async {
    try {
      // 尝试访问 eSCL ScannerCapabilities 端点
      final url = Uri.parse('http://$ip:$port/eSCL/ScannerCapabilities');
      final response = await _httpClient.get(url).timeout(const Duration(seconds: 2));
      
      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.body);
        final makeModel = document.findAllElements('MakeAndModel').firstOrNull?.innerText ?? 'Unknown Scanner';
        
        return ScannerInfo(
          id: '$ip:$port',
          name: makeModel,
          type: ScannerType.network,
          ipAddress: ip,
          port: port,
          capabilities: ['eSCL', 'AirScan'],
          connectionType: 'eSCL/AirPrint',
        );
      }
    } catch (e) {
      // 连接失败，不是扫描仪或不支持 eSCL
    }
    
    return null;
  }
  
  List<String> _determineCapabilities(String service) {
    if (service.contains('uscan')) {
      return ['eSCL', 'AirScan'];
    } else if (service.contains('ipp')) {
      return ['IPP', 'IPP-Scan'];
    }
    return [];
  }
  
  String _getConnectionType(String service) {
    if (service.contains('uscan')) {
      return 'eSCL/AirPrint';
    } else if (service.contains('ipp')) {
      return 'IPP';
    }
    return 'Network';
  }
  
  /// 获取 eSCL 扫描仪能力
  @override
  Future<Map<String, dynamic>> getScannerCapabilities(String scannerId) async {
    final parts = scannerId.split(':');
    final ip = parts[0];
    final port = int.parse(parts[1]);
    
    try {
      // eSCL 端点: http://IP:PORT/eSCL/ScannerCapabilities
      final url = Uri.parse('http://$ip:$port/eSCL/ScannerCapabilities');
      final response = await _httpClient.get(url).timeout(const Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.body);
        return _parseCapabilities(document);
      } else {
        print('Failed to get capabilities: HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to get capabilities: $e');
    }
    
    // 返回默认能力
    return {
      'resolutions': [75, 150, 300, 600],
      'colorModes': ['RGB24', 'Grayscale8'],
      'inputSources': ['Platen'],
    };
  }
  
  Map<String, dynamic> _parseCapabilities(XmlDocument doc) {
    final caps = <String, dynamic>{};
    
    try {
      // 解析支持的分辨率
      final resolutions = doc.findAllElements('Resolution').map((e) {
        final xRes = e.findElements('XResolution').firstOrNull?.innerText;
        return int.tryParse(xRes ?? '300');
      }).where((r) => r != null).toSet().toList();
      
      if (resolutions.isNotEmpty) {
        resolutions.sort();
        caps['resolutions'] = resolutions;
      } else {
        caps['resolutions'] = [75, 150, 300, 600];
      }
      
      // 解析支持的颜色模式
      final colorModes = doc.findAllElements('ColorMode')
          .map((e) => e.innerText)
          .toSet()
          .toList();
      caps['colorModes'] = colorModes.isNotEmpty ? colorModes : ['RGB24', 'Grayscale8'];
      
      // 解析支持的输入源 (Platen, Feeder)
      final sources = doc.findAllElements('InputSource')
          .map((e) => e.innerText)
          .toSet()
          .toList();
      caps['inputSources'] = sources.isNotEmpty ? sources : ['Platen'];
      
      // 解析制造商和型号
      final makeModel = doc.findAllElements('MakeAndModel').firstOrNull?.innerText;
      if (makeModel != null) {
        caps['makeModel'] = makeModel;
      }
      
      print('Parsed capabilities: $caps');
    } catch (e) {
      print('Error parsing capabilities: $e');
    }
    
    return caps;
  }
  
  /// 执行 eSCL 扫描
  @override
  Future<ScanResult> scan(String scannerId, ScanConfig config) async {
    final parts = scannerId.split(':');
    final ip = parts[0];
    final port = int.parse(parts[1]);
    
    print('Starting scan: $scannerId with config: $config');
    
    try {
      // 1. 创建扫描任务
      final jobUrl = await _createScanJob(ip, port, config);
      _activeScanJobs[scannerId] = jobUrl;
      print('Scan job created: $jobUrl');
      
      // 2. 等待扫描完成并获取图像
      final images = await _retrieveScannedImages(jobUrl);
      print('Scan completed: ${images.length} images retrieved');
      
      // 3. 清理任务
      _activeScanJobs.remove(scannerId);
      
      return ScanResult(
        images: images,
        format: config.format,
        metadata: {
          'scannerId': scannerId,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      print('Scan failed: $e');
      _activeScanJobs.remove(scannerId);
      rethrow;
    }
  }
  
  Future<String> _createScanJob(String ip, int port, ScanConfig config) async {
    final url = Uri.parse('http://$ip:$port/eSCL/ScanJobs');
    
    // 构建 eSCL ScanSettings XML
    final scanSettings = '''<?xml version="1.0" encoding="UTF-8"?>
<scan:ScanSettings xmlns:scan="http://schemas.hp.com/imaging/escl/2011/05/03"
                   xmlns:pwg="http://www.pwg.org/schemas/2010/12/sm">
  <pwg:Version>2.0</pwg:Version>
  <scan:Intent>Document</scan:Intent>
  <pwg:ScanRegions>
    <pwg:ScanRegion>
      <pwg:ContentRegionUnits>escl:ThreeHundredthsOfInches</pwg:ContentRegionUnits>
      <pwg:XOffset>0</pwg:XOffset>
      <pwg:YOffset>0</pwg:YOffset>
      <pwg:Width>2550</pwg:Width>
      <pwg:Height>3300</pwg:Height>
    </pwg:ScanRegion>
  </pwg:ScanRegions>
  <scan:InputSource>${config.autoDocumentFeeder ? 'Feeder' : 'Platen'}</scan:InputSource>
  <scan:ColorMode>${_mapColorMode(config.colorMode)}</scan:ColorMode>
  <scan:XResolution>${config.dpi}</scan:XResolution>
  <scan:YResolution>${config.dpi}</scan:YResolution>
  <pwg:DocumentFormat>image/jpeg</pwg:DocumentFormat>
</scan:ScanSettings>''';
    
    print('Sending scan job request to $url');
    
    final response = await _httpClient.post(
      url,
      headers: {
        'Content-Type': 'application/xml',
        'Accept': 'application/xml',
      },
      body: scanSettings,
    ).timeout(const Duration(seconds: 10));
    
    if (response.statusCode == 201) {
      // 返回扫描任务的 Location URL
      final location = response.headers['location'];
      if (location != null) {
        // 如果 location 是相对路径，转换为绝对路径
        if (location.startsWith('/')) {
          return 'http://$ip:$port$location';
        }
        return location;
      } else {
        throw Exception('Scan job created but no Location header');
      }
    } else {
      throw Exception('Failed to create scan job: HTTP ${response.statusCode}\n${response.body}');
    }
  }
  
  String _mapColorMode(String mode) {
    switch (mode) {
      case 'color':
        return 'RGB24';
      case 'grayscale':
        return 'Grayscale8';
      case 'blackwhite':
        return 'BlackAndWhite1';
      default:
        return 'RGB24';
    }
  }
  
  Future<List<Uint8List>> _retrieveScannedImages(String jobUrl) async {
    final images = <Uint8List>[];
    
    // 轮询扫描状态
    for (int i = 0; i < 60; i++) {  // 最多等待 60 秒
      await Future.delayed(const Duration(seconds: 1));
      
      try {
        final statusResponse = await _httpClient.get(Uri.parse(jobUrl))
            .timeout(const Duration(seconds: 5));
        
        if (statusResponse.statusCode == 200) {
          // 检查状态
          final doc = XmlDocument.parse(statusResponse.body);
          final state = doc.findAllElements('JobState').firstOrNull?.innerText;
          
          print('Scan job state: $state');
          
          if (state == 'Completed') {
            // 获取扫描的图像
            final imageUrl = '$jobUrl/NextDocument';
            print('Fetching scanned image from $imageUrl');
            
            final imageResponse = await _httpClient.get(Uri.parse(imageUrl))
                .timeout(const Duration(seconds: 30));
            
            if (imageResponse.statusCode == 200) {
              images.add(imageResponse.bodyBytes);
              print('Image retrieved: ${imageResponse.bodyBytes.length} bytes');
            } else {
              print('Failed to get image: HTTP ${imageResponse.statusCode}');
            }
            break;
          } else if (state == 'Aborted' || state == 'Canceled') {
            throw Exception('Scan job was aborted or canceled');
          } else if (state == 'Processing' || state == 'Pending') {
            // 继续等待
            continue;
          }
        } else if (statusResponse.statusCode == 404) {
          throw Exception('Scan job not found (may have expired)');
        }
      } catch (e) {
        if (e is TimeoutException) {
          print('Status check timeout, retrying...');
          continue;
        }
        rethrow;
      }
    }
    
    if (images.isEmpty) {
      throw Exception('Scan timeout or no images retrieved');
    }
    
    return images;
  }
  
  @override
  Future<void> cancelScan(String scannerId) async {
    final jobUrl = _activeScanJobs[scannerId];
    if (jobUrl != null) {
      try {
        // 发送 DELETE 请求取消扫描任务
        await _httpClient.delete(Uri.parse(jobUrl));
        _activeScanJobs.remove(scannerId);
        print('Scan job canceled: $jobUrl');
      } catch (e) {
        print('Failed to cancel scan job: $e');
      }
    }
  }
  
  @override
  void dispose() {
    _httpClient.close();
    _activeScanJobs.clear();
  }
}

