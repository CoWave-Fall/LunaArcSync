import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 动画Logo横幅组件
/// 实现从方形logo到横幅的动画效果：
/// 1. 先显示方形logo
/// 2. logo向左移动到正确位置
/// 3. 显示分隔符
/// 4. 显示文字部分
class AnimatedLogoBanner extends StatefulWidget {
  final double height;
  final Duration animationDuration;
  final Duration delayBetweenSteps;
  final bool autoStart;

  const AnimatedLogoBanner({
    super.key,
    this.height = 120.0,
    this.animationDuration = const Duration(milliseconds: 800),
    this.delayBetweenSteps = const Duration(milliseconds: 200),
    this.autoStart = true,
  });

  @override
  State<AnimatedLogoBanner> createState() => _AnimatedLogoBannerState();
}

class _AnimatedLogoBannerState extends State<AnimatedLogoBanner>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _separatorController;
  late AnimationController _textController;
  
  late Animation<double> _logoScaleAnimation;
  late Animation<Offset> _logoPositionAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _separatorOpacityAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _textSlideAnimation;

  bool _animationStarted = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    
    if (widget.autoStart) {
      _startAnimation();
    }
  }

  void _setupAnimations() {
    // Logo动画控制器
    _logoController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    // 分隔符动画控制器
    _separatorController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // 文字动画控制器
    _textController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Logo缩放动画 - 从1.0缩放到0.7
    _logoScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.7,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    ));

    // Logo位置动画 - 向左移动
    _logoPositionAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0), // 居中
      end: const Offset(-0.25, 0.0), // 向左移动
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.3, 0.7, curve: Curves.easeInOut),
    ));

    // Logo透明度动画
    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.2, curve: Curves.easeIn),
    ));

    // 分隔符透明度动画
    _separatorOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _separatorController,
      curve: Curves.easeIn,
    ));

    // 文字透明度动画
    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    ));

    // 文字滑动动画
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0.2, 0.0), // 从右侧滑入
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    ));
  }

  void _startAnimation() {
    if (_animationStarted) return;
    _animationStarted = true;

    // 启动logo动画
    _logoController.forward().then((_) {
      // Logo动画完成后，延迟启动分隔符动画
      Future.delayed(widget.delayBetweenSteps, () {
        if (mounted) {
          _separatorController.forward().then((_) {
            // 分隔符动画完成后，延迟启动文字动画
            Future.delayed(widget.delayBetweenSteps, () {
              if (mounted) {
                _textController.forward();
              }
            });
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _separatorController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo部分
            AnimatedBuilder(
              animation: _logoController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _logoScaleAnimation.value,
                  child: Transform.translate(
                    offset: Offset(
                      _logoPositionAnimation.value.dx * widget.height * 0.5,
                      _logoPositionAnimation.value.dy * widget.height * 0.5,
                    ),
                    child: Opacity(
                      opacity: _logoOpacityAnimation.value,
                      child: SvgPicture.asset(
                        'assets/images/logo.svg',
                        height: widget.height * 0.8,
                        width: widget.height * 0.8,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );
              },
            ),
            
            // 分隔符部分
            AnimatedBuilder(
              animation: _separatorController,
              builder: (context, child) {
                return Opacity(
                  opacity: _separatorOpacityAnimation.value,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    height: widget.height * 0.5,
                    width: 1.5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).colorScheme.primary.withValues(alpha: 0.0),
                          Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
                          Theme.of(context).colorScheme.primary.withValues(alpha: 0.0),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(0.75),
                    ),
                  ),
                );
              },
            ),
            
            // 文字部分
            AnimatedBuilder(
              animation: _textController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    _textSlideAnimation.value.dx * 50,
                    _textSlideAnimation.value.dy * 50,
                  ),
                  child: Opacity(
                    opacity: _textOpacityAnimation.value,
                    child: Container(
                      height: widget.height,
                      constraints: BoxConstraints(
                        maxWidth: widget.height * 2, // 限制文字部分的最大宽度
                      ),
                      child: SvgPicture.asset(
                        'assets/images/logo_label.svg',
                        height: widget.height,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 手动启动动画
  void startAnimation() {
    _startAnimation();
  }

  /// 重置动画
  void resetAnimation() {
    _animationStarted = false;
    _logoController.reset();
    _separatorController.reset();
    _textController.reset();
  }

  /// 重新播放动画
  void replayAnimation() {
    resetAnimation();
    _startAnimation();
  }
}
