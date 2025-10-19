import 'package:flutter/material.dart';
import 'package:luna_arc_sync/core/animations/animations.dart';
import 'package:luna_arc_sync/core/cache/pdf_cache_service.dart';
import 'package:luna_arc_sync/core/cache/pdf_preload_manager.dart';
import 'package:luna_arc_sync/core/config/pdf_background_config.dart';

class PdfBackgroundSettingsPage extends StatefulWidget {
  const PdfBackgroundSettingsPage({super.key});

  @override
  State<PdfBackgroundSettingsPage> createState() => _PdfBackgroundSettingsPageState();
}

class _PdfBackgroundSettingsPageState extends State<PdfBackgroundSettingsPage> {
  Color _lightColor = PdfBackgroundConfig.defaultLightColor;
  Color _darkColor = PdfBackgroundConfig.defaultDarkColor;
  bool _enableBlur = false;
  PdfBackgroundPreset? _currentPreset;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final lightColor = await PdfBackgroundConfig.getLightColor();
    final darkColor = await PdfBackgroundConfig.getDarkColor();
    final enableBlur = await PdfBackgroundConfig.getEnableBlur();
    
    // 检查是否匹配某个预设
    final matchedPreset = PdfBackgroundPresets.matchPreset(lightColor, darkColor);
    
