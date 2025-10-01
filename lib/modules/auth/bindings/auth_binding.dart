import 'package:get/get.dart';
import 'package:shop_app/data/login_service.dart';
import 'package:shop_app/data/pref/session_pref_impl.dart';
import 'package:shop_app/data/preference.dart';
 import 'package:shop_app/modules/auth/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginServiceProtocol>(() => LoginService());
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<SessionPref>(() => SPrefSessiomImpl());
  }
}
