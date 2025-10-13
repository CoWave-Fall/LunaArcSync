import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:luna_arc_sync/l10n/app_localizations.dart';
import 'package:luna_arc_sync/core/theme/background_image_notifier.dart';
import 'package:luna_arc_sync/core/theme/fullscreen_notifier.dart';
// TODO: 暂时注释掉滑块功能，留到以后解决
// import 'package:luna_arc_sync/core/theme/page_navigation_notifier.dart';

const double _kBreakpoint = 720.0; // 设置响应式断点

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    final int selectedIndex = _calculateSelectedIndex(location);

    // 检查当前路由是否不是PageDetailPage，如果不是则隐藏滑块
    // TODO: 暂时注释掉滑块功能，留到以后解决
    /*
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!location.contains('/page/')) {
        context.read<PageNavigationNotifier>().forceHide();
      }
    });
    */

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
    final backgroundNotifier = context.watch<BackgroundImageNotifier>();
    final hasCustomBackground = backgroundNotifier.hasCustomBackground;
    final isFullscreen = context.watch<FullscreenNotifier>().isFullscreen;

    return Scaffold(
      body: Stack(
        children: [
          // 背景图片（仅在有自定义背景时显示）
          if (hasCustomBackground && backgroundNotifier.backgroundImageBytes != null)
            Positioned.fill(
              child: Image.memory(
                backgroundNotifier.backgroundImageBytes!,
                fit: BoxFit.cover,
              ),
            ),
          
          // 主内容
          Row(
            children: [
              // 左侧导航栏（带毛玻璃效果）- 全屏时带动画隐藏
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: !isFullscreen
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildGlassmorphicNavigationRail(context, selectedIndex, hasCustomBackground),
                          if (!hasCustomBackground) const VerticalDivider(thickness: 1, width: 1),
                        ],
                      )
                    : const SizedBox(width: 0),
              ),
              
              // 右侧主内容区
              Expanded(
                child: child,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGlassmorphicNavigationRail(BuildContext context, int selectedIndex, bool hasCustomBackground) {
    // TODO: 暂时注释掉滑块功能，留到以后解决
    // final pageNavNotifier = context.watch<PageNavigationNotifier>();
    
    final railContent = Column(
      children: [
        Expanded(
          child: NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) => _onItemTapped(index, context),
            labelType: NavigationRailLabelType.none,
            backgroundColor: hasCustomBackground ? Colors.transparent : null,
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
        ),
        // 页码滑块 - 只在PageDetailPage显示时出现，带动画效果
        // TODO: 暂时注释掉滑块功能，留到以后解决
        /*
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              )),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: (pageNavNotifier.isPageDetailVisible && pageNavNotifier.totalPages > 1)
              ? _buildPageSlider(context, pageNavNotifier, hasCustomBackground)
              : const SizedBox.shrink(),
        ),
        */
      ],
    );

    if (!hasCustomBackground) {
      return railContent;
    }

    // 有自定义背景时，添加毛玻璃效果
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.3),
            border: Border(
              right: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
          child: railContent,
        ),
      ),
    );
  }
  
  // 构建页码滑块
  // TODO: 暂时注释掉滑块功能，留到以后解决
  /*
  Widget _buildPageSlider(BuildContext context, PageNavigationNotifier notifier, bool hasCustomBackground) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: hasCustomBackground 
                ? Colors.white.withValues(alpha: 0.1)
                : Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 页码显示
          Text(
            '${notifier.currentPage}/${notifier.totalPages}',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          // 垂直滑块 - 旋转180度并延长长度
          SizedBox(
            height: 300, // 延长滑块长度从200到300
            width: 40,
            child: RotatedBox(
              quarterTurns: 1, // 旋转180度（从3改为1）
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 3,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                ),
                child: Slider(
                  value: notifier.currentPage.toDouble(),
                  min: 1,
                  max: notifier.totalPages.toDouble(),
                  divisions: notifier.totalPages - 1,
                  onChanged: (value) {
                    notifier.jumpToPage(value.round());
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  */

  // 窄屏布局
  Widget _buildNarrowLayout(BuildContext context, int selectedIndex) {
    final backgroundNotifier = context.watch<BackgroundImageNotifier>();
    final hasCustomBackground = backgroundNotifier.hasCustomBackground;

    return Scaffold(
      extendBodyBehindAppBar: hasCustomBackground,
      appBar: _buildGlassmorphicAppBar(context, hasCustomBackground),
      drawer: _buildGlassmorphicDrawer(context, selectedIndex, hasCustomBackground),
      body: Stack(
        children: [
          // 背景图片（仅在有自定义背景时显示）
          if (hasCustomBackground && backgroundNotifier.backgroundImageBytes != null)
            Positioned.fill(
              child: Image.memory(
                backgroundNotifier.backgroundImageBytes!,
                fit: BoxFit.cover,
              ),
            ),
          
          // 主内容
          child,
        ],
      ),
    );
  }

  PreferredSizeWidget _buildGlassmorphicAppBar(BuildContext context, bool hasCustomBackground) {
    final appBar = AppBar(
      title: Text(AppLocalizations.of(context)!.appTitle),
      backgroundColor: hasCustomBackground ? Colors.transparent : null,
      elevation: hasCustomBackground ? 0 : null,
    );

    if (!hasCustomBackground) {
      return appBar;
    }

    // 有自定义背景时，AppBar使用毛玻璃效果
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.3),
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: appBar,
          ),
        ),
      ),
    );
  }

  Widget _buildGlassmorphicDrawer(BuildContext context, int selectedIndex, bool hasCustomBackground) {
    final drawer = NavigationDrawer(
      selectedIndex: selectedIndex,
      backgroundColor: hasCustomBackground ? Colors.transparent : null,
      onDestinationSelected: (index) {
        Navigator.pop(context); // 点击后关闭抽屉
        _onItemTapped(index, context);
      },
      children: _buildDrawerDestinations(context),
    );

    if (!hasCustomBackground) {
      return Drawer(child: drawer);
    }

    // 有自定义背景时，Drawer使用毛玻璃效果
    return Drawer(
      backgroundColor: Colors.transparent,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.3),
            ),
            child: drawer,
          ),
        ),
      ),
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
