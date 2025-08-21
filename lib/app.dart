import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:luna_arc_sync/l10n/app_localizations.dart';
import 'package:luna_arc_sync/core/localization/locale_notifier.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:luna_arc_sync/core/di/injection.dart';
import 'package:luna_arc_sync/presentation/auth/cubit/auth_cubit.dart';
import 'package:luna_arc_sync/presentation/auth/cubit/auth_state.dart';
import 'package:luna_arc_sync/presentation/auth/view/login_Page.dart';
import 'package:luna_arc_sync/presentation/shell/main_shell.dart';
import 'package:luna_arc_sync/presentation/overview/view/overview_page.dart';
import 'package:luna_arc_sync/presentation/documents/view/document_list_page.dart'; // 使用 DocumentListPage
import 'package:luna_arc_sync/presentation/settings/view/settings_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>()..checkAuthStatus(),
      child: ChangeNotifierProvider(
        create: (_) => LocaleNotifier(),
        child: const AppView(),
      ),
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
          initialLocation: '/overview',
          routes: [
            GoRoute(
              path: '/login',
              builder: (context, state) => const LoginPage(),
            ),
            ShellRoute(
              builder: (BuildContext context, GoRouterState state, Widget child) {
                return MainShell(child: child);
              },
              routes: [
                GoRoute(
                  path: '/overview',
                  builder: (BuildContext context, GoRouterState state) => const OverviewPage(),
                ),
                GoRoute(
                  path: '/documents',
                  builder: (BuildContext context, GoRouterState state) => const DocumentListPage(),
                ),
                GoRoute(
                  path: '/settings',
                  builder: (BuildContext context, GoRouterState state) => const SettingsPage(),
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
              return '/overview';
            }

            // 其他所有情况都允许通过
            return null;
          },
          // --- END: 完整 redirect 块 ---
        );

        return MaterialApp.router(
          title: 'Luna Arc Sync',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
            useMaterial3: true,
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