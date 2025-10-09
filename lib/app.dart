import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:luna_arc_sync/l10n/app_localizations.dart';
import 'package:luna_arc_sync/core/localization/locale_notifier.dart';
import 'package:luna_arc_sync/core/theme/theme_notifier.dart';
import 'package:luna_arc_sync/core/theme/font_notifier.dart';
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
import 'package:luna_arc_sync/presentation/search/view/search_page.dart';
import 'package:luna_arc_sync/presentation/jobs/view/jobs_page.dart';
import 'package:luna_arc_sync/presentation/jobs/cubit/jobs_cubit.dart';
import 'package:luna_arc_sync/presentation/pages/svg_animation_demo_page.dart';
import 'package:luna_arc_sync/presentation/pages/simple_animation_example_page.dart';
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
        ChangeNotifierProvider(
          create: (_) => LocaleNotifier(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeNotifier(),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<FontNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<GridSettingsNotifier>(),
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
              builder: (context, state) => const LoginPage(),
            ),
            GoRoute(
              path: '/search',
              builder: (context, state) => const SearchPage(),
            ),
            ShellRoute(
              builder: (BuildContext context, GoRouterState state, Widget child) {
                return MainShell(child: child);
              },
              routes: [
                GoRoute(
                  path: '/about',
                  builder: (BuildContext context, GoRouterState state) => const AboutPage(),
                ),
                GoRoute(
                  path: '/documents',
                  builder: (BuildContext context, GoRouterState state) => const DocumentListPage(),
                ),
                GoRoute(
                  path: '/settings',
                  builder: (BuildContext context, GoRouterState state) => const SettingsPage(),
                ),
                GoRoute(
                  path: '/jobs',
                  builder: (BuildContext context, GoRouterState state) => const JobsPage(),
                ),
                GoRoute(
                  path: '/svg-animation-demo',
                  builder: (BuildContext context, GoRouterState state) => const SvgAnimationDemoPage(),
                ),
                GoRoute(
                  path: '/simple-animation-example',
                  builder: (BuildContext context, GoRouterState state) => const SimpleAnimationExamplePage(),
                ),
              ],
            ),
          ],
          // --- START: 这一次是包含了完整逻辑的 redirect 块 ---
          redirect: (BuildContext context, GoRouterState state) {
            final authState = context.read<AuthCubit>().state;
            final location = state.matchedLocation;

            // 明确计算登录状态
            final isLoggedIn = authState.maybeWhen(authenticated: (_) => true, orElse: () => false);
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

        return MaterialApp.router(
          title: '泠月案阁',
          themeMode: context.watch<ThemeNotifier>().themeMode,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
            useMaterial3: true,
            fontFamily: fontFamily,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan, brightness: Brightness.dark),
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