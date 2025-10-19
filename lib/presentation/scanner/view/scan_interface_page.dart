import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:luna_arc_sync/core/di/injection.dart';
import 'package:luna_arc_sync/core/scanner/scanner_manager.dart';
import 'package:luna_arc_sync/core/scanner/scanner_service.dart';
import 'package:luna_arc_sync/core/scanner/scanner_config_service.dart';

class ScanInterfacePage extends StatefulWidget {
  final String documentId;
  final ScannerInfo? preselectedScanner;

  const ScanInterfacePage({
    super.key,
    required this.documentId,
    this.preselectedScanner,
  });

  @override
  State<ScanInterfacePage> createState() => _ScanInterfacePageState();
}

class _ScanInterfacePageState extends State<ScanInterfacePage> {
  final ScannerManager _scannerManager = getIt<ScannerManager>();
  final ScannerConfigService _configService = getIt<ScannerConfigService>();

  ScannerInfo? _selectedScanner;
  List<ScannerInfo> _availableScanners = [];
  bool _isDiscovering = false;
  bool _isScanning = false;

  // 扫描参数
  int _dpi = 300;
  String _colorMode = 'color';
  bool _useAdf = false;

  // 扫描预览
  List<Uint8List> _previewImages = [];
  int _currentPreviewIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedScanner = widget.preselectedScanner;
    _loadDefaultSettings();
    if (_selectedScanner == null) {
      _discoverScanners();
    }
  }

  void _loadDefaultSettings() {
    if (_selectedScanner != null) {
      final config = _configService.getScannerConfig(_selectedScanner!.id);
      if (config != null) {
        setState(() {
          _dpi = config.defaultDpi;
          _colorMode = config.defaultColorMode;
          _useAdf = config.defaultAdf;
        });
      }
    }
  }

  Future<void> _discoverScanners() async {
    setState(() => _isDiscovering = true);

    try {
      final scanners = await _scannerManager.discoverAllScanners();
      setState(() {
        _availableScanners = scanners;
        if (_selectedScanner == null && scanners.isNotEmpty) {
          // 尝试使用默认扫描仪
          final defaultConfig = _configService.getDefaultScanner();
          if (defaultConfig != null) {
            _selectedScanner = scanners.firstWhere(
              (s) => s.id == defaultConfig.id,
              orElse: () => scanners.first,
            );
          } else {
            _selectedScanner = scanners.first;
          }
          _loadDefaultSettings();
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('发现扫描仪失败: $e')),
        );
      }
    } finally {
      setState(() => _isDiscovering = false);
    }
  }

  Future<void> _startScan() async {
    if (_selectedScanner == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先选择扫描仪')),
      );
      return;
    }

    setState(() => _isScanning = true);

    try {
      final config = ScanConfig(
        dpi: _dpi,
        colorMode: _colorMode,
        format: 'jpeg',
        autoDocumentFeeder: _useAdf,
      );

      final result = await _scannerManager.scan(_selectedScanner!, config);

      setState(() {
        _previewImages = result.images;
        _currentPreviewIndex = 0;
      });

      // 更新最后使用时间
      await _configService.updateLastUsed(_selectedScanner!.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('扫描完成！共 ${result.images.length} 页'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('扫描失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isScanning = false);
    }
  }

  Future<void> _confirmAndUpload() async {
    if (_previewImages.isEmpty) {
      return;
    }

    // 保存临时文件
    final tempPaths = <String>[];
    for (int i = 0; i < _previewImages.length; i++) {
      final tempFile = File(
        '${Directory.systemTemp.path}/scan_${DateTime.now().millisecondsSinceEpoch}_$i.jpeg',
      );
      await tempFile.writeAsBytes(_previewImages[i]);
      tempPaths.add(tempFile.path);
    }

    // 返回扫描结果
    if (mounted) {
      Navigator.of(context).pop(tempPaths);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('扫描界面'),
        actions: [
          if (_previewImages.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.check),
              tooltip: '确认并上传',
              onPressed: _confirmAndUpload,
            ),
        ],
      ),
      body: Row(
        children: [
          // 左侧：控制面板
          SizedBox(
            width: 300,
            child: _buildControlPanel(),
          ),
          
          const VerticalDivider(width: 1),
          
          // 右侧：预览区域
          Expanded(
            child: _buildPreviewArea(),
          ),
        ],
      ),
    );
  }

  Widget _buildControlPanel() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 扫描仪选择
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.scanner, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      '扫描仪',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    if (_isDiscovering)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      IconButton(
                        icon: const Icon(Icons.refresh, size: 20),
                        onPressed: _discoverScanners,
                        tooltip: '刷新',
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                if (_selectedScanner == null)
                  const Text(
                    '未选择扫描仪',
                    style: TextStyle(color: Colors.grey),
                  )
                else
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(_getScannerIcon(_selectedScanner!.type)),
                    title: Text(_selectedScanner!.name),
                    subtitle: Text(
                      _selectedScanner!.connectionType ??
                          _selectedScanner!.ipAddress ??
                          '',
                    ),
                  ),
                if (_availableScanners.length > 1)
                  DropdownButtonFormField<String>(
                    value: _selectedScanner?.id,
                    decoration: const InputDecoration(
                      labelText: '切换扫描仪',
                      border: OutlineInputBorder(),
                    ),
                    items: _availableScanners
                        .map((scanner) => DropdownMenuItem(
                              value: scanner.id,
                              child: Text(scanner.name),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedScanner = _availableScanners.firstWhere(
                          (s) => s.id == value,
                        );
                        _loadDefaultSettings();
                      });
                    },
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // 扫描参数
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.settings, size: 20),
                    SizedBox(width: 8),
                    Text(
                      '扫描参数',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // 分辨率
                DropdownButtonFormField<int>(
                  value: _dpi,
                  decoration: const InputDecoration(
                    labelText: '分辨率 (DPI)',
                    border: OutlineInputBorder(),
                  ),
                  items: [75, 150, 300, 600]
                      .map((dpi) => DropdownMenuItem(
                            value: dpi,
                            child: Text('$dpi DPI'),
                          ))
                      .toList(),
                  onChanged: _isScanning
                      ? null
                      : (value) => setState(() => _dpi = value!),
                ),
                
                const SizedBox(height: 12),
                
                // 颜色模式
                DropdownButtonFormField<String>(
                  value: _colorMode,
                  decoration: const InputDecoration(
                    labelText: '颜色模式',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'color', child: Text('彩色')),
                    DropdownMenuItem(value: 'grayscale', child: Text('灰度')),
                    DropdownMenuItem(value: 'blackwhite', child: Text('黑白')),
                  ],
                  onChanged: _isScanning
                      ? null
                      : (value) => setState(() => _colorMode = value!),
                ),
                
                const SizedBox(height: 12),
                
                // ADF
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('使用自动进纸器 (ADF)'),
                  subtitle: const Text('用于批量扫描多页'),
                  value: _useAdf,
                  onChanged: _isScanning
                      ? null
                      : (value) => setState(() => _useAdf = value ?? false),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // 扫描按钮
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: _isScanning || _selectedScanner == null
                ? null
                : _startScan,
            icon: _isScanning
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.play_arrow),
            label: Text(_isScanning ? '扫描中...' : '开始扫描'),
          ),
        ),

        if (_previewImages.isNotEmpty) ...[
          const SizedBox(height: 16),
          
          // 预览控制
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.preview, size: 20),
                      SizedBox(width: 8),
                      Text(
                        '预览',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('共 ${_previewImages.length} 页'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: _currentPreviewIndex > 0
                            ? () => setState(() => _currentPreviewIndex--)
                            : null,
                      ),
                      Text('${_currentPreviewIndex + 1}'),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed:
                            _currentPreviewIndex < _previewImages.length - 1
                                ? () => setState(() => _currentPreviewIndex++)
                                : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _previewImages.removeAt(_currentPreviewIndex);
                          if (_currentPreviewIndex >= _previewImages.length) {
                            _currentPreviewIndex = _previewImages.length - 1;
                          }
                        });
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text('删除当前页'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPreviewArea() {
    if (_previewImages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.document_scanner,
              size: 120,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              '准备就绪',
              style: TextStyle(
                fontSize: 24,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '配置左侧参数后点击"开始扫描"',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // 预览工具栏
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.grey[200],
          child: Row(
            children: [
              Text(
                '第 ${_currentPreviewIndex + 1} 页 / 共 ${_previewImages.length} 页',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.zoom_in),
                onPressed: () {
                  // TODO: 实现缩放功能
                },
              ),
              IconButton(
                icon: const Icon(Icons.zoom_out),
                onPressed: () {
                  // TODO: 实现缩放功能
                },
              ),
              IconButton(
                icon: const Icon(Icons.rotate_right),
                onPressed: () {
                  // TODO: 实现旋转功能
                },
              ),
            ],
          ),
        ),
        
        // 预览图像
        Expanded(
          child: Container(
            color: Colors.grey[300],
            child: Center(
              child: Image.memory(
                _previewImages[_currentPreviewIndex],
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        
        // 缩略图列表
        if (_previewImages.length > 1)
          Container(
            height: 120,
            color: Colors.grey[200],
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8),
              itemCount: _previewImages.length,
              itemBuilder: (context, index) {
                final isSelected = index == _currentPreviewIndex;
                return GestureDetector(
                  onTap: () => setState(() => _currentPreviewIndex = index),
                  child: Container(
                    width: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey,
                        width: isSelected ? 3 : 1,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Image.memory(
                          _previewImages[index],
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: Colors.black54,
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  IconData _getScannerIcon(ScannerType type) {
    switch (type) {
      case ScannerType.network:
        return Icons.wifi;
      case ScannerType.usb:
        return Icons.usb;
      case ScannerType.camera:
        return Icons.camera_alt;
      default:
        return Icons.scanner;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}


