import 'package:get/get.dart';
import 'package:shop_app/screens/auth/password_reset_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home/home_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';

  static final routes = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: login,
      page: () => const LoginScreen(),
    ),
     GetPage(
      name: forgotPassword,
      page: () => const PasswordResetScreen(),
    ),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
    ),
  ];
} 