import 'package:flutter/material.dart';
import 'package:luna_arc_sync/core/rendering/shared_blur_layer_manager.dart';
import 'package:luna_arc_sync/presentation/widgets/optimized_glassmorphic_container.dart';
import 'package:luna_arc_sync/core/config/glassmorphic_presets.dart';

/// 共享渲染性能对比工具
/// 
/// 用于演示和对比独立渲染和共享渲染的性能差异
class SharedBlurPerformanceComparison extends StatefulWidget {
  const SharedBlurPerformanceComparison({super.key});
  
  @override
  State<SharedBlurPerformanceComparison> createState() => 
      _SharedBlurPerformanceComparisonState();
}

class _SharedBlurPerformanceComparisonState 
    extends State<SharedBlurPerformanceComparison> {
  final _collector = SharedBlurPerformanceCollector();
  bool _showSharedMode = true;
  int _itemCount = 20;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('共享渲染性能对比'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            tooltip: '查看统计',
            onPressed: _showStatistics,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildControls(),
          Expanded(
            child: Row(
              children: [
                // 左侧：独立渲染模式
                Expanded(
                  child: _buildIndependentMode(),
                ),
                const VerticalDivider(width: 1),
                // 右侧：共享渲染模式
                Expanded(
                  child: _buildSharedMode(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildControls() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '性能对比设置',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('项目数量: '),
                Expanded(
                  child: Slider(
                    value: _itemCount.toDouble(),
                    min: 5,
                    max: 100,
                    divisions: 19,
                    label: _itemCount.toString(),
                    onChanged: (value) {
                      setState(() {
                        _itemCount = value.toInt();
                      });
                    },
                  ),
                ),
                Text('$_itemCount'),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.cleaning_services),
                  label: const Text('清除统计'),
                  onPressed: () {
                    _collector.clearStats();
                    setState(() {});
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.report),
                  label: const Text('生成报告'),
                  onPressed: _showStatistics,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildIndependentMode() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.red.withOpacity(0.1),
          child: Row(
            children: [
              const Icon(Icons.warning_amber, color: Colors.red),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '独立渲染模式\n每个组件独立创建 BackdropFilter',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _itemCount,
            itemBuilder: (context, index) {
              return OptimizedGlassmorphicContainer(
                blur: GlassmorphicPresets.documentListBlur,
                opacity: GlassmorphicPresets.documentListOpacity,
                useSharedBlur: false, // 禁用共享渲染
                borderRadius: BorderRadius.circular(8),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.document_scanner),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('独立渲染项目 ${index + 1}'),
                          Text(
                            '每个项目都有独立的 BackdropFilter',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        _buildModeStats('independent'),
      ],
    );
  }
  
  Widget _buildSharedMode() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.green.withOpacity(0.1),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '共享渲染模式\n所有组件共享一个 BackdropFilter',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SharedBlurLayerProvider(
            layerId: 'comparison_shared',
            blur: GlassmorphicPresets.documentListBlur,
            backgroundOpacity: 0.02,
            child: ListView.builder(
              itemCount: _itemCount,
              itemBuilder: (context, index) {
                return OptimizedGlassmorphicContainer(
                  blur: GlassmorphicPresets.documentListBlur,
                  opacity: GlassmorphicPresets.documentListOpacity,
                  useSharedBlur: true, // 启用共享渲染
                  blurGroup: 'comparison_shared',
                  borderRadius: BorderRadius.circular(8),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.document_scanner),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('共享渲染项目 ${index + 1}'),
                            Text(
                              '共享一个 BackdropFilter，性能更优',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        _buildModeStats('comparison_shared'),
      ],
    );
  }
  
  Widget _buildModeStats(String layerId) {
    final stats = _collector.getStats(layerId);
    
    if (stats == null) {
      return Container(
        padding: const EdgeInsets.all(8),
        color: Colors.grey.withOpacity(0.1),
        child: const Text(
          '暂无统计数据',
          style: TextStyle(fontSize: 12),
        ),
      );
    }
    
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.grey.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '组件数: ${stats.componentCount} | '
            '平均渲染: ${stats.averageRenderTimeMs.toStringAsFixed(2)}ms | '
            '预估提升: ${stats.estimatePerformanceGain().toStringAsFixed(1)}%',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
  
  void _showStatistics() {
    final report = _collector.generateReport();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('性能统计报告'),
        content: SingleChildScrollView(
          child: SelectableText(
            report,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // 复制到剪贴板
              Navigator.pop(context);
            },
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
}

/// 性能测试演示页面
class PerformanceTestDemo extends StatefulWidget {
  const PerformanceTestDemo({super.key});
  
  @override
  State<PerformanceTestDemo> createState() => _PerformanceTestDemoState();
}

class _PerformanceTestDemoState extends State<PerformanceTestDemo> {
  int _mode = 0; // 0: 无优化, 1: 缓存优化, 2: 共享渲染
  final _stopwatch = Stopwatch();
  String _buildTime = '未测量';
  
  final List<String> _modeNames = [
    '无优化（每次创建新 ImageFilter）',
    '缓存优化（复用 ImageFilter）',
    '共享渲染（单一 BackdropFilter）',
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('性能测试演示'),
      ),
      body: Column(
        children: [
          _buildModeSelector(),
          _buildPerformanceInfo(),
          Expanded(
            child: _buildContentForMode(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildModeSelector() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '选择渲染模式',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('无优化'), icon: Icon(Icons.close)),
                ButtonSegment(value: 1, label: Text('缓存'), icon: Icon(Icons.cached)),
                ButtonSegment(value: 2, label: Text('共享'), icon: Icon(Icons.share)),
              ],
              selected: {_mode},
              onSelectionChanged: (Set<int> newSelection) {
                setState(() {
                  _mode = newSelection.first;
                  _measureBuildTime();
                });
              },
            ),
            const SizedBox(height: 8),
            Text(
              _modeNames[_mode],
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPerformanceInfo() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.blue.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.timer, color: Colors.blue),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '构建时间',
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    _buildTime,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('重新测量'),
              onPressed: () {
                setState(() {
                  _measureBuildTime();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildContentForMode() {
    switch (_mode) {
      case 0:
        return _buildUnoptimizedList();
      case 1:
        return _buildCachedList();
      case 2:
        return _buildSharedList();
      default:
        return const SizedBox();
    }
  }
  
  Widget _buildUnoptimizedList() {
    return ListView.builder(
      itemCount: 50,
      itemBuilder: (context, index) {
        // 模拟无优化：每次都创建新的容器（实际上我们的组件已经优化了，这里只是演示）
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Text('无优化项目 ${index + 1}'),
        );
      },
    );
  }
  
  Widget _buildCachedList() {
    return ListView.builder(
      itemCount: 50,
      itemBuilder: (context, index) {
        return OptimizedGlassmorphicContainer(
          blur: 8.0,
          opacity: 0.15,
          useSharedBlur: false, // 使用缓存但不共享渲染
          borderRadius: BorderRadius.circular(8),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.all(16),
          child: Text('缓存优化项目 ${index + 1}'),
        );
      },
    );
  }
  
  Widget _buildSharedList() {
    return SharedBlurLayerProvider(
      layerId: 'demo_shared',
      blur: 8.0,
      child: ListView.builder(
        itemCount: 50,
        itemBuilder: (context, index) {
          return OptimizedGlassmorphicContainer(
            blur: 8.0,
            opacity: 0.15,
            useSharedBlur: true,
            blurGroup: 'demo_shared',
            borderRadius: BorderRadius.circular(8),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            padding: const EdgeInsets.all(16),
            child: Text('共享渲染项目 ${index + 1}'),
          );
        },
      ),
    );
  }
  
  void _measureBuildTime() {
    _stopwatch.reset();
    _stopwatch.start();
    
    // 在下一帧测量
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _stopwatch.stop();
      setState(() {
        _buildTime = '${_stopwatch.elapsedMilliseconds} ms';
      });
    });
  }
}

