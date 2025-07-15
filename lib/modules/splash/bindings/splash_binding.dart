import 'package:get/get.dart';
import 'package:shop_app/data/app_state_manager.dart';
import 'package:shop_app/data/user_manager.dart';


class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApplicationState>(() => ApplicationState());
    Get.lazyPut<UserManager>(() => UserManager());
  }
}
