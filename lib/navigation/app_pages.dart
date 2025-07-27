import 'package:get/get.dart';
import 'package:shop_app/modules/auth/bindings/auth_binding.dart';
import 'package:shop_app/modules/auth/login_screen.dart';
import 'package:shop_app/modules/auth/password_reset_screen.dart';
import 'package:shop_app/modules/auth/password_update_screen.dart';
import 'package:shop_app/modules/bottomNav/binding/botom_nav_binding.dart';
import 'package:shop_app/modules/bottomNav/bottom_nav_screen.dart';
import 'package:shop_app/modules/home/home_screen.dart';
import 'package:shop_app/modules/schedule/bindings/schedule_binding.dart';
import 'package:shop_app/modules/schedule/schedule_detail_screen.dart';
import 'package:shop_app/modules/schedule/schedule_list_screen.dart';
import 'package:shop_app/modules/shop_master/add_shop_screen.dart';
import 'package:shop_app/modules/shop_master/binding/schedule_binding.dart';
import 'package:shop_app/modules/shop_master/controller/shop_master_controller.dart';

import '../modules/manager/binding/manager_binding.dart';
import '../modules/manager/manager_screen.dart';
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
    GetPage(
      name: _Paths.scheduleList,
      page: () => const ScheduleListView(),
      binding: ScheduleBinding(),
    ),
    GetPage(
      name: _Paths.scheduleDetail,
      page: () => const ScheduleDetailView(),
      binding: ScheduleBinding(),
    ),
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
      name: _Paths.passwordUpdate,
      page: () => const UpdatePasswordScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.bottomNavigation,
      page: () => BottomNavScreen(),
      binding: BottomNavBinding(),
    ),
    GetPage(
      name: _Paths.createShop,
      page: () => AddShopMasterScreen(),
      binding: ShopMasterBinding(),
    ),

    GetPage(
      name: _Paths.manager,
      page: () => const ManagerScreen(),
      binding: ManagerBinding(),
    ),
    // GetPage(
    //   name: _Paths.onboarding,
    //   page: () => const OnboardingView(),
    //   binding: OnboardingBinding(),
    // ),
  ];
}
