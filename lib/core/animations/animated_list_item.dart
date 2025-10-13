import 'package:flutter/material.dart';

/// 列表项动画包装器
/// 提供淡入、滑入等动画效果
class AnimatedListItem extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final AnimationType animationType;

  const AnimatedListItem({
    super.key,
    required this.child,
    required this.index,
    this.delay = const Duration(milliseconds: 50),
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.easeOutCubic,
    this.animationType = AnimationType.fadeSlideUp,
  });

  @override
  State<AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // 淡入动画
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    // 滑动动画
    final slideOffset = _getSlideOffset(widget.animationType);
    _slideAnimation = Tween<Offset>(
      begin: slideOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    // 缩放动画
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    // 延迟后开始动画
    Future.delayed(widget.delay * widget.index, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  Offset _getSlideOffset(AnimationType type) {
    switch (type) {
      case AnimationType.fadeSlideUp:
        return const Offset(0.0, 0.3);
      case AnimationType.fadeSlideDown:
        return const Offset(0.0, -0.3);
      case AnimationType.fadeSlideLeft:
        return const Offset(0.3, 0.0);
      case AnimationType.fadeSlideRight:
        return const Offset(-0.3, 0.0);
      case AnimationType.fadeScale:
      case AnimationType.fade:
        return Offset.zero;
    }
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
        Widget result = widget.child;

        // 根据动画类型应用不同的效果
        switch (widget.animationType) {
          case AnimationType.fadeSlideUp:
          case AnimationType.fadeSlideDown:
          case AnimationType.fadeSlideLeft:
          case AnimationType.fadeSlideRight:
            result = SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: result,
              ),
            );
            break;
          case AnimationType.fadeScale:
            result = ScaleTransition(
              scale: _scaleAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: result,
              ),
            );
            break;
          case AnimationType.fade:
            result = FadeTransition(
              opacity: _fadeAnimation,
              child: result,
            );
            break;
        }

        return result;
      },
    );
  }
}

enum AnimationType {
  fadeSlideUp,
  fadeSlideDown,
  fadeSlideLeft,
  fadeSlideRight,
  fadeScale,
  fade,
}

/// 用于快速创建动画列表
class AnimatedListView extends StatelessWidget {
  final List<Widget> children;
  final Duration itemDelay;
  final Duration itemDuration;
  final Curve curve;
  final AnimationType animationType;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const AnimatedListView({
    super.key,
    required this.children,
    this.itemDelay = const Duration(milliseconds: 50),
    this.itemDuration = const Duration(milliseconds: 400),
    this.curve = Curves.easeOutCubic,
    this.animationType = AnimationType.fadeSlideUp,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemCount: children.length,
      itemBuilder: (context, index) {
        return AnimatedListItem(
          index: index,
          delay: itemDelay,
          duration: itemDuration,
          curve: curve,
          animationType: animationType,
          child: children[index],
        );
      },
    );
  }
}

