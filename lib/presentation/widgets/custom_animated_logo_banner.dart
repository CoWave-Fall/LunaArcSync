import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luna_arc_sync/l10n/app_localizations.dart';

/// 自定义动画Logo横幅组件
/// 实现效果：
/// 1. 渐入无背景logo在中央
/// 2. 缓动向左移动
/// 3. 显示蓝色矩形分割符 (#13237b)
/// 4. 显示"泠月案阁"文字 (#13237b, LXGW Wenkai Mono字体)
class CustomAnimatedLogoBanner extends StatefulWidget {
  final double height;
  final Duration animationDuration;
  final Duration delayBetweenSteps;
  final bool autoStart;

  const CustomAnimatedLogoBanner({
    super.key,
    this.height = 120.0,
    this.animationDuration = const Duration(milliseconds: 400),
    this.delayBetweenSteps = const Duration(milliseconds: 200),
    this.autoStart = true,
  });

  @override
  State<CustomAnimatedLogoBanner> createState() => _CustomAnimatedLogoBannerState();
}

class _CustomAnimatedLogoBannerState extends State<CustomAnimatedLogoBanner>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _separatorController;
  late AnimationController _textController;
  
  late Animation<double> _logoOpacityAnimation;
  late Animation<Offset> _logoPositionAnimation;
  late Animation<double> _separatorOpacityAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _textSpacingAnimation;

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

    // Logo透明度动画 - 渐入效果（使用整个动画时长）
    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeIn,
    ));

    // Logo位置动画 - 直接在最终位置（不移动）
    _logoPositionAnimation = Tween<Offset>(
      begin: const Offset(-0.25, 0.0), // 直接在最终位置
      end: const Offset(-0.25, 0.0), // 保持不变
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.5, 1, curve: Curves.easeInOut),
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

    // 文字滑动动画 - 使用缓动曲线
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0.2, 0.0), // 从右侧滑入
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic, // 使用缓动曲线
    ));

    // 文字间距动画 - 从大间距到小间距
    _textSpacingAnimation = Tween<double>(
      begin: 6.0, // 初始间距较大 (类似{1,3,5,7})
      end: 2.0,   // 最终间距较小 (类似{1,2,3,4})
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
    ));
  }

  void _startAnimation() {
    if (_animationStarted) return;
    _animationStarted = true;

    // Logo和分隔符同时淡入（400ms）
    _logoController.forward();
    _separatorController.forward().then((_) {
      // Logo和分隔符淡入完成后，延迟启动文字动画
      Future.delayed(widget.delayBetweenSteps, () {
        if (mounted) {
          // 文字淡入+滑入（600ms，缓动效果）
          _textController.forward();
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            // 根据屏幕宽度调整布局
            final isNarrowScreen = constraints.maxWidth < 400;
            
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
            // Logo部分 - 无背景logo
            AnimatedBuilder(
              animation: _logoController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    _logoPositionAnimation.value.dx * widget.height * 0.5,
                    _logoPositionAnimation.value.dy * widget.height * 0.5,
                  ),
                  child: Opacity(
                    opacity: _logoOpacityAnimation.value,
                    child: SvgPicture.asset(
                      'assets/images/logo_no_background.svg',
                      height: widget.height * 0.8,
                      width: widget.height * 0.8,
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),
            
            // 分隔符部分 - 蓝色矩形
            AnimatedBuilder(
              animation: _separatorController,
              builder: (context, child) {
                return Opacity(
                  opacity: _separatorOpacityAnimation.value,
                  child: Container(
                    margin: const EdgeInsets.only(left: 8, right: 32),
                    height: widget.height * 0.6,
                    width: 3,
                    decoration: BoxDecoration(
                      color: const Color(0xFF13237B), // #13237b
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                  ),
                );
              },
            ),
            
            // 文字部分 - 应用标题
            Flexible(
              child: AnimatedBuilder(
                animation: _textController,
                builder: (context, child) {
                  final l10n = AppLocalizations.of(context)!;
                  final titleText = l10n.appTitleCharacters;
                  
                  return Transform.translate(
                    offset: Offset(
                      _textSlideAnimation.value.dx * 200,
                      _textSlideAnimation.value.dy * 50,
                    ),
                    child: Opacity(
                      opacity: _textOpacityAnimation.value,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: titleText.split('').map((char) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  char,
                                  style: TextStyle(
                                    fontSize: isNarrowScreen 
                                        ? widget.height * 0.3  // 窄屏幕使用更小的字体
                                        : widget.height * 0.4,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF13237B), // #13237b
                                    fontFamily: 'LXGWWenKaiMono',
                                  ),
                                ),
                                if (char != titleText.split('').last)
                                  SizedBox(width: isNarrowScreen 
                                      ? _textSpacingAnimation.value * 0.7  // 窄屏幕使用更小的间距
                                      : _textSpacingAnimation.value),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
              ],
            );
          },
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
