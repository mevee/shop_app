import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_app/data/data_source/drc_local.dart';
import 'package:shop_app/di.dart';
import 'package:shop_app/modules/auth/login_screen.dart';
import 'package:shop_app/modules/bottomNav/bottom_nav_screen.dart';
import 'package:shop_app/modules/schedule/schedule_list_screen.dart';
import 'package:shop_app/modules/splash/views/splash_view.dart';
import 'package:shop_app/navigation/app_pages.dart';

class GoRoutes {
  static GoRouter get router => _router;

  /// The route configuration.
  static final GoRouter _router = GoRouter(
    initialLocation: Routes.splash,
    redirect: (BuildContext context, GoRouterState state) async {
      LocalDataSource localDataSource = getIt<LocalDataSource>();
      // final bool loggingIn = state.subloc == Routes.login;
      final bool loggingIn = await localDataSource.isLogin();

      if (!loggingIn) return Routes.splash;
      if (loggingIn) return Routes.home;
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: Routes.splash,
        builder: (BuildContext context, GoRouterState state) {
          return SplashView();
        },
      ),
      GoRoute(
        path: Routes.scheduleList,
        builder: (BuildContext context, GoRouterState state) {
          return ScheduleListView();
        },
      ),
      GoRoute(
        path: Routes.login,
        builder: (BuildContext context, GoRouterState state) {
          return LoginScreen();
        },
      ),
      GoRoute(
        path: Routes.home,
        builder: (BuildContext context, GoRouterState state) {
          return BottomNavScreen();
        },
        routes: <RouteBase>[
          GoRoute(
            path: Routes.login,
            builder: (BuildContext context, GoRouterState state) {
              return LoginScreen();
            },
          ),
        ],
      ),
    ],
    // urlPathStrategy: UrlPathStrategy.path,
    // urlPathStrategy: UrlPathStrategy.path,
  );
}
