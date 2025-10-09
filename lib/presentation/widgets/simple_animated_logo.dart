import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 简单的SVG动画Logo组件
/// 提供基础的旋转、缩放、淡入淡出动画效果
class SimpleAnimatedLogo extends StatefulWidget {
  final double size;
  final bool enableRotation;
  final bool enableScale;
  final bool enableFade;
  final Duration duration;
  final Color? color;

  const SimpleAnimatedLogo({
    super.key,
    this.size = 100.0,
    this.enableRotation = true,
    this.enableScale = false,
    this.enableFade = false,
    this.duration = const Duration(seconds: 2),
    this.color,
  });

  @override
  State<SimpleAnimatedLogo> createState() => _SimpleAnimatedLogoState();
}

class _SimpleAnimatedLogoState extends State<SimpleAnimatedLogo>
    with SingleTickerProviderStateMixin {
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
        Widget logo = SvgPicture.asset(
          'assets/images/logo.svg',
          width: widget.size,
          height: widget.size,
          colorFilter: widget.color != null
              ? ColorFilter.mode(widget.color!, BlendMode.srcIn)
              : null,
        );

        // 应用旋转动画
        if (widget.enableRotation) {
          logo = Transform.rotate(
            angle: _animation.value * 2 * 3.14159,
            child: logo,
          );
        }

        // 应用缩放动画
        if (widget.enableScale) {
          final scale = 1.0 + (_animation.value * 0.3);
          logo = Transform.scale(
            scale: scale,
            child: logo,
          );
        }

        // 应用淡入淡出动画
        if (widget.enableFade) {
          final opacity = 0.5 + (_animation.value * 0.5);
          logo = Opacity(
            opacity: opacity,
            child: logo,
          );
        }

        return logo;
      },
    );
  }
}

/// 脉冲动画Logo
/// 提供呼吸灯效果的Logo动画
class PulsingLogo extends StatefulWidget {
  final double size;
  final Duration duration;
  final Color? color;

  const PulsingLogo({
    super.key,
    this.size = 100.0,
    this.duration = const Duration(seconds: 1),
    this.color,
  });

  @override
  State<PulsingLogo> createState() => _PulsingLogoState();
}

class _PulsingLogoState extends State<PulsingLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.3,
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
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: SvgPicture.asset(
              'assets/images/logo.svg',
              width: widget.size,
              height: widget.size,
              colorFilter: widget.color != null
                  ? ColorFilter.mode(widget.color!, BlendMode.srcIn)
                  : null,
            ),
          ),
        );
      },
    );
  }
}

/// 摇摆动画Logo
/// 提供左右摇摆效果的Logo动画
class WobblingLogo extends StatefulWidget {
  final double size;
  final Duration duration;
  final double wobbleAngle;
  final Color? color;

  const WobblingLogo({
    super.key,
    this.size = 100.0,
    this.duration = const Duration(seconds: 1),
    this.wobbleAngle = 0.1,
    this.color,
  });

  @override
  State<WobblingLogo> createState() => _WobblingLogoState();
}

class _WobblingLogoState extends State<WobblingLogo>
    with SingleTickerProviderStateMixin {
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
      begin: -widget.wobbleAngle,
      end: widget.wobbleAngle,
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
        return Transform.rotate(
          angle: _animation.value,
          child: SvgPicture.asset(
            'assets/images/logo.svg',
            width: widget.size,
            height: widget.size,
            colorFilter: widget.color != null
                ? ColorFilter.mode(widget.color!, BlendMode.srcIn)
                : null,
          ),
        );
      },
    );
  }
}
