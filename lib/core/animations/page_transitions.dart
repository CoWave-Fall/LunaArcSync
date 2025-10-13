import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 页面转场动画类型
enum PageTransitionType {
  fade,
  slideFromRight,
  slideFromLeft,
  slideFromBottom,
  scale,
  fadeScale,
  rotation,
}

/// 自定义页面转场动画
class CustomPageTransition {
  /// 创建淡入动画
  static Page<T> fade<T>({
    required Widget child,
    required GoRouterState state,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }

  /// 创建从右侧滑入动画
  static Page<T> slideFromRight<T>({
    required Widget child,
    required GoRouterState state,
    Duration duration = const Duration(milliseconds: 350),
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }

  /// 创建从左侧滑入动画
  static Page<T> slideFromLeft<T>({
    required Widget child,
    required GoRouterState state,
    Duration duration = const Duration(milliseconds: 350),
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }

  /// 创建从底部滑入动画
  static Page<T> slideFromBottom<T>({
    required Widget child,
    required GoRouterState state,
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }

  /// 创建缩放动画
  static Page<T> scale<T>({
    required Widget child,
    required GoRouterState state,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOutCubic;
        var curvedAnimation = CurvedAnimation(parent: animation, curve: curve);

        return ScaleTransition(
          scale: curvedAnimation,
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }

  /// 创建淡入+缩放动画
  static Page<T> fadeScale<T>({
    required Widget child,
    required GoRouterState state,
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOutCubic;
        var curvedAnimation = CurvedAnimation(parent: animation, curve: curve);

        return FadeTransition(
          opacity: curvedAnimation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(curvedAnimation),
            child: child,
          ),
        );
      },
      transitionDuration: duration,
    );
  }

  /// 创建旋转动画
  static Page<T> rotation<T>({
    required Widget child,
    required GoRouterState state,
    Duration duration = const Duration(milliseconds: 500),
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOutCubic;
        var curvedAnimation = CurvedAnimation(parent: animation, curve: curve);

        return FadeTransition(
          opacity: curvedAnimation,
          child: RotationTransition(
            turns: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
            child: child,
          ),
        );
      },
      transitionDuration: duration,
    );
  }

  /// 共享元素转场动画（用于详情页）
  static Page<T> sharedAxisTransition<T>({
    required Widget child,
    required GoRouterState state,
    Duration duration = const Duration(milliseconds: 350),
    SharedAxisTransitionType transitionType = SharedAxisTransitionType.scaled,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOutCubic;
        var curvedAnimation = CurvedAnimation(parent: animation, curve: curve);

        return FadeTransition(
          opacity: curvedAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.1),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          ),
        );
      },
      transitionDuration: duration,
    );
  }
}

enum SharedAxisTransitionType {
  horizontal,
  vertical,
  scaled,
}

