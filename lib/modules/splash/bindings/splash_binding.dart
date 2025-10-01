import 'package:get/get.dart';
import 'package:shop_app/data/preference.dart';
import 'package:shop_app/data/pref/session_pref_impl.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SessionPref>(() => SPrefSessiomImpl());
  }
}
