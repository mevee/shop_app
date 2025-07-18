import 'package:get/get.dart';
import 'package:shop_app/data/app_state_manager.dart';
import 'package:shop_app/data/login_service.dart';
import 'package:shop_app/modules/auth/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginServiceProtocol>(() => LoginService());
    Get.lazyPut<ApplicationState>(() => ApplicationState());
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
