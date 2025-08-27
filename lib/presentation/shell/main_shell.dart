import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatelessWidget {
  final Widget child; // 由 GoRouter 传入的当前页面

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // 获取当前的路由路径，用于高亮显示侧边栏的选中项
    final String location = GoRouterState.of(context).uri.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Luna Arc Sync'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {
              context.go('/search');
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          // 左侧导航栏
          NavigationRail(
            selectedIndex: _calculateSelectedIndex(location),
            onDestinationSelected: (int index) {
              // 当用户点击导航项时，使用 go_router 进行页面跳转
              _onItemTapped(index, context);
            },
            labelType: NavigationRailLabelType.all,
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Overview'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.folder_outlined),
                selectedIcon: Icon(Icons.folder),
                label: Text('Documents'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // 右侧主内容区
          Expanded(
            child: child, // 显示 GoRouter 匹配到的当前页面
          ),
        ],
      ),
    );
  }

  // 根据当前路由路径计算哪个导航项应该被选中
  int _calculateSelectedIndex(String location) {
    if (location.startsWith('/documents')) {
      return 1;
    }
    if (location.startsWith('/settings')) {
      return 2;
    }
    // 默认为概览页
    return 0;
  }

  // 处理导航项点击事件
  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/overview');
        break;
      case 1:
        context.go('/documents');
        break;
      case 2:
        context.go('/settings');
        break;
    }
  }
}