    if (mounted) {
      setState(() {
        _lightColor = lightColor;
        _darkColor = darkColor;
        _enableBlur = enableBlur;
        _currentPreset = matchedPreset;
        _isLoading = false;
      });
    }
  }

  Future<void> _applyPreset(PdfBackgroundPreset preset) async {
    setState(() {
      _lightColor = preset.lightColor;
      _darkColor = preset.darkColor;
      _currentPreset = preset;
    });
    
    await PdfBackgroundConfig.saveLightColor(preset.lightColor);
    await PdfBackgroundConfig.saveDarkColor(preset.darkColor);
    
    // 清除PDF缓存
    await _clearPdfCache();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('已应用「${preset.name}」预设')),
      );
    }
  }

  Future<void> _customizeLightColor() async {
    final color = await _showColorPicker(_lightColor, '浅色模式背景');
    if (color != null) {
      setState(() {
        _lightColor = color;
        _currentPreset = null; // 自定义后清除预设标记
      });
      await PdfBackgroundConfig.saveLightColor(color);
      await _clearPdfCache();
    }
  }

  Future<void> _customizeDarkColor() async {
    final color = await _showColorPicker(_darkColor, '深色模式背景');
    if (color != null) {
      setState(() {
        _darkColor = color;
        _currentPreset = null; // 自定义后清除预设标记
      });
      await PdfBackgroundConfig.saveDarkColor(color);
      await _clearPdfCache();
    }
  }

  Future<Color?> _showColorPicker(Color currentColor, String title) async {
    Color pickerColor = currentColor;
    double hue = HSVColor.fromColor(currentColor).hue;
    double saturation = HSVColor.fromColor(currentColor).saturation;
    double brightness = HSVColor.fromColor(currentColor).value;
    double alpha = currentColor.opacity;
    
    return showDialog<Color>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 颜色预览
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: pickerColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 16),
                
                // 色相滑块
                Row(
                  children: [
                    const Icon(Icons.palette, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Slider(
                        value: hue,
                        min: 0,
                        max: 360,
                        onChanged: (val) {
                          setState(() {
                            hue = val;
                            pickerColor = HSVColor.fromAHSV(alpha, hue, saturation, brightness).toColor();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                
                // 饱和度滑块
                Row(
                  children: [
                    const Icon(Icons.water_drop, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Slider(
                        value: saturation,
                        min: 0,
                        max: 1,
                        onChanged: (val) {
                          setState(() {
                            saturation = val;
                            pickerColor = HSVColor.fromAHSV(alpha, hue, saturation, brightness).toColor();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                
                // 明度滑块
                Row(
                  children: [
                    const Icon(Icons.brightness_6, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Slider(
                        value: brightness,
                        min: 0,
                        max: 1,
                        onChanged: (val) {
                          setState(() {
                            brightness = val;
                            pickerColor = HSVColor.fromAHSV(alpha, hue, saturation, brightness).toColor();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                
                // 透明度滑块
                Row(
                  children: [
                    const Icon(Icons.opacity, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Slider(
                        value: alpha,
                        min: 0,
                        max: 1,
                        onChanged: (val) {
                          setState(() {
                            alpha = val;
                            pickerColor = HSVColor.fromAHSV(alpha, hue, saturation, brightness).toColor();
                          });
                        },
                      ),
                    ),
                    Text('${(alpha * 100).toInt()}%'),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // 快速透明度按钮
                Wrap(
                  spacing: 8,
                  children: [
                    _QuickAlphaButton(
                      label: '不透明',
                      alpha: 255,
                      onPressed: () {
                        setState(() {
                          alpha = 1.0;
                          pickerColor = HSVColor.fromAHSV(alpha, hue, saturation, brightness).toColor();
                        });
                      },
                    ),
                    _QuickAlphaButton(
                      label: '75%',
                      alpha: 191,
                      onPressed: () {
                        setState(() {
                          alpha = 0.75;
                          pickerColor = HSVColor.fromAHSV(alpha, hue, saturation, brightness).toColor();
                        });
                      },
                    ),
                    _QuickAlphaButton(
                      label: '50%',
                      alpha: 128,
                      onPressed: () {
                        setState(() {
                          alpha = 0.5;
                          pickerColor = HSVColor.fromAHSV(alpha, hue, saturation, brightness).toColor();
                        });
                      },
                    ),
                    _QuickAlphaButton(
                      label: '透明',
                      alpha: 0,
                      onPressed: () {
                        setState(() {
                          alpha = 0.0;
                          pickerColor = HSVColor.fromAHSV(alpha, hue, saturation, brightness).toColor();
                        });
                      },
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // 颜色值显示
                Text(
                  '#${pickerColor.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(pickerColor),
              child: const Text('确定'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleBlur(bool value) async {
    setState(() {
      _enableBlur = value;
    });
    await PdfBackgroundConfig.saveEnableBlur(value);
    await _clearPdfCache();
  }

  Future<void> _resetToDefaults() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('重置为默认'),
        content: const Text('确定要重置为默认设置吗？这将清除所有PDF缓存。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('确定'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await PdfBackgroundConfig.resetToDefaults();
      await _clearPdfCache();
      await _loadSettings();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('已重置为默认设置')),
        );
      }
    }
  }

  Future<void> _clearPdfCache() async {
    try {
      // 清除磁盘缓存
      await PdfCacheService.clearAllCache();
      
      // 清除内存缓存
      PdfPreloadManager().clearMemoryCache();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('已清除PDF缓存（磁盘+内存），下次查看时将使用新的背景颜色'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('清除缓存失败: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('PDF背景颜色'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF背景颜色'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            tooltip: '重置为默认',
            onPressed: _resetToDefaults,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 当前预览
          AnimatedListItem(
            index: 0,
            delay: const Duration(milliseconds: 50),
            animationType: AnimationType.fadeSlideUp,
            child: _PreviewCard(
              lightColor: _lightColor,
              darkColor: _darkColor,
              currentPreset: _currentPreset,
              isDark: isDark,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // 自定义颜色
          AnimatedListItem(
            index: 1,
            delay: const Duration(milliseconds: 100),
            animationType: AnimationType.fadeSlideUp,
            child: Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.palette),
                    title: const Text('自定义颜色'),
                    subtitle: const Text('分别设置浅色和深色模式的背景颜色'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _ColorButton(
                            label: '浅色模式',
                            color: _lightColor,
                            onTap: _customizeLightColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _ColorButton(
                            label: '深色模式',
                            color: _darkColor,
                            onTap: _customizeDarkColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 毛玻璃效果
          AnimatedListItem(
            index: 2,
            delay: const Duration(milliseconds: 150),
            animationType: AnimationType.fadeSlideUp,
            child: Card(
              child: SwitchListTile(
                secondary: const Icon(Icons.blur_on),
                title: const Text('毛玻璃效果'),
                subtitle: const Text('在透明/半透明背景上应用模糊效果'),
                value: _enableBlur,
                onChanged: _toggleBlur,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // 预设标题
          AnimatedListItem(
            index: 3,
            delay: const Duration(milliseconds: 200),
            animationType: AnimationType.fadeSlideUp,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Text(
                '预设调色盘',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          // 预设网格
          ...List.generate(
            PdfBackgroundPresets.presets.length,
            (index) => AnimatedListItem(
              index: 4 + index,
              delay: Duration(milliseconds: 250 + index * 50),
              animationType: AnimationType.fadeSlideUp,
              child: _PresetCard(
                preset: PdfBackgroundPresets.presets[index],
                isSelected: _currentPreset?.name == PdfBackgroundPresets.presets[index].name,
                onTap: () => _applyPreset(PdfBackgroundPresets.presets[index]),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// 预览卡片
class _PreviewCard extends StatelessWidget {
  final Color lightColor;
  final Color darkColor;
  final PdfBackgroundPreset? currentPreset;
  final bool isDark;

  const _PreviewCard({
    required this.lightColor,
    required this.darkColor,
    required this.currentPreset,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final currentColor = isDark ? darkColor : lightColor;
    final opacity = currentColor.opacity;
    final isTransparent = opacity < 1.0;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.preview),
                const SizedBox(width: 8),
                Text(
                  '当前预览',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (currentPreset != null) ...[
                  const Spacer(),
                  Chip(
                    label: Text(currentPreset!.name),
                    avatar: Icon(currentPreset!.icon, size: 16),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: currentColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
                // 如果是透明的，显示棋盘格背景
                image: isTransparent
                    ? const DecorationImage(
                        image: AssetImage('assets/images/transparent_bg.png'),
                        repeat: ImageRepeat.repeat,
                      )
                    : null,
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white : Colors.black,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Sample PDF Text',
                    style: TextStyle(
                      color: isDark ? Colors.black : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _ColorInfo(label: '浅色', color: lightColor),
                const SizedBox(width: 16),
                _ColorInfo(label: '深色', color: darkColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 颜色信息显示
class _ColorInfo extends StatelessWidget {
  final String label;
  final Color color;

  const _ColorInfo({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final opacity = (color.opacity * 100).toStringAsFixed(0);
    
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                  ),
                ),
                if (color.opacity < 1.0)
                  Text(
                    '透明度: $opacity%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 颜色选择按钮
class _ColorButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ColorButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: color,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

/// 快速透明度按钮
class _QuickAlphaButton extends StatelessWidget {
  final String label;
  final int alpha;
  final VoidCallback onPressed;

  const _QuickAlphaButton({
    required this.label,
    required this.alpha,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

/// 预设卡片
class _PresetCard extends StatelessWidget {
  final PdfBackgroundPreset preset;
  final bool isSelected;
  final VoidCallback onTap;

  const _PresetCard({
    required this.preset,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected
          ? Theme.of(context).colorScheme.primaryContainer
          : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                preset.icon,
                size: 32,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      preset.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      preset.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  _ColorCircle(color: preset.lightColor),
                  const SizedBox(width: 4),
                  _ColorCircle(color: preset.darkColor),
                ],
              ),
              if (isSelected) ...[
                const SizedBox(width: 12),
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// 颜色圆圈
class _ColorCircle extends StatelessWidget {
  final Color color;

  const _ColorCircle({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey, width: 1),
      ),
    );
  }
}

