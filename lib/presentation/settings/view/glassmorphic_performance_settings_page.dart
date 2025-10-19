import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:luna_arc_sync/core/theme/glassmorphic_performance_notifier.dart';
import 'package:luna_arc_sync/core/performance/glassmorphic_performance_monitor.dart';
import 'package:luna_arc_sync/core/cache/glassmorphic_cache.dart';
import 'package:luna_arc_sync/core/effects/kawase_blur.dart';

/// 毛玻璃性能设置页面
class GlassmorphicPerformanceSettingsPage extends StatefulWidget {
  const GlassmorphicPerformanceSettingsPage({super.key});

  @override
  State<GlassmorphicPerformanceSettingsPage> createState() => _GlassmorphicPerformanceSettingsPageState();
}

class _GlassmorphicPerformanceSettingsPageState extends State<GlassmorphicPerformanceSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('毛玻璃性能设置'),
        elevation: 0,
      ),
      body: Consumer<GlassmorphicPerformanceNotifier>(
        builder: (context, notifier, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPerformanceLevelSection(context, notifier),
                const SizedBox(height: 24),
                _buildCustomSettingsSection(context, notifier),
                const SizedBox(height: 24),
                _buildOptimizationSection(context, notifier),
                const SizedBox(height: 24),
                _buildPerformanceAdviceSection(context, notifier),
                const SizedBox(height: 24),
                _buildBlurMethodSection(context, notifier),
                const SizedBox(height: 24),
                _buildCacheStatsSection(context, notifier),
                const SizedBox(height: 24),
                _buildPerformanceMonitorSection(context),
                const SizedBox(height: 24),
                _buildResetSection(context, notifier),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPerformanceLevelSection(
    BuildContext context,
    GlassmorphicPerformanceNotifier notifier,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '性能等级',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              notifier.config.getLevelDescription(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            ...GlassmorphicPerformanceLevel.values.map((level) {
              return RadioListTile<GlassmorphicPerformanceLevel>(
                title: Text(_getLevelTitle(level)),
                subtitle: Text(_getLevelSubtitle(level)),
                value: level,
                groupValue: notifier.config.level,
                onChanged: (value) {
                  if (value != null) {
                    notifier.setPerformanceLevel(value);
                  }
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomSettingsSection(
    BuildContext context,
    GlassmorphicPerformanceNotifier notifier,
  ) {
    if (notifier.config.level != GlassmorphicPerformanceLevel.custom) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '自定义设置',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSliderSetting(
              context,
              '模糊强度',
              notifier.config.blurIntensity,
              (value) => notifier.updateBlurIntensity(value),
              '控制毛玻璃效果的模糊程度',
            ),
            const SizedBox(height: 16),
            _buildSliderSetting(
              context,
              '不透明度强度',
              notifier.config.opacityIntensity,
              (value) => notifier.updateOpacityIntensity(value),
              '控制毛玻璃效果的透明度',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptimizationSection(
    BuildContext context,
    GlassmorphicPerformanceNotifier notifier,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '性能优化',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('使用共享模糊'),
              subtitle: const Text('多个组件共享模糊效果，提升性能'),
              value: notifier.config.useSharedBlur,
              onChanged: (value) => notifier.toggleSharedBlur(),
            ),
            SwitchListTile(
              title: const Text('启用列表优化'),
              subtitle: const Text('长列表自动降低毛玻璃效果强度'),
              value: notifier.config.enableListOptimization,
              onChanged: (value) => notifier.toggleListOptimization(),
            ),
            if (notifier.config.enableListOptimization) ...[
              const SizedBox(height: 8),
              _buildSliderSetting(
                context,
                '最大列表项数量',
                notifier.config.maxListItems.toDouble(),
                (value) => notifier.setMaxListItems(value.round()),
                '超过此数量的列表项将降低毛玻璃效果',
                min: 10,
                max: 100,
                divisions: 9,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceAdviceSection(
    BuildContext context,
    GlassmorphicPerformanceNotifier notifier,
  ) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '性能建议',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              notifier.getPerformanceAdvice(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlurMethodSection(
    BuildContext context,
    GlassmorphicPerformanceNotifier notifier,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.blur_on,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '模糊方法',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // 模糊方法选择
            Text(
              '选择模糊算法',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<BlurMethod>(
                    title: const Text('高斯模糊'),
                    subtitle: const Text('标准模糊算法，兼容性好'),
                    value: BlurMethod.gaussian,
                    groupValue: notifier.config.blurMethod,
                    onChanged: (value) {
                      if (value != null) {
                        notifier.updateBlurMethod(value);
                      }
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<BlurMethod>(
                    title: const Text('双Kawase模糊'),
                    subtitle: const Text('高效模糊算法，性能更好'),
                    value: BlurMethod.kawase,
                    groupValue: notifier.config.blurMethod,
                    onChanged: (value) {
                      if (value != null) {
                        notifier.updateBlurMethod(value);
                      }
                    },
                  ),
                ),
              ],
            ),
            
            // Kawase模糊预设选择
            if (notifier.config.blurMethod == BlurMethod.kawase) ...[
              const SizedBox(height: 16),
              Text(
                'Kawase模糊预设',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: KawaseBlurPreset.values.map((preset) {
                  final isSelected = notifier.config.kawasePreset == preset;
                  return FilterChip(
                    label: Text(_getKawasePresetLabel(preset)),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        notifier.updateKawasePreset(preset);
                      }
                    },
                  );
                }).toList(),
              ),
              
              // Kawase配置详情
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '当前配置',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Builder(
                      builder: (context) {
                        final config = notifier.config.getKawaseConfig();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('模糊半径: ${config.radius.toStringAsFixed(1)}'),
                            Text('模糊通道: ${config.passes}'),
                            Text('缩放因子: ${config.scaleFactor.toStringAsFixed(2)}'),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getKawasePresetLabel(KawaseBlurPreset preset) {
    switch (preset) {
      case KawaseBlurPreset.light:
        return '轻微';
      case KawaseBlurPreset.medium:
        return '中等';
      case KawaseBlurPreset.strong:
        return '强烈';
      case KawaseBlurPreset.ultra:
        return '超强';
    }
  }

  Widget _buildCacheStatsSection(
    BuildContext context,
    GlassmorphicPerformanceNotifier notifier,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '缓存统计',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    // 刷新缓存统计
                    setState(() {});
                  },
                  tooltip: '刷新统计信息',
                ),
              ],
            ),
            const SizedBox(height: 16),
            FutureBuilder<Map<String, dynamic>>(
              future: Future.value(notifier.getCacheStats()),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final stats = snapshot.data!;
                  return Column(
                    children: [
                      _buildStatRow(
                        context,
                        '缓存项数量',
                        '${stats['cacheSize'] ?? 0} / ${stats['maxCacheSize'] ?? 20}',
                        Icons.storage,
                      ),
                      const SizedBox(height: 8),
                      _buildStatRow(
                        context,
                        '最后清理时间',
                        stats['lastCleanup'] != null 
                            ? _formatDateTime(stats['lastCleanup'])
                            : '从未清理',
                        Icons.cleaning_services,
                      ),
                      const SizedBox(height: 16),
                      if (stats['items'] != null && (stats['items'] as List).isNotEmpty) ...[
                        Text(
                          '缓存项详情',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListView.builder(
                            itemCount: (stats['items'] as List).length,
                            itemBuilder: (context, index) {
                              final item = (stats['items'] as List)[index];
                              return ListTile(
                                dense: true,
                                title: Text(
                                  item['key'] ?? 'Unknown',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                subtitle: Text(
                                  '访问次数: ${item['accessCount'] ?? 0}',
                                  style: const TextStyle(fontSize: 10),
                                ),
                                trailing: item['isExpired'] == true
                                    ? const Icon(Icons.warning, color: Colors.orange, size: 16)
                                    : const Icon(Icons.check_circle, color: Colors.green, size: 16),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      notifier.clearCache();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('缓存已清理')),
                      );
                    },
                    icon: const Icon(Icons.clear_all),
                    label: const Text('清理缓存'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await notifier.warmupCache();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('缓存已预热')),
                      );
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('预热缓存'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      final monitor = GlassmorphicPerformanceMonitor();
                      monitor.addTestData();
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('测试数据已添加')),
                      );
                    },
                    icon: const Icon(Icons.science),
                    label: const Text('添加测试数据'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  String _formatDateTime(dynamic dateTime) {
    if (dateTime is DateTime) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
    return '未知';
  }

  Widget _buildPerformanceMonitorSection(BuildContext context) {
    final monitor = GlassmorphicPerformanceMonitor();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.speed,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '性能监控',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    // 刷新性能统计
                  },
                  tooltip: '刷新性能统计',
                ),
              ],
            ),
            const SizedBox(height: 16),
            FutureBuilder<GlassmorphicPerformanceStats>(
              future: Future.value(monitor.getPerformanceStats()),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final stats = snapshot.data!;
                  return Column(
                    children: [
                      // 性能分数
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _getPerformanceScoreColor(stats.performanceScore).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getPerformanceScoreColor(stats.performanceScore),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _getPerformanceScoreIcon(stats.performanceScore),
                              color: _getPerformanceScoreColor(stats.performanceScore),
                              size: 32,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '性能评分',
                                    style: Theme.of(context).textTheme.titleSmall,
                                  ),
                                  Text(
                                    '${stats.performanceScore.toStringAsFixed(1)}/100',
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: _getPerformanceScoreColor(stats.performanceScore),
                                    ),
                                  ),
                                  Text(
                                    stats.getPerformanceGrade(),
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: _getPerformanceScoreColor(stats.performanceScore),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // 渲染统计
                      _buildStatRow(
                        context,
                        '总渲染次数',
                        '${stats.totalRenders}',
                        Icons.auto_awesome,
                      ),
                      _buildStatRow(
                        context,
                        '平均渲染时间',
                        '${stats.averageRenderTime.toStringAsFixed(1)}ms',
                        Icons.timer,
                      ),
                      _buildStatRow(
                        context,
                        '最大渲染时间',
                        '${stats.maxRenderTime.toStringAsFixed(1)}ms',
                        Icons.trending_up,
                      ),
                      _buildStatRow(
                        context,
                        '最小渲染时间',
                        '${stats.minRenderTime.toStringAsFixed(1)}ms',
                        Icons.trending_down,
                      ),
                      _buildStatRow(
                        context,
                        '共享模糊使用率',
                        '${(stats.sharedBlurUsage / stats.totalRenders * 100).toStringAsFixed(1)}%',
                        Icons.share,
                      ),
                      _buildStatRow(
                        context,
                        '缓存命中率',
                        '${(stats.cacheHits / stats.totalRenders * 100).toStringAsFixed(1)}%',
                        Icons.cached,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // 性能建议
                      if (stats.getPerformanceRecommendations().isNotEmpty) ...[
                        Text(
                          '性能建议',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...stats.getPerformanceRecommendations().map((recommendation) => 
                          Container(
                            margin: const EdgeInsets.only(bottom: 4),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.orange.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.lightbulb_outline, color: Colors.orange, size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    recommendation,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      monitor.clearAllData();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('性能数据已清理')),
                      );
                    },
                    icon: const Icon(Icons.clear_all),
                    label: const Text('清理数据'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // 显示详细性能报告
                      _showPerformanceReport(context, monitor);
                    },
                    icon: const Icon(Icons.analytics),
                    label: const Text('详细报告'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getPerformanceScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  IconData _getPerformanceScoreIcon(double score) {
    if (score >= 80) return Icons.check_circle;
    if (score >= 60) return Icons.warning;
    return Icons.error;
  }

  void _showPerformanceReport(BuildContext context, GlassmorphicPerformanceMonitor monitor) {
    final stats = monitor.getPerformanceStats();
    final recentData = monitor.getRecentData(count: 20);
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 500),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.analytics,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '详细性能报告',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 组件类型统计
                      Text(
                        '组件类型分布',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...stats.componentTypeCounts.entries.map((entry) => 
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(entry.key),
                              Text('${entry.value}次'),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // 模糊组统计
                      Text(
                        '模糊组分布',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...stats.blurGroupCounts.entries.map((entry) => 
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(entry.key),
                              Text('${entry.value}次'),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // 最近渲染记录
                      Text(
                        '最近渲染记录',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...recentData.take(10).map((data) => 
                        Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${data.componentType} (${data.blurGroup})',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              Text(
                                '${data.renderTimeMs}ms',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: data.renderTimeMs > 16 ? Colors.red : Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Actions
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('关闭'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResetSection(
    BuildContext context,
    GlassmorphicPerformanceNotifier notifier,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '重置设置',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '将毛玻璃性能设置重置为默认值',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('重置设置'),
                      content: const Text('确定要重置毛玻璃性能设置吗？'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('取消'),
                        ),
                        TextButton(
                          onPressed: () {
                            notifier.resetToDefault();
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('设置已重置')),
                            );
                          },
                          child: const Text('确定'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.restore),
                label: const Text('重置为默认设置'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderSetting(
    BuildContext context,
    String title,
    double value,
    ValueChanged<double> onChanged,
    String subtitle, {
    double min = 0.0,
    double max = 1.0,
    int divisions = 10,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              '${(value * 100).round()}%',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ],
    );
  }

  String _getLevelTitle(GlassmorphicPerformanceLevel level) {
    switch (level) {
      case GlassmorphicPerformanceLevel.disabled:
        return '禁用';
      case GlassmorphicPerformanceLevel.low:
        return '低性能';
      case GlassmorphicPerformanceLevel.medium:
        return '平衡';
      case GlassmorphicPerformanceLevel.high:
        return '高质量';
      case GlassmorphicPerformanceLevel.custom:
        return '自定义';
    }
  }

  String _getLevelSubtitle(GlassmorphicPerformanceLevel level) {
    switch (level) {
      case GlassmorphicPerformanceLevel.disabled:
        return '最佳性能，无毛玻璃效果';
      case GlassmorphicPerformanceLevel.low:
        return '轻微毛玻璃效果，适合低端设备';
      case GlassmorphicPerformanceLevel.medium:
        return '标准毛玻璃效果，平衡性能和视觉效果';
      case GlassmorphicPerformanceLevel.high:
        return '强毛玻璃效果，适合高端设备';
      case GlassmorphicPerformanceLevel.custom:
        return '用户自定义设置';
    }
  }
}
