import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnimatedLogoWidget extends StatefulWidget {
  final double size;
  final bool enableAnimation;
  final Duration animationDuration;

  const AnimatedLogoWidget({
    super.key,
    this.size = 100.0,
    this.enableAnimation = true,
    this.animationDuration = const Duration(seconds: 2),
  });

  @override
  State<AnimatedLogoWidget> createState() => _AnimatedLogoWidgetState();
}

class _AnimatedLogoWidgetState extends State<AnimatedLogoWidget>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // 旋转动画控制器
    _rotationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    
    // 缩放动画控制器
    _scaleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    // 淡入淡出动画控制器
    _fadeController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    // 创建动画
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * 3.14159, // 360度转换为弧度
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // 开始动画
    if (widget.enableAnimation) {
      _startAnimations();
    }
  }

  void _startAnimations() {
    _rotationController.repeat();
    _scaleController.repeat(reverse: true);
    _fadeController.repeat(reverse: true);
  }

  void _stopAnimations() {
    _rotationController.stop();
    _scaleController.stop();
    _fadeController.stop();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.enableAnimation) {
          setState(() {
            if (_rotationController.isAnimating) {
              _stopAnimations();
            } else {
              _startAnimations();
            }
          });
        }
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _rotationAnimation,
          _scaleAnimation,
          _fadeAnimation,
        ]),
        builder: (context, child) {
          return Transform.rotate(
            angle: widget.enableAnimation ? _rotationAnimation.value : 0.0,
            child: Transform.scale(
              scale: widget.enableAnimation ? _scaleAnimation.value : 1.0,
              child: Opacity(
                opacity: widget.enableAnimation ? _fadeAnimation.value : 1.0,
                child: SvgPicture.asset(
                  'assets/images/logo.svg',
                  width: widget.size,
                  height: widget.size,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// 自定义动画SVG组件
class CustomAnimatedSvg extends StatefulWidget {
  final String assetPath;
  final double size;
  final Duration duration;
  final List<AnimationType> animationTypes;

  const CustomAnimatedSvg({
    super.key,
    required this.assetPath,
    this.size = 100.0,
    this.duration = const Duration(seconds: 2),
    this.animationTypes = const [AnimationType.rotation, AnimationType.scale],
  });

  @override
  State<CustomAnimatedSvg> createState() => _CustomAnimatedSvgState();
}

class _CustomAnimatedSvgState extends State<CustomAnimatedSvg>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        Widget svgWidget = SvgPicture.asset(
          widget.assetPath,
          width: widget.size,
          height: widget.size,
        );

        // 应用不同的动画效果
        for (var animationType in widget.animationTypes) {
          switch (animationType) {
            case AnimationType.rotation:
              svgWidget = Transform.rotate(
                angle: _animation.value * 2 * 3.14159,
                child: svgWidget,
              );
              break;
            case AnimationType.scale:
              svgWidget = Transform.scale(
                scale: 1.0 + (_animation.value * 0.2),
                child: svgWidget,
              );
              break;
            case AnimationType.fade:
              svgWidget = Opacity(
                opacity: 0.5 + (_animation.value * 0.5),
                child: svgWidget,
              );
              break;
            case AnimationType.translate:
              svgWidget = Transform.translate(
                offset: Offset(
                  _animation.value * 10,
                  _animation.value * 5,
                ),
                child: svgWidget,
              );
              break;
          }
        }

        return svgWidget;
      },
    );
  }
}

enum AnimationType {
  rotation,
  scale,
  fade,
  translate,
}

// 粒子效果SVG动画组件
class ParticleAnimatedSvg extends StatefulWidget {
  final String assetPath;
  final double size;
  final int particleCount;

  const ParticleAnimatedSvg({
    super.key,
    required this.assetPath,
    this.size = 100.0,
    this.particleCount = 20,
  });

  @override
  State<ParticleAnimatedSvg> createState() => _ParticleAnimatedSvgState();
}

class _ParticleAnimatedSvgState extends State<ParticleAnimatedSvg>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  final List<AnimationController> _particleControllers = [];
  final List<Animation<double>> _particleAnimations = [];

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // 创建多个粒子动画
    for (int i = 0; i < widget.particleCount; i++) {
      final controller = AnimationController(
        duration: Duration(milliseconds: 1000 + (i * 100)),
        vsync: this,
      );
      
      final animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ));

      _particleControllers.add(controller);
      _particleAnimations.add(animation);
    }

    _particleController.repeat();
    for (var controller in _particleControllers) {
      controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _particleController.dispose();
    for (var controller in _particleControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 主SVG
        SvgPicture.asset(
          widget.assetPath,
          width: widget.size,
          height: widget.size,
        ),
        
        // 粒子效果
        ...List.generate(widget.particleCount, (index) {
          return AnimatedBuilder(
            animation: _particleAnimations[index],
            builder: (context, child) {
              final progress = _particleAnimations[index].value;
              final angle = (index * 2 * 3.14159) / widget.particleCount;
              final radius = 50.0 + (progress * 30.0);
              
              return Positioned(
                left: widget.size / 2 + radius * cos(angle) - 2,
                top: widget.size / 2 + radius * sin(angle) - 2,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 1 - progress),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          );
        }),
      ],
    );
  }
}

// 数学函数
double cos(double angle) => math.cos(angle);
double sin(double angle) => math.sin(angle);
