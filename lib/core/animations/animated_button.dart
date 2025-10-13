import 'package:flutter/material.dart';

/// 带动画效果的按钮包装器
/// 提供按压、悬停等交互动画效果
class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Duration duration;
  final double pressScale;
  final double hoverScale;
  final bool enabled;

  const AnimatedButton({
    super.key,
    required this.child,
    this.onPressed,
    this.duration = const Duration(milliseconds: 150),
    this.pressScale = 0.95,
    this.hoverScale = 1.03,
    this.enabled = true,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    double scale = 1.0;
    if (widget.enabled && widget.onPressed != null) {
      if (_isPressed) {
        scale = widget.pressScale;
      } else if (_isHovered) {
        scale = widget.hoverScale;
      }
    }

    return MouseRegion(
      onEnter: (_) {
        if (widget.enabled && widget.onPressed != null) {
          setState(() => _isHovered = true);
        }
      },
      onExit: (_) {
        if (widget.enabled && widget.onPressed != null) {
          setState(() => _isHovered = false);
        }
      },
      child: GestureDetector(
        onTapDown: (_) {
          if (widget.enabled && widget.onPressed != null) {
            setState(() => _isPressed = true);
          }
        },
        onTapUp: (_) {
          if (widget.enabled && widget.onPressed != null) {
            setState(() => _isPressed = false);
            widget.onPressed?.call();
          }
        },
        onTapCancel: () {
          if (widget.enabled && widget.onPressed != null) {
            setState(() => _isPressed = false);
          }
        },
        child: AnimatedScale(
          scale: scale,
          duration: widget.duration,
          curve: Curves.easeOutCubic,
          child: widget.child,
        ),
      ),
    );
  }
}

/// 增强的ElevatedButton，带有动画效果
class AnimatedElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final ButtonStyle? style;

  const AnimatedElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      onPressed: onPressed,
      enabled: onPressed != null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
    );
  }
}

/// 增强的OutlinedButton，带有动画效果
class AnimatedOutlinedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final ButtonStyle? style;

  const AnimatedOutlinedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      onPressed: onPressed,
      enabled: onPressed != null,
      child: OutlinedButton(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
    );
  }
}

/// 增强的TextButton，带有动画效果
class AnimatedTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final ButtonStyle? style;

  const AnimatedTextButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      onPressed: onPressed,
      enabled: onPressed != null,
      hoverScale: 1.05,
      child: TextButton(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
    );
  }
}

/// 增强的IconButton，带有动画效果
class AnimatedIconButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String? tooltip;
  final Color? color;
  final double? iconSize;

  const AnimatedIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.tooltip,
    this.color,
    this.iconSize,
  });

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        if (widget.onPressed != null) {
          _controller.forward();
        }
      },
      onExit: (_) {
        if (widget.onPressed != null) {
          _controller.reverse();
        }
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: IconButton(
          icon: Icon(widget.icon, size: widget.iconSize),
          onPressed: widget.onPressed,
          tooltip: widget.tooltip,
          color: widget.color,
        ),
      ),
    );
  }
}

/// 增强的FloatingActionButton，带有动画效果
class AnimatedFAB extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final String? tooltip;
  final Color? backgroundColor;

  const AnimatedFAB({
    super.key,
    required this.onPressed,
    required this.child,
    this.tooltip,
    this.backgroundColor,
  });

  @override
  State<AnimatedFAB> createState() => _AnimatedFABState();
}

class _AnimatedFABState extends State<AnimatedFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        if (widget.onPressed != null) {
          _controller.forward();
        }
      },
      onExit: (_) {
        if (widget.onPressed != null) {
          _controller.reverse();
        }
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: RotationTransition(
          turns: _rotationAnimation,
          child: FloatingActionButton(
            onPressed: widget.onPressed,
            tooltip: widget.tooltip,
            backgroundColor: widget.backgroundColor,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

/// 脉冲式按钮，用于吸引注意力
class PulsingButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Duration pulseDuration;
  final bool isPulsing;

  const PulsingButton({
    super.key,
    required this.child,
    this.onPressed,
    this.pulseDuration = const Duration(milliseconds: 1000),
    this.isPulsing = true,
  });

  @override
  State<PulsingButton> createState() => _PulsingButtonState();
}

class _PulsingButtonState extends State<PulsingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.pulseDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.isPulsing) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(PulsingButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPulsing != oldWidget.isPulsing) {
      if (widget.isPulsing) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.animateTo(0);
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
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: widget.child,
      ),
    );
  }
}

