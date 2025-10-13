import 'package:flutter/material.dart';

/// 可展开的卡片组件
/// 提供流畅的展开/收起动画效果
class ExpandableCard extends StatefulWidget {
  final bool isExpanded;
  final Widget header;
  final Widget content;
  final Duration duration;
  final Curve curve;
  final double? elevation;
  final ShapeBorder? shape;

  const ExpandableCard({
    super.key,
    required this.isExpanded,
    required this.header,
    required this.content,
    this.duration = const Duration(milliseconds: 350),
    this.curve = Curves.easeInOutCubic,
    this.elevation = 4,
    this.shape,
  });

  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.3, 1.0, curve: widget.curve),
    ));

    if (widget.isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(ExpandableCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: widget.elevation,
      shape: widget.shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
      child: Column(
        children: [
          widget.header,
          SizeTransition(
            sizeFactor: _expandAnimation,
            axisAlignment: -1.0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: widget.content,
            ),
          ),
        ],
      ),
    );
  }
}

/// 可展开卡片的头部组件
class ExpandableCardHeader extends StatelessWidget {
  final VoidCallback onTap;
  final bool isExpanded;
  final IconData leadingIcon;
  final String title;
  final Duration animationDuration;

  const ExpandableCardHeader({
    super.key,
    required this.onTap,
    required this.isExpanded,
    required this.leadingIcon,
    required this.title,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          color: Theme.of(context)
              .colorScheme
              .surfaceContainerHighest
              .withValues(alpha: 0.3),
        ),
        child: Row(
          children: [
            AnimatedRotation(
              turns: isExpanded ? 0.125 : 0, // 45度旋转
              duration: animationDuration,
              child: Icon(
                leadingIcon,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: animationDuration,
              child: Icon(
                Icons.keyboard_arrow_down,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 登录成功后的过渡动画组件
class LoginSuccessTransition extends StatefulWidget {
  final bool show;
  final VoidCallback? onComplete;
  final String? message;

  const LoginSuccessTransition({
    super.key,
    required this.show,
    this.onComplete,
    this.message,
  });

  @override
  State<LoginSuccessTransition> createState() => _LoginSuccessTransitionState();
}

class _LoginSuccessTransitionState extends State<LoginSuccessTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _checkScaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: 40,
      ),
    ]).animate(_controller);

    _fadeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
    ]).animate(_controller);

    _checkScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.6, curve: Curves.elasticOut),
    ));

    if (widget.show) {
      _controller.forward().then((_) {
        widget.onComplete?.call();
      });
    }
  }

  @override
  void didUpdateWidget(LoginSuccessTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show != oldWidget.show && widget.show) {
      _controller.forward(from: 0).then((_) {
        widget.onComplete?.call();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.show) return const SizedBox.shrink();

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
        child: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 成功图标
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: ScaleTransition(
                    scale: _checkScaleAnimation,
                    child: Icon(
                      Icons.check_circle,
                      size: 80,
                      color: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // 消息文本
                if (widget.message != null)
                  Text(
                    widget.message!,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

