import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:luna_arc_sync/l10n/app_localizations.dart';
import 'package:luna_arc_sync/core/localization/locale_notifier.dart';
import 'package:luna_arc_sync/core/theme/theme_notifier.dart';
import 'package:luna_arc_sync/core/theme/theme_color_notifier.dart';
import 'package:luna_arc_sync/core/theme/background_image_notifier.dart';
import 'package:luna_arc_sync/core/theme/font_notifier.dart';
import 'package:luna_arc_sync/core/theme/fullscreen_notifier.dart';
import 'package:luna_arc_sync/core/theme/page_navigation_notifier.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:luna_arc_sync/core/di/injection.dart';
import 'package:luna_arc_sync/presentation/auth/cubit/auth_cubit.dart';
import 'package:luna_arc_sync/presentation/auth/cubit/auth_state.dart';
import 'package:luna_arc_sync/presentation/auth/view/login_Page.dart';
import 'package:luna_arc_sync/presentation/shell/main_shell.dart';
import 'package:luna_arc_sync/presentation/about/view/about_page.dart';
import 'package:luna_arc_sync/presentation/documents/view/document_list_page.dart'; // 使用 DocumentListPage
import 'package:luna_arc_sync/presentation/settings/view/settings_page.dart';
import 'package:luna_arc_sync/presentation/settings/notifiers/grid_settings_notifier.dart';
import 'package:luna_arc_sync/presentation/settings/notifiers/precaching_settings_notifier.dart';
import 'package:luna_arc_sync/core/theme/glassmorphic_performance_notifier.dart';
import 'package:luna_arc_sync/presentation/search/view/search_page.dart';
import 'package:luna_arc_sync/presentation/jobs/view/jobs_page.dart';
import 'package:luna_arc_sync/presentation/jobs/cubit/jobs_cubit.dart';
import 'package:luna_arc_sync/presentation/user/cubit/user_cubit.dart';
import 'package:luna_arc_sync/presentation/user/view/user_profile_page.dart';
import 'package:luna_arc_sync/presentation/user/view/admin_users_page.dart';
import 'package:luna_arc_sync/presentation/pages/svg_animation_demo_page.dart';
import 'package:luna_arc_sync/presentation/pages/simple_animation_example_page.dart';
import 'package:luna_arc_sync/core/animations/page_transitions.dart';
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider.value(
          value: getIt<AuthCubit>()..checkAuthStatus(),
        ),
        BlocProvider.value(
          value: getIt<JobsCubit>(),
        ),
        BlocProvider.value(
          value: getIt<UserCubit>(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocaleNotifier(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeNotifier(),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<ThemeColorNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<BackgroundImageNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<FontNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<GridSettingsNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<PrecachingSettingsNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<GlassmorphicPerformanceNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => FullscreenNotifier(),
        ),
        ChangeNotifierProvider(
          create: (_) => PageNavigationNotifier(),
        ),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final router = GoRouter(
          refreshListenable: GoRouterRefreshStream(context.read<AuthCubit>().stream),
          navigatorKey: _rootNavigatorKey,
          initialLocation: '/about',
          routes: [
            GoRoute(
              path: '/login',
              pageBuilder: (context, state) => CustomPageTransition.fadeScale(
                child: const LoginPage(),
                state: state,
              ),
            ),
            GoRoute(
              path: '/search',
              pageBuilder: (context, state) => CustomPageTransition.slideFromBottom(
                child: const SearchPage(),
                state: state,
              ),
            ),
            ShellRoute(
              builder: (BuildContext context, GoRouterState state, Widget child) {
                return MainShell(child: child);
              },
              routes: [
                GoRoute(
                  path: '/about',
                  pageBuilder: (BuildContext context, GoRouterState state) => 
                    CustomPageTransition.fade(
                      child: const AboutPage(),
                      state: state,
                    ),
                ),
                GoRoute(
                  path: '/documents',
                  pageBuilder: (BuildContext context, GoRouterState state) => 
                    CustomPageTransition.fade(
                      child: const DocumentListPage(),
                      state: state,
                    ),
                ),
                GoRoute(
                  path: '/settings',
                  pageBuilder: (BuildContext context, GoRouterState state) => 
                    CustomPageTransition.fade(
                      child: const SettingsPage(),
                      state: state,
                    ),
                ),
                GoRoute(
                  path: '/jobs',
                  pageBuilder: (BuildContext context, GoRouterState state) => 
                    CustomPageTransition.fade(
                      child: const JobsPage(),
                      state: state,
                    ),
                ),
                GoRoute(
                  path: '/user',
                  pageBuilder: (BuildContext context, GoRouterState state) => 
                    CustomPageTransition.fade(
                      child: const UserProfilePage(),
                      state: state,
                    ),
                ),
                GoRoute(
                  path: '/admin/users',
                  pageBuilder: (BuildContext context, GoRouterState state) => 
                    CustomPageTransition.fade(
                      child: const AdminUsersPage(),
                      state: state,
                    ),
                ),
                GoRoute(
                  path: '/svg-animation-demo',
                  pageBuilder: (BuildContext context, GoRouterState state) => 
                    CustomPageTransition.fade(
                      child: const SvgAnimationDemoPage(),
                      state: state,
                    ),
                ),
                GoRoute(
                  path: '/simple-animation-example',
                  pageBuilder: (BuildContext context, GoRouterState state) => 
                    CustomPageTransition.fade(
                      child: const SimpleAnimationExamplePage(),
                      state: state,
                    ),
                ),
              ],
            ),
          ],
          // --- START: 这一次是包含了完整逻辑的 redirect 块 ---
          redirect: (BuildContext context, GoRouterState state) {
            final authState = context.read<AuthCubit>().state;
            final location = state.matchedLocation;

            // 明确计算登录状态
            final isLoggedIn = authState.maybeWhen(authenticated: (_, _, _) => true, orElse: () => false);
            final isLoggingIn = location == '/login';

            // 核心规则 1：未登录用户只能访问 /login 页面
            if (!isLoggedIn) {
              // 如果他们没登录，并且不在登录页，强制他们去登录页
              return isLoggingIn ? null : '/login';
            }

            // 核心规则 2：已登录用户不能访问 /login 页面
            if (isLoggedIn && isLoggingIn) {
              // 如果他们登录了，还想去登录页，把他们踢回主页
              return '/about';
            }

            // 其他所有情况都允许通过
            return null;
          },
          // --- END: 完整 redirect 块 ---
        );

        final fontNotifier = context.watch<FontNotifier>();
        final selectedFont = fontNotifier.selectedFont;
        final fontFamily = FontNotifier.availableFonts
            .firstWhere((font) => font.name == selectedFont)
            .fontFamily;
        
        final themeColor = context.watch<ThemeColorNotifier>().themeColor;
        final backgroundImageNotifier = context.watch<BackgroundImageNotifier>();
        
        // 根据背景图片自动切换主题
        final themeNotifier = context.watch<ThemeNotifier>();
        final effectiveThemeMode = backgroundImageNotifier.autoThemeSwitchEnabled &&
                backgroundImageNotifier.hasCustomBackground &&
                backgroundImageNotifier.recommendedThemeMode != null
            ? backgroundImageNotifier.recommendedThemeMode!
            : themeNotifier.themeMode;

        return MaterialApp.router(
          title: '泠月案阁',
          themeMode: effectiveThemeMode,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: themeColor),
            useMaterial3: true,
            fontFamily: fontFamily,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: themeColor, brightness: Brightness.dark),
            useMaterial3: true,
            fontFamily: fontFamily,
          ),
          routerConfig: router,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
                                        supportedLocales: const [
            Locale('en'), // English
            Locale('zh'), // Chinese
          ],
          locale: context.watch<LocaleNotifier>().locale,);
          
      },
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');