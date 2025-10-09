import 'package:flutter/material.dart';
import 'package:luna_arc_sync/l10n/app_localizations.dart';
import '../widgets/simple_animated_logo.dart';

class SimpleAnimationExamplePage extends StatefulWidget {
  const SimpleAnimationExamplePage({super.key});

  @override
  State<SimpleAnimationExamplePage> createState() => _SimpleAnimationExamplePageState();
}

class _SimpleAnimationExamplePageState extends State<SimpleAnimationExamplePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.simpleAnimationExampleTitle),
        backgroundColor: Colors.blue[100],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 基础旋转动画
            _buildAnimationCard(
              title: '旋转动画',
              description: 'Logo持续旋转',
              child: const SimpleAnimatedLogo(
                size: 120,
                enableRotation: true,
                enableScale: false,
                enableFade: false,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 缩放动画
            _buildAnimationCard(
              title: '缩放动画',
              description: 'Logo大小周期性变化',
              child: const SimpleAnimatedLogo(
                size: 120,
                enableRotation: false,
                enableScale: true,
                enableFade: false,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 淡入淡出动画
            _buildAnimationCard(
              title: '淡入淡出动画',
              description: 'Logo透明度周期性变化',
              child: const SimpleAnimatedLogo(
                size: 120,
                enableRotation: false,
                enableScale: false,
                enableFade: true,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 组合动画
            _buildAnimationCard(
              title: '组合动画',
              description: '旋转 + 缩放 + 淡入淡出',
              child: const SimpleAnimatedLogo(
                size: 120,
                enableRotation: true,
                enableScale: true,
                enableFade: true,
                duration: Duration(seconds: 3),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 脉冲动画
            _buildAnimationCard(
              title: '脉冲动画',
              description: '呼吸灯效果',
              child: const PulsingLogo(
                size: 120,
                duration: Duration(seconds: 2),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 摇摆动画
            _buildAnimationCard(
              title: '摇摆动画',
              description: '左右摇摆效果',
              child: const WobblingLogo(
                size: 120,
                duration: Duration(milliseconds: 800),
                wobbleAngle: 0.2,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 彩色动画
            _buildAnimationCard(
              title: '彩色动画',
              description: '带颜色变化的旋转动画',
              child: const SimpleAnimatedLogo(
                size: 120,
                enableRotation: true,
                color: Colors.blue,
                duration: Duration(seconds: 2),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 快速动画
            _buildAnimationCard(
              title: '快速动画',
              description: '快速旋转效果',
              child: const SimpleAnimatedLogo(
                size: 120,
                enableRotation: true,
                duration: Duration(milliseconds: 500),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 慢速动画
            _buildAnimationCard(
              title: '慢速动画',
              description: '缓慢优雅的动画',
              child: const SimpleAnimatedLogo(
                size: 120,
                enableRotation: true,
                enableScale: true,
                duration: Duration(seconds: 5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimationCard({
    required String title,
    required String description,
    required Widget child,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Center(child: child),
          ],
        ),
      ),
    );
  }
}
