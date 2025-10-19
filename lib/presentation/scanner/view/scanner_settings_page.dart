import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luna_arc_sync/core/di/injection.dart';
import 'package:luna_arc_sync/core/scanner/scanner_config_service.dart';
import 'package:luna_arc_sync/core/scanner/scanner_service.dart';
import 'package:luna_arc_sync/presentation/scanner/cubit/scanner_management_cubit.dart';
import 'package:luna_arc_sync/presentation/scanner/cubit/scanner_management_state.dart';

class ScannerSettingsPage extends StatefulWidget {
  const ScannerSettingsPage({super.key});

  @override
  State<ScannerSettingsPage> createState() => _ScannerSettingsPageState();
}

class _ScannerSettingsPageState extends State<ScannerSettingsPage> {
  late final ScannerManagementCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ScannerManagementCubit>();
    _cubit.loadSavedScanners();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('打印机/扫描仪设置'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: '手动添加',
              onPressed: () => _showManualAddDialog(context),
            ),
          ],
        ),
        body: BlocBuilder<ScannerManagementCubit, ScannerManagementState>(
          builder: (context, state) {
            return state.when(
              initial: () => const Center(child: CircularProgressIndicator()),
              loading: () => const Center(child: CircularProgressIndicator()),
              discovering: (savedScanners) => _buildContent(
                context,
                savedScanners: savedScanners,
                discoveredScanners: [],
                isDiscovering: true,
              ),
              loaded: (savedScanners, discoveredScanners) => _buildContent(
                context,
                savedScanners: savedScanners,
                discoveredScanners: discoveredScanners,
                isDiscovering: false,
              ),
              error: (message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('错误: $message'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _cubit.loadSavedScanners(),
                      child: const Text('重试'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _cubit.discoverScanners(),
          icon: const Icon(Icons.search),
          label: const Text('发现设备'),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context, {
    required List<SavedScannerConfig> savedScanners,
    required List<ScannerInfo> discoveredScanners,
    required bool isDiscovering,
  }) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 已保存的扫描仪部分
        _buildSectionHeader('已配置的设备', Icons.bookmark),
        if (savedScanners.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text(
                  '暂无已配置的设备\n点击下方"发现设备"按钮开始',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          )
        else
          ...savedScanners.map((scanner) => _buildSavedScannerCard(context, scanner)),
        
        const SizedBox(height: 24),
        
        // 发现的扫描仪部分
        _buildSectionHeader('发现的设备', Icons.devices),
        if (isDiscovering)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('正在搜索设备...'),
                  ],
                ),
              ),
            ),
          )
        else if (discoveredScanners.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text(
                  '未发现新设备',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          )
        else
          ...discoveredScanners
              .where((discovered) => !savedScanners.any((saved) => saved.id == discovered.id))
              .map((scanner) => _buildDiscoveredScannerCard(context, scanner)),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedScannerCard(BuildContext context, SavedScannerConfig scanner) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(_getScannerIcon(scanner.type)),
        ),
        title: Text(scanner.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(scanner.connectionType ?? scanner.type.toString()),
            if (scanner.ipAddress != null)
              Text('${scanner.ipAddress}:${scanner.port}', style: const TextStyle(fontSize: 12)),
            Text(
              '默认: ${scanner.defaultDpi} DPI, ${_getColorModeLabel(scanner.defaultColorMode)}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (scanner.isDefault)
              const Chip(
                label: Text('默认', style: TextStyle(fontSize: 12)),
                padding: EdgeInsets.symmetric(horizontal: 8),
              ),
            PopupMenuButton<String>(
              onSelected: (value) => _handleScannerAction(context, scanner, value),
              itemBuilder: (context) => [
                if (!scanner.isDefault)
                  const PopupMenuItem(
                    value: 'set_default',
                    child: Text('设为默认'),
                  ),
                const PopupMenuItem(
                  value: 'edit',
                  child: Text('编辑配置'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('删除'),
                ),
              ],
            ),
          ],
        ),
        onTap: () => _showScannerDetails(context, scanner),
      ),
    );
  }

  Widget _buildDiscoveredScannerCard(BuildContext context, ScannerInfo scanner) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.withOpacity(0.2),
          child: Icon(_getScannerIcon(scanner.type), color: Colors.green),
        ),
        title: Text(scanner.name),
        subtitle: Text(scanner.connectionType ?? scanner.ipAddress ?? scanner.type.toString()),
        trailing: ElevatedButton.icon(
          onPressed: () => _cubit.addDiscoveredScanner(scanner),
          icon: const Icon(Icons.add, size: 16),
          label: const Text('添加'),
        ),
      ),
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

  String _getColorModeLabel(String mode) {
    switch (mode) {
      case 'color':
        return '彩色';
      case 'grayscale':
        return '灰度';
      case 'blackwhite':
        return '黑白';
      default:
        return mode;
    }
  }

  void _handleScannerAction(BuildContext context, SavedScannerConfig scanner, String action) {
    switch (action) {
      case 'set_default':
        _cubit.setDefaultScanner(scanner.id);
        break;
      case 'edit':
        _showEditScannerDialog(context, scanner);
        break;
      case 'delete':
        _showDeleteConfirmDialog(context, scanner);
        break;
    }
  }

  void _showScannerDetails(BuildContext context, SavedScannerConfig scanner) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(scanner.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('设备 ID', scanner.id),
              _buildDetailRow('类型', scanner.type.toString()),
              if (scanner.ipAddress != null)
                _buildDetailRow('IP 地址', scanner.ipAddress!),
              if (scanner.port != null)
                _buildDetailRow('端口', scanner.port.toString()),
              if (scanner.connectionType != null)
                _buildDetailRow('连接类型', scanner.connectionType!),
              const Divider(),
              _buildDetailRow('默认分辨率', '${scanner.defaultDpi} DPI'),
              _buildDetailRow('默认颜色模式', _getColorModeLabel(scanner.defaultColorMode)),
              _buildDetailRow('自动进纸器', scanner.defaultAdf ? '启用' : '禁用'),
              const Divider(),
              _buildDetailRow('最后使用', _formatDateTime(scanner.lastUsed)),
              _buildDetailRow('默认设备', scanner.isDefault ? '是' : '否'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showEditScannerDialog(context, scanner);
            },
            child: const Text('编辑'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} 天前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} 小时前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} 分钟前';
    } else {
      return '刚刚';
    }
  }

  void _showEditScannerDialog(BuildContext context, SavedScannerConfig scanner) {
    final nameController = TextEditingController(text: scanner.name);
    int selectedDpi = scanner.defaultDpi;
    String selectedColorMode = scanner.defaultColorMode;
    bool useAdf = scanner.defaultAdf;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('编辑扫描仪配置'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: '设备名称',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: selectedDpi,
                  decoration: const InputDecoration(
                    labelText: '默认分辨率 (DPI)',
                    border: OutlineInputBorder(),
                  ),
                  items: [75, 150, 300, 600]
                      .map((dpi) => DropdownMenuItem(
                            value: dpi,
                            child: Text('$dpi DPI'),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => selectedDpi = value!),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedColorMode,
                  decoration: const InputDecoration(
                    labelText: '默认颜色模式',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'color', child: Text('彩色')),
                    DropdownMenuItem(value: 'grayscale', child: Text('灰度')),
                    DropdownMenuItem(value: 'blackwhite', child: Text('黑白')),
                  ],
                  onChanged: (value) => setState(() => selectedColorMode = value!),
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('默认启用自动进纸器 (ADF)'),
                  value: useAdf,
                  onChanged: (value) => setState(() => useAdf = value ?? false),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                _cubit.updateScannerConfig(
                  scannerId: scanner.id,
                  name: nameController.text,
                  defaultDpi: selectedDpi,
                  defaultColorMode: selectedColorMode,
                  defaultAdf: useAdf,
                );
                Navigator.of(context).pop();
              },
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, SavedScannerConfig scanner) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除扫描仪 "${scanner.name}" 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              _cubit.removeScannerConfig(scanner.id);
              Navigator.of(context).pop();
            },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  void _showManualAddDialog(BuildContext context) {
    final nameController = TextEditingController();
    final ipController = TextEditingController();
    final portController = TextEditingController(text: '80');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('手动添加网络扫描仪'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: '设备名称',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: ipController,
              decoration: const InputDecoration(
                labelText: 'IP 地址',
                hintText: '例如: 192.168.1.100',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: portController,
              decoration: const InputDecoration(
                labelText: '端口',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              final config = SavedScannerConfig(
                id: '${ipController.text}:${portController.text}',
                name: nameController.text.isEmpty ? '网络扫描仪' : nameController.text,
                type: ScannerType.network,
                ipAddress: ipController.text,
                port: int.tryParse(portController.text) ?? 80,
                connectionType: 'eSCL/Network',
                lastUsed: DateTime.now(),
              );
              _cubit.saveScannerConfig(config);
              Navigator.of(context).pop();
            },
            child: const Text('添加'),
          ),
        ],
      ),
    );
  }
}


