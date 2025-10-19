import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:luna_arc_sync/l10n/app_localizations.dart';
import 'package:luna_arc_sync/core/theme/background_image_notifier.dart';
import 'package:luna_arc_sync/core/theme/fullscreen_notifier.dart';
import 'package:luna_arc_sync/core/theme/page_navigation_notifier.dart';

const double _kBreakpoint = 720.0; // 设置响应式断点

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    final int selectedIndex = _calculateSelectedIndex(location);

    // 检查当前路由是否不是PageDetailPage，如果不是则清除滑块
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!location.contains('/page/')) {
        context.read<PageNavigationNotifier>().clear();
      }
    });

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
    final pageNavNotifier = context.watch<PageNavigationNotifier>();
    final isFullscreen = context.watch<FullscreenNotifier>().isFullscreen;
    
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
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: Text('User'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
            ],
          ),
        ),
        // 页码滑块 - 只在PageDetailPage显示且非全屏时出现，带动画效果
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
          child: (pageNavNotifier.isPageDetailVisible && 
                  pageNavNotifier.totalPages > 1 && 
                  !isFullscreen)
              ? _buildPageSlider(context, pageNavNotifier, hasCustomBackground)
              : const SizedBox.shrink(),
        ),
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
  Widget _buildPageSlider(BuildContext context, PageNavigationNotifier notifier, bool hasCustomBackground) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: hasCustomBackground 
                ? Colors.white.withOpacity(0.15)
                : colorScheme.outline.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 页码显示 - 更美观的样式
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: hasCustomBackground 
                  ? (isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05))
                  : colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasCustomBackground 
                    ? Colors.white.withOpacity(0.2)
                    : colorScheme.primary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              '${notifier.currentPage}/${notifier.totalPages}',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: hasCustomBackground 
                    ? (isDarkMode ? Colors.white : Colors.black87)
                    : colorScheme.onSurface,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 垂直滑块 - 改进的样式
          SizedBox(
            height: 320,
            width: 48,
            child: RotatedBox(
              quarterTurns: 1,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4,
                  thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: 8,
                    elevation: 2,
                    pressedElevation: 4,
                  ),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                  activeTrackColor: hasCustomBackground
                      ? (isDarkMode ? Colors.white.withOpacity(0.8) : colorScheme.primary)
                      : colorScheme.primary,
                  inactiveTrackColor: hasCustomBackground
                      ? (isDarkMode ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.1))
                      : colorScheme.primary.withOpacity(0.2),
                  thumbColor: hasCustomBackground
                      ? (isDarkMode ? Colors.white : colorScheme.primary)
                      : colorScheme.primary,
                  overlayColor: (hasCustomBackground
                      ? (isDarkMode ? Colors.white : colorScheme.primary)
                      : colorScheme.primary).withOpacity(0.2),
                  valueIndicatorColor: colorScheme.primary,
                  valueIndicatorTextStyle: TextStyle(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: Slider(
                  value: notifier.currentPage.toDouble(),
                  min: 1,
                  max: notifier.totalPages.toDouble(),
                  divisions: notifier.totalPages > 1 ? notifier.totalPages - 1 : null,
                  label: '${notifier.currentPage}',
                  onChanged: (value) {
                    notifier.jumpToPage(value.round());
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // 快捷按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 上一页按钮
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: notifier.currentPage > 1
                      ? () => notifier.jumpToPage(notifier.currentPage - 1)
                      : null,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: hasCustomBackground 
                            ? Colors.white.withOpacity(0.2)
                            : colorScheme.outline.withOpacity(0.3),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.arrow_upward,
                      size: 16,
                      color: notifier.currentPage > 1
                          ? (hasCustomBackground 
                              ? (isDarkMode ? Colors.white : Colors.black87)
                              : colorScheme.primary)
                          : (hasCustomBackground 
                              ? Colors.white.withOpacity(0.3)
                              : colorScheme.onSurface.withOpacity(0.3)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // 下一页按钮
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: notifier.currentPage < notifier.totalPages
                      ? () => notifier.jumpToPage(notifier.currentPage + 1)
                      : null,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: hasCustomBackground 
                            ? Colors.white.withOpacity(0.2)
                            : colorScheme.outline.withOpacity(0.3),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.arrow_downward,
                      size: 16,
                      color: notifier.currentPage < notifier.totalPages
                          ? (hasCustomBackground 
                              ? (isDarkMode ? Colors.white : Colors.black87)
                              : colorScheme.primary)
                          : (hasCustomBackground 
                              ? Colors.white.withOpacity(0.3)
                              : colorScheme.onSurface.withOpacity(0.3)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
      const NavigationDrawerDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person),
        label: Text('User'),
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
    if (location.startsWith('/user')) return 3;
    if (location.startsWith('/settings')) return 4;
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
        context.go('/user');
        break;
      case 4:
        context.go('/settings');
        break;
    }
  }
}
