import 'package:get/get.dart';
import 'package:shop_app/modules/auth/bindings/auth_binding.dart';
import 'package:shop_app/modules/auth/login_screen.dart';
import 'package:shop_app/modules/auth/password_reset_screen.dart';
import 'package:shop_app/modules/bottomNav/binding/botom_nav_binding.dart';
import 'package:shop_app/modules/bottomNav/bottom_nav_screen.dart';
import 'package:shop_app/modules/home/home_screen.dart';

import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.passwordReset;

  static final routes = [
    GetPage(
      name: _Paths.home,
      page: () => const HomeScreen(),
      // binding: HomeBinding(),
    ),
    // GetPage(
    //   name: _Paths.history,
    //   page: () => const HistoryView(),
    //   binding: HistoryBinding(),
    // ),
    GetPage(
      name: _Paths.splash,
      page: () => const SplashView(),
      // binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.passwordReset,
      page: () => const PasswordResetScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.bottomNavigation,
      page: () => BottomNavScreen(),
      binding: BottomNavBinding(),
    ),
    // GetPage(
    //   name: _Paths.profile,
    //   page: () => const ProfileView(),
    //   binding: ProfileBinding(),
    // ),
    // GetPage(
    //   name: _Paths.onboarding,
    //   page: () => const OnboardingView(),
    //   binding: OnboardingBinding(),
    // ),
  ];
}
