import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luna_arc_sync/l10n/app_localizations.dart';

const double _kBreakpoint = 720.0; // 设置响应式断点

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    final int selectedIndex = _calculateSelectedIndex(location);

    // 使用 LayoutBuilder 来根据屏幕宽度选择不同的布局
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > _kBreakpoint) {
          // 宽屏布局
          return _buildWideLayout(context, selectedIndex);
        } else {
          // 窄屏布局
          return _buildNarrowLayout(context, selectedIndex);
        }
      },
    );
  }

  // 宽屏布局
  Widget _buildWideLayout(BuildContext context, int selectedIndex) {
    return Scaffold(
      body: Row(
        children: [
          // 左侧图标导航栏
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) => _onItemTapped(index, context),
            labelType: NavigationRailLabelType.none,
            // 顶部区域，包含 Logo
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                // Logo
                SvgPicture.asset(
                  'assets/images/logo_no_background.svg',
                  width: 32,
                  height: 32,
                  placeholderBuilder: (context) => const Icon(Icons.hexagon_outlined, size: 32),
                ),
                const SizedBox(height: 24),
              ],
            ),
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.info_outlined),
                selectedIcon: Icon(Icons.info),
                label: Text('About'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.folder_outlined),
                selectedIcon: Icon(Icons.folder),
                label: Text('Documents'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.work_outline),
                selectedIcon: Icon(Icons.work),
                label: Text('Jobs'),
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
            child: child,
          ),
        ],
      ),
    );
  }

  // 窄屏布局
  Widget _buildNarrowLayout(BuildContext context, int selectedIndex) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
      ),
      drawer: Drawer(
        child: NavigationDrawer(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            Navigator.pop(context); // 点击后关闭抽屉
            _onItemTapped(index, context);
          },
          children: _buildDrawerDestinations(context),
        ),
      ),
      body: child,
    );
  }

  // 抽屉的导航目的地
  List<Widget> _buildDrawerDestinations(BuildContext context) {
    return [
      // 抽屉顶部的 Logo
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Center(
          child: SvgPicture.asset(
            'assets/images/logo_no_background.svg',
            width: 40,
            height: 40,
            placeholderBuilder: (context) => Icon(Icons.hexagon_outlined, size: 40, color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
      const NavigationDrawerDestination(
        icon: Icon(Icons.info_outlined),
        selectedIcon: Icon(Icons.info),
        label: Text('About'),
      ),
      const NavigationDrawerDestination(
        icon: Icon(Icons.folder_outlined),
        selectedIcon: Icon(Icons.folder),
        label: Text('Documents'),
      ),
      const NavigationDrawerDestination(
        icon: Icon(Icons.work_outline),
        selectedIcon: Icon(Icons.work),
        label: Text('Jobs'),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 28),
        child: Divider(),
      ),
      const NavigationDrawerDestination(
        icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings),
        label: Text('Settings'),
      ),
    ];
  }

  // 根据路径计算选中索引
  int _calculateSelectedIndex(String location) {
    if (location.startsWith('/documents')) return 1;
    if (location.startsWith('/jobs')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0; // About page
  }

  // 导航项点击事件
  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/about');
        break;
      case 1:
        context.go('/documents');
        break;
      case 2:
        context.go('/jobs');
        break;
      case 3:
        context.go('/settings');
        break;
    }
  }
}
