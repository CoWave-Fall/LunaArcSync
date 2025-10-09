import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:luna_arc_sync/presentation/shell/main_shell.dart'; // 我们将很快创建这个文件
import 'package:luna_arc_sync/presentation/pages/view/page_list_page.dart'; // 假设这是您的文档/页面列表页
import 'package:luna_arc_sync/presentation/about/view/about_page.dart';
import 'package:luna_arc_sync/presentation/settings/view/settings_page.dart';
import 'package:luna_arc_sync/presentation/jobs/view/jobs_page.dart';

// 1. 定义一个全局的 navigator key，用于访问根 navigator
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

// 2. 创建 GoRouter 实例
final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/about', // 默认启动页面
  routes: [
    // 3. 定义一个 ShellRoute，这是实现持久化侧边栏的关键
    ShellRoute(
      // 这个 builder 会构建应用的“外壳”（带侧边栏的 Scaffold）
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return MainShell(child: child); // child 是当前匹配到的子路由的页面
      },
      // 定义在 Shell 内部切换的子路由
      routes: [
        GoRoute(
          path: '/about',
          builder: (BuildContext context, GoRouterState state) {
            return const AboutPage(); // 关于页面
          },
        ),
        GoRoute(
          path: '/documents',
          builder: (BuildContext context, GoRouterState state) {
            return const PageListPage(); // 文档（现在是页面）列表
          },
        ),
        GoRoute(
          path: '/settings',
          builder: (BuildContext context, GoRouterState state) {
            return const SettingsPage(); // 设置页面
          },
        ),
        GoRoute(
          path: '/jobs',
          builder: (BuildContext context, GoRouterState state) {
            return const JobsPage();
          },
        ),
      ],
    ),
    // 在这里可以定义不需要 Shell 的其他路由，例如登录页
    // GoRoute(
    //   path: '/login',
    //   builder: (context, state) => const LoginPage(),
    // ),
  ],
);