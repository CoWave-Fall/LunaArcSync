import 'package:flutter/material.dart';
import 'package:luna_arc_sync/l10n/app_localizations.dart';
import '../widgets/animated_logo_widget.dart';

class SvgAnimationDemoPage extends StatefulWidget {
  const SvgAnimationDemoPage({super.key});

  @override
  State<SvgAnimationDemoPage> createState() => _SvgAnimationDemoPageState();
}

class _SvgAnimationDemoPageState extends State<SvgAnimationDemoPage> {
  bool _enableAnimation = true;
  double _logoSize = 150.0;
  final Duration _animationDuration = const Duration(seconds: 2);
  final List<AnimationType> _selectedAnimations = [
    AnimationType.rotation,
    AnimationType.scale,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.svgAnimationDemoTitle),
        backgroundColor: Colors.blue[100],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 控制面板
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '动画控制',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    
                    // 启用/禁用动画
                    SwitchListTile(
                      title: Text(AppLocalizations.of(context)!.svgAnimationEnableAnimation),
                      value: _enableAnimation,
                      onChanged: (value) {
                        setState(() {
                          _enableAnimation = value;
                        });
                      },
                    ),
                    
                    // 大小控制
                    Text(AppLocalizations.of(context)!.svgAnimationLogoSize(_logoSize.toInt().toString())),
                    Slider(
                      value: _logoSize,
                      min: 50.0,
                      max: 300.0,
                      divisions: 25,
                      onChanged: (value) {
                        setState(() {
                          _logoSize = value;
                        });
                      },
                    ),
                    
                    // 动画类型选择
                    Text(
                      '动画类型:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Wrap(
                      spacing: 8.0,
                      children: AnimationType.values.map((type) {
                        return FilterChip(
                          label: Text(_getAnimationTypeName(type)),
                          selected: _selectedAnimations.contains(type),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedAnimations.add(type);
                              } else {
                                _selectedAnimations.remove(type);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 动画演示区域
            Center(
              child: Column(
                children: [
                  Text(
                    '点击Logo控制动画',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  
                  // 基础动画Logo
                  AnimatedLogoWidget(
                    size: _logoSize,
                    enableAnimation: _enableAnimation,
                    animationDuration: _animationDuration,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  Text(
                    '自定义动画组合',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  
                  // 自定义动画SVG
                  CustomAnimatedSvg(
                    assetPath: 'assets/images/logo.svg',
                    size: _logoSize,
                    duration: _animationDuration,
                    animationTypes: _selectedAnimations,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  Text(
                    '粒子效果动画',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  
                  // 粒子效果动画
                  ParticleAnimatedSvg(
                    assetPath: 'assets/images/logo.svg',
                    size: _logoSize,
                    particleCount: 15,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // 动画说明
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '动画效果说明',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    
                    _buildAnimationDescription(
                      '旋转动画',
                      '整个Logo围绕中心点旋转',
                      Icons.rotate_right,
                    ),
                    
                    _buildAnimationDescription(
                      '缩放动画',
                      'Logo大小周期性变化',
                      Icons.zoom_in,
                    ),
                    
                    _buildAnimationDescription(
                      '淡入淡出',
                      '透明度周期性变化',
                      Icons.opacity,
                    ),
                    
                    _buildAnimationDescription(
                      '位移动画',
                      'Logo位置周期性移动',
                      Icons.open_with,
                    ),
                    
                    _buildAnimationDescription(
                      '粒子效果',
                      '围绕Logo的粒子动画',
                      Icons.auto_awesome,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimationDescription(String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getAnimationTypeName(AnimationType type) {
    switch (type) {
      case AnimationType.rotation:
        return '旋转';
      case AnimationType.scale:
        return '缩放';
      case AnimationType.fade:
        return '淡入淡出';
      case AnimationType.translate:
        return '位移';
    }
  }
}
